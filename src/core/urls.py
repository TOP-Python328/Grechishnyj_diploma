from django.contrib import admin
from django.urls import path

from builder import views as builder
from sales import views as sales
from flats import views as flats
from persons import views as persons
from bisiness import views as bisiness
from addresses import views as addresses


urlpatterns = [
    # path('admin/', admin.site.urls),



    path('', builder.main, name='main'),

    path('immovables/constructions', flats.get_all_constructions, name='immovables/constructions'),
    path('immovables/construction/<str:uniq>', flats.get_construction, name='immovables/construction'),
    
    path('immovables/houses', flats.get_all_houses, name='immovables/houses'),
    path('immovables/house/<str:uniq>', flats.get_house, name='immovables/house'),
    
    path('flats', flats.get_all_flats, name='flats'),
    path('flats/<str:uniq>', flats.get_flat, name='flat'),
    
    path('rooms', flats.get_all_rooms, name='rooms'),

    path('persons', persons.get_all_persons, name='persons'),
    path('persons/<str:uniq>', persons.get_person, name='person'),
    
    path('passports', persons.get_all_passports, name='passports'),

    path('bisiness', bisiness.get_all_bisiness, name='bisiness'),
    path('bisiness/<str:uniq>', bisiness.get_bisiness_card, name='bisiness_card'),


    path('addresses', addresses.main_address, name='addresses'),
    path('addresses/<str:uniq>', addresses.delete_address, name='address_delete'),
    
    path('sales/trade', sales.add_contract, name='sales/trade'),
]
