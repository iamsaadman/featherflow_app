from rest_framework import generics, status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.utils import timezone
from django.db.models import Sum, Count, Q, Avg
from datetime import timedelta

from .models import Worker, Attendance, WorkSchedule, Task, Wage, DailyLog
from .serializers import (
    WorkerSerializer, AttendanceSerializer, WorkScheduleSerializer,
    TaskSerializer, WageSerializer, DailyLogSerializer,
)


# ── Workers ───────────────────────────────────────────────
class WorkerListCreateView(generics.ListCreateAPIView):
    queryset = Worker.objects.filter(is_active=True)
    serializer_class = WorkerSerializer


class WorkerDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Worker.objects.all()
    serializer_class = WorkerSerializer


# ── Attendance ────────────────────────────────────────────
class AttendanceListCreateView(generics.ListCreateAPIView):
    serializer_class = AttendanceSerializer

    def get_queryset(self):
        qs = Attendance.objects.all()
        date = self.request.query_params.get('date')
        worker = self.request.query_params.get('worker')
        if date:
            qs = qs.filter(date=date)
        if worker:
            qs = qs.filter(worker_id=worker)
        return qs


@api_view(['GET'])
def today_attendance(request):
    """Get today's attendance for all active workers."""
    today = timezone.now().date()
    workers = Worker.objects.filter(is_active=True)
    result = []
    for w in workers:
        att = Attendance.objects.filter(worker=w, date=today).first()
        result.append({
            'worker_id': w.id,
            'worker_name': w.name,
            'worker_role': w.role,
            'worker_avatar': w.avatar,
            'status': att.status if att else 'Not Marked',
            'check_in': str(att.check_in) if att and att.check_in else None,
            'check_out': str(att.check_out) if att and att.check_out else None,
        })
    return Response(result)


@api_view(['POST'])
def bulk_mark_attendance(request):
    """Mark attendance for multiple workers at once.
    Expects: { "date": "2026-05-09", "records": [{"worker_id": 1, "status": "Present"}, ...] }
    """
    date = request.data.get('date', str(timezone.now().date()))
    records = request.data.get('records', [])
    created = 0
    for rec in records:
        worker_id = rec.get('worker_id')
        att_status = rec.get('status', 'Present')
        if worker_id:
            Attendance.objects.update_or_create(
                worker_id=worker_id, date=date,
                defaults={'status': att_status}
            )
            created += 1
    return Response({'message': f'{created} attendance records saved.', 'date': date}, status=status.HTTP_200_OK)


# ── Work Schedules ────────────────────────────────────────
class ScheduleListCreateView(generics.ListCreateAPIView):
    serializer_class = WorkScheduleSerializer

    def get_queryset(self):
        qs = WorkSchedule.objects.all()
        date = self.request.query_params.get('date')
        worker = self.request.query_params.get('worker')
        if date:
            qs = qs.filter(date=date)
        if worker:
            qs = qs.filter(worker_id=worker)
        return qs


class ScheduleDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = WorkSchedule.objects.all()
    serializer_class = WorkScheduleSerializer


# ── Tasks ─────────────────────────────────────────────────
class TaskListCreateView(generics.ListCreateAPIView):
    serializer_class = TaskSerializer

    def get_queryset(self):
        qs = Task.objects.all()
        worker = self.request.query_params.get('worker')
        task_status = self.request.query_params.get('status')
        if worker:
            qs = qs.filter(worker_id=worker)
        if task_status:
            qs = qs.filter(status=task_status)
        return qs


class TaskDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Task.objects.all()
    serializer_class = TaskSerializer


# ── Wages ─────────────────────────────────────────────────
class WageListCreateView(generics.ListCreateAPIView):
    serializer_class = WageSerializer

    def get_queryset(self):
        qs = Wage.objects.all()
        worker = self.request.query_params.get('worker')
        is_paid = self.request.query_params.get('is_paid')
        if worker:
            qs = qs.filter(worker_id=worker)
        if is_paid is not None:
            qs = qs.filter(is_paid=is_paid.lower() == 'true')
        return qs


class WageDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Wage.objects.all()
    serializer_class = WageSerializer


@api_view(['POST'])
def mark_wage_paid(request, pk):
    """Mark a wage record as paid."""
    try:
        wage = Wage.objects.get(pk=pk)
        wage.is_paid = True
        wage.paid_date = timezone.now().date()
        wage.save()
        return Response(WageSerializer(wage).data)
    except Wage.DoesNotExist:
        return Response({'error': 'Wage not found'}, status=status.HTTP_404_NOT_FOUND)


# ── Dashboard / Analytics ─────────────────────────────────
@api_view(['GET'])
def dashboard(request):
    """Returns a comprehensive analytics summary for the farmer."""
    today = timezone.now().date()
    last_30 = today - timedelta(days=30)
    workers = Worker.objects.filter(is_active=True)
    total_workers = workers.count()

    # Today's attendance
    today_att = Attendance.objects.filter(date=today)
    present_today = today_att.filter(status='Present').count()
    absent_today = today_att.filter(status='Absent').count()
    late_today = today_att.filter(status='Late').count()
    unmarked_today = total_workers - today_att.count()

    # 30-day attendance rate
    att_30d = Attendance.objects.filter(date__gte=last_30)
    total_records = att_30d.count()
    present_records = att_30d.filter(status__in=['Present', 'Late', 'Half-Day']).count()
    avg_attendance = round((present_records / total_records * 100), 1) if total_records > 0 else 0

    # Tasks
    all_tasks = Task.objects.all()
    pending_tasks = all_tasks.filter(status='Pending').count()
    in_progress_tasks = all_tasks.filter(status='In Progress').count()
    completed_tasks = all_tasks.filter(status='Completed').count()
    total_tasks = all_tasks.count()
    completion_rate = round((completed_tasks / total_tasks * 100), 1) if total_tasks > 0 else 0

    # Wages
    total_payable = Wage.objects.filter(is_paid=False).aggregate(s=Sum('total'))['s'] or 0
    total_paid = Wage.objects.filter(is_paid=True, date__gte=last_30).aggregate(s=Sum('total'))['s'] or 0

    return Response({
        'total_workers': total_workers,
        'today': {
            'present': present_today,
            'absent': absent_today,
            'late': late_today,
            'unmarked': unmarked_today,
        },
        'attendance_rate_30d': avg_attendance,
        'tasks': {
            'pending': pending_tasks,
            'in_progress': in_progress_tasks,
            'completed': completed_tasks,
            'total': total_tasks,
            'completion_rate': completion_rate,
        },
        'wages': {
            'total_payable': float(total_payable),
            'total_paid_30d': float(total_paid),
        },
    })
