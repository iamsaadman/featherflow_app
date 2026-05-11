import os
import django
import sys

# Add the project root to sys.path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
django.setup()

from flock.models import Breed, Flock

def seed_data():
    # 1. Breeds
    broiler, _ = Breed.objects.get_or_create(name='Broiler', description='Meat production birds')
    layer, _ = Breed.objects.get_or_create(name='Layer', description='Egg production birds')
    sonali, _ = Breed.objects.get_or_create(name='Sonali', description='Dual purpose crossbreed')

    # 2. Flocks
    Flock.objects.get_or_create(breed=broiler, name='Batch B-101', defaults={'current_count': 2500, 'age_weeks': 4, 'house_number': 'Shed 1'})
    Flock.objects.get_or_create(breed=broiler, name='Batch B-102', defaults={'current_count': 3000, 'age_weeks': 2, 'house_number': 'Shed 2'})
    Flock.objects.get_or_create(breed=layer, name='Layer Group L-1', defaults={'current_count': 1500, 'age_weeks': 20, 'house_number': 'Shed 3'})
    Flock.objects.get_or_create(breed=sonali, name='Sonali S-50', defaults={'current_count': 500, 'age_weeks': 8, 'house_number': 'Shed 4'})

    print("Flock seeding completed successfully!")

if __name__ == '__main__':
    seed_data()
