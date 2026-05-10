from django.db import models

class Breed(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)

    def __str__(self):
        return self.name

class Flock(models.Model):
    breed = models.ForeignKey(Breed, on_delete=models.CASCADE, related_name='flocks')
    name = models.CharField(max_length=100)
    current_count = models.IntegerField(default=0)
    age_weeks = models.IntegerField(default=0)
    house_number = models.CharField(max_length=50, blank=True)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return f"{self.name} ({self.breed.name})"
