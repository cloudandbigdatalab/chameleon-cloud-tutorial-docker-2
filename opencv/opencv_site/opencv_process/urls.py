from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^process$', views.process, name='process'),
    url(r'^result$', views.result, name='result'),
]
