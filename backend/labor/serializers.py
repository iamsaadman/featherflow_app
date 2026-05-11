from rest_framework import serializers
from django.db.models import Sum
from .models import Worker, Attendance, WorkSchedule, Task, Wage, DailyLog


class WorkerSerializer(serializers.ModelSerializer):
    attendance_rate = serializers.SerializerMethodField()
    pending_wages = serializers.SerializerMethodField()

    class Meta:
        model = Worker
        fields = '__all__'

    def get_attendance_rate(self, obj):
        total = obj.attendances.count()
        if total == 0:
            return 0
        present = obj.attendances.filter(status__in=['Present', 'Late', 'Half-Day']).count()
        return round((present / total) * 100, 1)

    def get_pending_wages(self, obj):
        return float(obj.wages.filter(is_paid=False).aggregate(
            total=Sum('total')
        )['total'] or 0)


class AttendanceSerializer(serializers.ModelSerializer):
    worker_name = serializers.CharField(source='worker.name', read_only=True)
    worker_avatar = serializers.CharField(source='worker.avatar', read_only=True)
    worker_role = serializers.CharField(source='worker.role', read_only=True)

    class Meta:
        model = Attendance
        fields = '__all__'


class BulkAttendanceSerializer(serializers.Serializer):
    """For marking attendance for multiple workers at once."""
    date = serializers.DateField()
    records = serializers.ListField(child=serializers.DictField())


class WorkScheduleSerializer(serializers.ModelSerializer):
    worker_name = serializers.CharField(source='worker.name', read_only=True)
    worker_avatar = serializers.CharField(source='worker.avatar', read_only=True)

    class Meta:
        model = WorkSchedule
        fields = '__all__'


class TaskSerializer(serializers.ModelSerializer):
    worker_name = serializers.CharField(source='worker.name', read_only=True)
    worker_avatar = serializers.CharField(source='worker.avatar', read_only=True)

    class Meta:
        model = Task
        fields = '__all__'


class WageSerializer(serializers.ModelSerializer):
    worker_name = serializers.CharField(source='worker.name', read_only=True)
    worker_avatar = serializers.CharField(source='worker.avatar', read_only=True)

    class Meta:
        model = Wage
        fields = '__all__'


class DailyLogSerializer(serializers.ModelSerializer):
    worker_name = serializers.CharField(source='worker.name', read_only=True)

    class Meta:
        model = DailyLog
        fields = '__all__'
