import os
import django
from datetime import date, timedelta, time
from decimal import Decimal

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
django.setup()

from labor.models import Worker, Attendance, Task, Wage, WorkSchedule

# Clear old data
Worker.objects.all().delete()

# Create workers
workers_data = [
    {'name': 'Rahim Ahmed', 'role': 'Shed Manager', 'phone': '01711223344', 'daily_wage': 500, 'avatar': '👨‍🌾'},
    {'name': 'Karim Hassan', 'role': 'Feed Operator', 'phone': '01755667788', 'daily_wage': 400, 'avatar': '👷'},
    {'name': 'Sadia Begum', 'role': 'Egg Collector', 'phone': '01799887766', 'daily_wage': 350, 'avatar': '👩‍🌾'},
    {'name': 'Nihal', 'role': 'Cleaner', 'phone': '01733445566', 'daily_wage': 300, 'avatar': '🤡'},
    {'name': 'Jalal Uddin', 'role': 'Driver', 'phone': '01722334455', 'daily_wage': 380, 'avatar': '🚗'},
    {'name': 'Noor Islam', 'role': 'Health Monitor', 'phone': '01744556677', 'daily_wage': 450, 'avatar': '🧑‍⚕️'},
]

created_workers = []
for wd in workers_data:
    w = Worker.objects.create(**wd)
    created_workers.append(w)
    print(f"  ✅ Worker: {w.name}")

# Seed last 7 days of attendance
today = date.today()
statuses = ['Present', 'Present', 'Present', 'Absent', 'Present', 'Late']
for day_offset in range(7):
    d = today - timedelta(days=day_offset)
    for i, w in enumerate(created_workers):
        st = statuses[(i + day_offset) % len(statuses)]
        Attendance.objects.create(
            worker=w, date=d, status=st,
            check_in=time(6, 0) if st != 'Absent' else None,
            check_out=time(14, 0) if st != 'Absent' else None,
        )
print(f"  ✅ Attendance: 7 days × {len(created_workers)} workers")

# Seed tasks
tasks_data = [
    {'worker': created_workers[0], 'title': 'Clean Shed A', 'status': 'Completed', 'priority': 'High'},
    {'worker': created_workers[0], 'title': 'Inspect water lines', 'status': 'In Progress', 'priority': 'Medium'},
    {'worker': created_workers[1], 'title': 'Refill feed dispensers', 'status': 'Pending', 'priority': 'High'},
    {'worker': created_workers[2], 'title': 'Sort eggs by grade', 'status': 'Completed', 'priority': 'Medium'},
    {'worker': created_workers[2], 'title': 'Count morning collection', 'status': 'Pending', 'priority': 'Low'},
    {'worker': created_workers[3], 'title': 'Deep clean broiler shed', 'status': 'Pending', 'priority': 'High'},
    {'worker': created_workers[4], 'title': 'Deliver feed from warehouse', 'status': 'In Progress', 'priority': 'High'},
    {'worker': created_workers[5], 'title': 'Vaccinate Batch #12', 'status': 'Completed', 'priority': 'High'},
    {'worker': created_workers[5], 'title': 'Check sick birds in Shed C', 'status': 'Pending', 'priority': 'Medium'},
]
for td in tasks_data:
    Task.objects.create(**td, due_date=today + timedelta(days=2))
print(f"  ✅ Tasks: {len(tasks_data)} created")

# Seed wages for last 7 days
for day_offset in range(7):
    d = today - timedelta(days=day_offset)
    for w in created_workers:
        Wage.objects.create(
            worker=w, date=d,
            amount=w.daily_wage,
            bonus=Decimal('50') if day_offset == 0 else Decimal('0'),
            is_paid=(day_offset > 2),  # last 4 days paid, recent 3 pending
        )
print(f"  ✅ Wages: 7 days × {len(created_workers)} workers")

# Seed schedules for today
shifts = ['Morning', 'Morning', 'Afternoon', 'Morning', 'Morning', 'Afternoon']
for w, shift in zip(created_workers, shifts):
    WorkSchedule.objects.create(worker=w, date=today, shift=shift, description=f'{w.role} duties')
print(f"  ✅ Schedules: {len(created_workers)} for today")

print("\n🎉 Database seeded successfully!")
