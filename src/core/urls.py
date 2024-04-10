from django.contrib import admin
from django.urls import path

from app.index import views as index
from app.users import views as users
from app.flats import views as flats
from app.sales import views as sales

urlpatterns = [
    # path('admin/', admin.site.urls),

    path('', index.main, name='main'),
    path('register', users.register, name='user_register'),
    path('login', users.login, name='user_login'),
    path('logout', users.logout, name='user_logout'),


    path('flats', flats.run_flats, name='run_flats'),
    path('houses', flats.run_houses, name='run_houses'),
    path('house/<str:uid>', flats.run_house, name='run_house'),
    path('flatplans', flats.run_flat_constructor, name='run_flat_constructor'),
    path('microdistricts', flats.run_microdistricts, name='run_microdistricts'),

    path('sales', sales.run_sales, name='run_sales'),
    path('sale/<str:uid_flat>', sales.run_sale, name='run_sale'),
    # path('microdistrict/<str:microdistrict_name>', flats.get_all_houses_by_district, name='app_flats_houses'),









]
