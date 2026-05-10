import os
import django
import sys
from datetime import time, date

# Add the project root to sys.path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
django.setup()

from feed.models import FeedType, FeedStock, FeedSchedule, FeedConsumptionLog, FeedNutritionPlan, FeedPurchaseOrder

def seed_data():
    # 1. Feed Types
    starter, _ = FeedType.objects.get_or_create(
        name='Broiler Starter',
        brand='ACI Feeds',
        unit='kg',
        color='#4CAF82',
        icon_name='grass_rounded'
    )
    grower, _ = FeedType.objects.get_or_create(
        name='Broiler Grower',
        brand='CP Feeds',
        unit='kg',
        color='#29B6F6',
        icon_name='eco_rounded'
    )
    layer, _ = FeedType.objects.get_or_create(
        name='Layer Pellet',
        brand='Nourish Feeds',
        unit='kg',
        color='#F4C552',
        icon_name='grain_rounded'
    )

    # 2. Feed Stock
    FeedStock.objects.get_or_create(feed_type=starter, defaults={'current_stock': 450, 'reorder_level': 100})
    FeedStock.objects.get_or_create(feed_type=grower, defaults={'current_stock': 280, 'reorder_level': 150})
    FeedStock.objects.get_or_create(feed_type=layer, defaults={'current_stock': 80, 'reorder_level': 200})

    # 3. Feed Schedules
    FeedSchedule.objects.get_or_create(
        feed_type=starter,
        time=time(6, 0),
        amount=50,
        flock_name='Shed A (2000 birds)',
        is_done=True
    )
    FeedSchedule.objects.get_or_create(
        feed_type=grower,
        time=time(12, 0),
        amount=60,
        flock_name='Shed B (3000 birds)',
        is_done=False
    )

    # 4. Nutrition Plans
    FeedNutritionPlan.objects.get_or_create(
        name='Broiler Phase 1',
        feed_type=starter,
        protein_percent=21.5,
        energy_kcal=3100,
        calcium_percent=0.9,
        phosphorus_percent=0.45
    )

    # 5. Consumption Logs
    FeedConsumptionLog.objects.get_or_create(
        feed_type=starter,
        date=date.today(),
        amount=45.5,
        flock_name='Shed A',
        notes='Morning feed'
    )
    FeedConsumptionLog.objects.get_or_create(
        feed_type=grower,
        date=date.today(),
        amount=50.0,
        flock_name='Shed B',
        notes='Afternoon feed'
    )

    # 6. Purchase Orders
    FeedPurchaseOrder.objects.get_or_create(
        feed_type=layer,
        supplier_name='Nourish Feed Mills',
        quantity=500,
        unit_price=45,
        total_price=22500,
        order_date=date.today(),
        status='pending'
    )
    FeedPurchaseOrder.objects.get_or_create(
        feed_type=starter,
        supplier_name='ACI Godrej',
        quantity=1000,
        unit_price=52,
        total_price=52000,
        order_date=date.today(),
        status='delivered'
    )

    print("Seeding completed successfully!")

if __name__ == '__main__':
    seed_data()
