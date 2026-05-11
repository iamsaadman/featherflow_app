from django.db import models

class FeedType(models.Model):
    name = models.CharField(max_length=100)
    brand = models.CharField(max_length=100, blank=True)
    description = models.TextField(blank=True)
    unit = models.CharField(max_length=20, default='kg')
    color = models.CharField(max_length=20, default='#4CAF82')
    icon_name = models.CharField(max_length=50, default='grass_rounded')

    def __str__(self):
        return self.name

class FeedStock(models.Model):
    feed_type = models.OneToOneField(FeedType, on_delete=models.CASCADE, related_name='stock_info')
    current_stock = models.DecimalField(max_digits=10, decimal_places=2)
    reorder_level = models.DecimalField(max_digits=10, decimal_places=2)
    last_updated = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.feed_type.name} - {self.current_stock}"

class FeedSchedule(models.Model):
    feed_type = models.ForeignKey(FeedType, on_delete=models.CASCADE)
    time = models.TimeField()
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    flock_name = models.CharField(max_length=100)
    is_done = models.BooleanField(default=False)
    date = models.DateField(auto_now_add=True)

    def __str__(self):
        return f"{self.time} - {self.feed_type.name} for {self.flock_name}"

class FeedConsumptionLog(models.Model):
    feed_type = models.ForeignKey(FeedType, on_delete=models.CASCADE)
    date = models.DateField()
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    flock_name = models.CharField(max_length=100)
    notes = models.TextField(blank=True)

    def __str__(self):
        return f"{self.date} - {self.feed_type.name} - {self.amount}"

class FeedNutritionPlan(models.Model):
    name = models.CharField(max_length=100)
    feed_type = models.ForeignKey(FeedType, on_delete=models.CASCADE)
    protein_percent = models.DecimalField(max_digits=5, decimal_places=2)
    energy_kcal = models.DecimalField(max_digits=10, decimal_places=2)
    calcium_percent = models.DecimalField(max_digits=5, decimal_places=2)
    phosphorus_percent = models.DecimalField(max_digits=5, decimal_places=2)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return self.name

class FeedPurchaseOrder(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('delivered', 'Delivered'),
        ('cancelled', 'Cancelled'),
    ]
    feed_type = models.ForeignKey(FeedType, on_delete=models.CASCADE)
    supplier_name = models.CharField(max_length=100)
    quantity = models.DecimalField(max_digits=10, decimal_places=2)
    unit_price = models.DecimalField(max_digits=10, decimal_places=2)
    total_price = models.DecimalField(max_digits=12, decimal_places=2)
    order_date = models.DateField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')

    def __str__(self):
        return f"PO-{self.id} - {self.supplier_name}"
