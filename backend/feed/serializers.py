from rest_framework import serializers
from .models import FeedType, FeedStock, FeedSchedule, FeedConsumptionLog, FeedNutritionPlan, FeedPurchaseOrder

class FeedTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = FeedType
        fields = '__all__'

class FeedStockSerializer(serializers.ModelSerializer):
    feed_type_name = serializers.ReadOnlyField(source='feed_type.name')
    class Meta:
        model = FeedStock
        fields = '__all__'

class FeedScheduleSerializer(serializers.ModelSerializer):
    feed_type_name = serializers.ReadOnlyField(source='feed_type.name')
    class Meta:
        model = FeedSchedule
        fields = '__all__'

class FeedConsumptionLogSerializer(serializers.ModelSerializer):
    feed_type_name = serializers.ReadOnlyField(source='feed_type.name')
    class Meta:
        model = FeedConsumptionLog
        fields = '__all__'

class FeedNutritionPlanSerializer(serializers.ModelSerializer):
    feed_type_name = serializers.ReadOnlyField(source='feed_type.name')
    class Meta:
        model = FeedNutritionPlan
        fields = '__all__'

class FeedPurchaseOrderSerializer(serializers.ModelSerializer):
    feed_type_name = serializers.ReadOnlyField(source='feed_type.name')
    class Meta:
        model = FeedPurchaseOrder
        fields = '__all__'
