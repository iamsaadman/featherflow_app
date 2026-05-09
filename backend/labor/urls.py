from django.urls import path
from .views import (
    WorkerListCreateView, WorkerDetailView,
    AttendanceListCreateView, today_attendance, bulk_mark_attendance,
    ScheduleListCreateView, ScheduleDetailView,
    TaskListCreateView, TaskDetailView,
    WageListCreateView, WageDetailView, mark_wage_paid,
    dashboard,
)

urlpatterns = [
    # Workers
    path('workers/', WorkerListCreateView.as_view(), name='worker-list'),
    path('workers/<int:pk>/', WorkerDetailView.as_view(), name='worker-detail'),

    # Attendance
    path('attendance/', AttendanceListCreateView.as_view(), name='attendance-list'),
    path('attendance/today/', today_attendance, name='attendance-today'),
    path('attendance/mark/', bulk_mark_attendance, name='attendance-mark'),

    # Schedules
    path('schedules/', ScheduleListCreateView.as_view(), name='schedule-list'),
    path('schedules/<int:pk>/', ScheduleDetailView.as_view(), name='schedule-detail'),

    # Tasks
    path('tasks/', TaskListCreateView.as_view(), name='task-list'),
    path('tasks/<int:pk>/', TaskDetailView.as_view(), name='task-detail'),

    # Wages
    path('wages/', WageListCreateView.as_view(), name='wage-list'),
    path('wages/<int:pk>/', WageDetailView.as_view(), name='wage-detail'),
    path('wages/<int:pk>/pay/', mark_wage_paid, name='wage-pay'),

    # Dashboard
    path('dashboard/', dashboard, name='dashboard'),
]
