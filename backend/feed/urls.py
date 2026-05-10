from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    FeedTypeViewSet, FeedStockViewSet, FeedScheduleViewSet,
    FeedConsumptionLogViewSet, FeedNutritionPlanViewSet, FeedPurchaseOrderViewSet
)

router = DefaultRouter()
router.register(r'types', FeedTypeViewSet)
router.register(r'stock', FeedStockViewSet)
router.register(r'schedules', FeedScheduleViewSet)
router.register(r'consumption', FeedConsumptionLogViewSet)
router.register(r'nutrition', FeedNutritionPlanViewSet)
router.register(r'purchases', FeedPurchaseOrderViewSet)

urlpatterns = [
    path('', include(router.urls)),
]
