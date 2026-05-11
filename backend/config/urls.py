from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/labor/', include('labor.urls')),
    path('api/feed/', include('feed.urls')),
    path('api/flock/', include('flock.urls')),
]
