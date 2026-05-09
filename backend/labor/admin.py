from django.contrib import admin
from .models import Worker, Attendance, WorkSchedule, Task, Wage, DailyLog


@admin.register(Worker)
class WorkerAdmin(admin.ModelAdmin):
    list_display = ['name', 'role', 'phone', 'daily_wage', 'is_active', 'hired_date']
    list_filter = ['is_active', 'role']
    search_fields = ['name', 'role', 'phone']


@admin.register(Attendance)
class AttendanceAdmin(admin.ModelAdmin):
    list_display = ['worker', 'date', 'status', 'check_in', 'check_out']
    list_filter = ['status', 'date']
    search_fields = ['worker__name']


@admin.register(WorkSchedule)
class WorkScheduleAdmin(admin.ModelAdmin):
    list_display = ['worker', 'date', 'shift', 'description']
    list_filter = ['shift', 'date']


@admin.register(Task)
class TaskAdmin(admin.ModelAdmin):
    list_display = ['title', 'worker', 'status', 'priority', 'assigned_date', 'due_date']
    list_filter = ['status', 'priority']
    search_fields = ['title', 'worker__name']


@admin.register(Wage)
class WageAdmin(admin.ModelAdmin):
    list_display = ['worker', 'date', 'amount', 'bonus', 'deduction', 'total', 'is_paid']
    list_filter = ['is_paid', 'date']
    search_fields = ['worker__name']


@admin.register(DailyLog)
class DailyLogAdmin(admin.ModelAdmin):
    list_display = ['worker', 'date', 'attendance_status', 'tasks_assigned', 'tasks_completed', 'hours_worked']
    list_filter = ['date']
