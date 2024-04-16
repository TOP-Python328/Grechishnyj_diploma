from django.contrib import admin
from django.urls import path

from app.index import views as index
from app.users import views as users
from app.flats import views as flats
from app.sales import views as sales
from app.agents import views as agents

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
    path('contract/<str:id_sale>', sales.run_contract, name='run_contract'),
    
    path('mycompany', agents.run_my_company, name='run_my_company'),
    path('buisiness', agents.run_buisiness, name='run_buisiness')

    









]
