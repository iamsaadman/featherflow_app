from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import BreedViewSet, FlockViewSet

router = DefaultRouter()
router.register(r'breeds', BreedViewSet)
router.register(r'flocks', FlockViewSet)

urlpatterns = [
    path('', include(router.urls)),
]
