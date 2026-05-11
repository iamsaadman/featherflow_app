from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/labor/', include('labor.urls')),
<<<<<<< HEAD
    path('api/feed/', include('feed.urls')),
    path('api/flock/', include('flock.urls')),
=======
>>>>>>> 625411fbcf886ad374d6b8004230b94ab7b36bf3
]
