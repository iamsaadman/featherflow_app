from rest_framework import serializers
from .models import Breed, Flock

class BreedSerializer(serializers.ModelSerializer):
    flock_count = serializers.SerializerMethodField()
    total_birds = serializers.SerializerMethodField()

    class Meta:
        model = Breed
        fields = ['id', 'name', 'description', 'flock_count', 'total_birds']

    def get_flock_count(self, obj):
        return obj.flocks.count()

    def get_total_birds(self, obj):
        return sum(f.current_count for f in obj.flocks.all())

class FlockSerializer(serializers.ModelSerializer):
    breed_name = serializers.ReadOnlyField(source='breed.name')
    class Meta:
        model = Flock
        fields = '__all__'
