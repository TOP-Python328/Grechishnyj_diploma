from django.contrib import admin
from django.urls import path

from app.index import views as index
from app.users import views as users
from app.flats import views as flats

urlpatterns = [
    # path('admin/', admin.site.urls),

    path('', index.main, name='main'),
    path('register', users.register, name='user_register'),
    path('login', users.login, name='user_login'),
    path('logout', users.logout, name='user_logout'),


    path('flats', flats.run_flats, name='run_flats'),
    path('houses', flats.run_houses, name='run_houses'),
    path('flatplans', flats.run_flat_constructor, name='run_flat_constructor'),
    # path('houses', flats.add_building_permits, name='add_building_permits'),
    path('microdistricts', flats.run_microdistricts, name='run_microdistricts'),
    # path('microdistrict/<str:microdistrict_name>', flats.get_all_houses_by_district, name='app_flats_houses'),









]
