from django.db import models
from django.utils import timezone


class Worker(models.Model):
    """A labourer managed by the farmer."""
    name = models.CharField(max_length=100)
    role = models.CharField(max_length=100)
    phone = models.CharField(max_length=20, blank=True, default='')
    daily_wage = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    avatar = models.CharField(max_length=10, default='👤')
    is_active = models.BooleanField(default=True)
    hired_date = models.DateField(default=timezone.now)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['name']

    def __str__(self):
        return f"{self.name} — {self.role}"


class Attendance(models.Model):
    """Daily attendance record for a worker, marked by the farmer."""
    STATUS_CHOICES = [
        ('Present', 'Present'),
        ('Absent', 'Absent'),
        ('Late', 'Late'),
        ('Half-Day', 'Half-Day'),
    ]
    worker = models.ForeignKey(Worker, on_delete=models.CASCADE, related_name='attendances')
    date = models.DateField(default=timezone.now)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='Present')
    check_in = models.TimeField(null=True, blank=True)
    check_out = models.TimeField(null=True, blank=True)
    notes = models.TextField(blank=True, default='')

    class Meta:
        unique_together = ('worker', 'date')
        ordering = ['-date', 'worker__name']

    def __str__(self):
        return f"{self.worker.name} — {self.date} — {self.status}"


class WorkSchedule(models.Model):
    """Shift schedule assigned to a worker by the farmer."""
    SHIFT_CHOICES = [
        ('Morning', 'Morning (6 AM – 12 PM)'),
        ('Afternoon', 'Afternoon (12 PM – 6 PM)'),
        ('Evening', 'Evening (6 PM – 10 PM)'),
    ]
    STATUS_CHOICES = [
        ('Pending', 'Pending'),
        ('Active', 'Active'),
        ('Completed', 'Completed'),
        ('Cancelled', 'Cancelled'),
    ]
    worker = models.ForeignKey(Worker, on_delete=models.CASCADE, related_name='schedules')
    date = models.DateField(default=timezone.now)
    shift = models.CharField(max_length=20, choices=SHIFT_CHOICES, default='Morning')
    task_type = models.CharField(max_length=100, default='General Work')
    location = models.CharField(max_length=100, default='Farm Main Area')
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='Pending')
    description = models.TextField(blank=True, default='')

    class Meta:
        unique_together = ('worker', 'date', 'shift')
        ordering = ['-date', 'worker__name']

    def __str__(self):
        return f"{self.worker.name} — {self.date} — {self.shift}"


class Task(models.Model):
    """A task assigned to a worker by the farmer."""
    STATUS_CHOICES = [
        ('Pending', 'Pending'),
        ('In Progress', 'In Progress'),
        ('Completed', 'Completed'),
    ]
    PRIORITY_CHOICES = [
        ('Low', 'Low'),
        ('Medium', 'Medium'),
        ('High', 'High'),
    ]
    worker = models.ForeignKey(Worker, on_delete=models.CASCADE, related_name='tasks')
    title = models.CharField(max_length=200)
    description = models.TextField(blank=True, default='')
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='Pending')
    priority = models.CharField(max_length=10, choices=PRIORITY_CHOICES, default='Medium')
    assigned_date = models.DateField(default=timezone.now)
    due_date = models.DateField(null=True, blank=True)
    completed_date = models.DateField(null=True, blank=True)

    class Meta:
        ordering = ['-assigned_date', 'status']

    def __str__(self):
        return f"{self.title} → {self.worker.name} [{self.status}]"


class Wage(models.Model):
    """Wage/payment record for a worker, tracked by the farmer."""
    worker = models.ForeignKey(Worker, on_delete=models.CASCADE, related_name='wages')
    date = models.DateField(default=timezone.now)
    amount = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    bonus = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    deduction = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    total = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    is_paid = models.BooleanField(default=False)
    paid_date = models.DateField(null=True, blank=True)
    notes = models.TextField(blank=True, default='')

    class Meta:
        ordering = ['-date']

    def save(self, *args, **kwargs):
        self.total = self.amount + self.bonus - self.deduction
        super().save(*args, **kwargs)

    def __str__(self):
        status = "Paid" if self.is_paid else "Pending"
        return f"{self.worker.name} — ৳{self.total} [{status}]"


class DailyLog(models.Model):
    """Auto-generated summary of a worker's day."""
    worker = models.ForeignKey(Worker, on_delete=models.CASCADE, related_name='daily_logs')
    date = models.DateField(default=timezone.now)
    attendance_status = models.CharField(max_length=20, default='Absent')
    tasks_assigned = models.IntegerField(default=0)
    tasks_completed = models.IntegerField(default=0)
    hours_worked = models.DecimalField(max_digits=4, decimal_places=1, default=0)
    notes = models.TextField(blank=True, default='')

    class Meta:
        unique_together = ('worker', 'date')
        ordering = ['-date']

    def __str__(self):
        return f"{self.worker.name} — {self.date}"
