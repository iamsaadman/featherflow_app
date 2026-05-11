from rest_framework import viewsets
from .models import Breed, Flock
from .serializers import BreedSerializer, FlockSerializer

class BreedViewSet(viewsets.ModelViewSet):
    queryset = Breed.objects.all()
    serializer_class = BreedSerializer

class FlockViewSet(viewsets.ModelViewSet):
    queryset = Flock.objects.all()
    serializer_class = FlockSerializer
