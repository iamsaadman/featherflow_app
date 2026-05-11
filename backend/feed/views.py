from rest_framework import viewsets
from .models import FeedType, FeedStock, FeedSchedule, FeedConsumptionLog, FeedNutritionPlan, FeedPurchaseOrder
from .serializers import (
    FeedTypeSerializer, FeedStockSerializer, FeedScheduleSerializer,
    FeedConsumptionLogSerializer, FeedNutritionPlanSerializer, FeedPurchaseOrderSerializer
)

class FeedTypeViewSet(viewsets.ModelViewSet):
    queryset = FeedType.objects.all()
    serializer_class = FeedTypeSerializer

class FeedStockViewSet(viewsets.ModelViewSet):
    queryset = FeedStock.objects.all()
    serializer_class = FeedStockSerializer

class FeedScheduleViewSet(viewsets.ModelViewSet):
    queryset = FeedSchedule.objects.all()
    serializer_class = FeedScheduleSerializer

class FeedConsumptionLogViewSet(viewsets.ModelViewSet):
    queryset = FeedConsumptionLog.objects.all()
    serializer_class = FeedConsumptionLogSerializer

class FeedNutritionPlanViewSet(viewsets.ModelViewSet):
    queryset = FeedNutritionPlan.objects.all()
    serializer_class = FeedNutritionPlanSerializer

class FeedPurchaseOrderViewSet(viewsets.ModelViewSet):
    queryset = FeedPurchaseOrder.objects.all()
    serializer_class = FeedPurchaseOrderSerializer
