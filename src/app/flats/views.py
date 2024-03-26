from django.http import HttpResponse
from django.shortcuts import render

from app.flats.models import Microdistricts, Houses, Rooms

from app.flats.forms import AddMicrodistrictForm, AddRoomForm

def add_microdistricts(request):
    ...

# def add_room(request):
#     try:
#         Rooms.objects.using(request.user.dbase).create(
#             name=request.POST['name'], 
#             living=True if request.POST.get('living') == 'on' else False, 
#             koef_price=float(request.POST['koef_price'])
#         ).save()
#     except Exception as error:
#         print(f"Unexpected {error=}, {type(error)=}")
#     return

def add_room(request):
    # AddRoomForm.save_to_database(request.user.dbase)
    try:
        Rooms.objects.using(request.user.dbase).create(
            name=request.POST['name'], 
            living=True if request.POST.get('living') == 'on' else False, 
            koef_price=float(request.POST['koef_price'])
        ).save()
    except Exception as error:
        print(f"Unexpected {error=}, {type(error)=}")
    return

def get_all_rooms(request):
    rooms = Rooms.objects.using(request.user.dbase)
    
    if request.method == 'POST':
        print(add_room(request))
    
    return render(
        request,
        'flats/rooms.html',
        {
            'title': 'Комнаты',
            'rooms': rooms,
            'scripts': [
                'scripts/popup.js',
            ]
        }
    )

def get_all_microdistricts(request):
    microdistricts = Microdistricts.objects.using(request.user.dbase)
    
    if request.method == 'GET':
        form_add_microdistrict = AddMicrodistrictForm()

    elif request.method == 'POST':
        form_add_microdistrict = AddMicrodistrictForm(data=request.POST)
        if form_add_microdistrict.is_valid():
            form_add_microdistrict.save_to_database(request.user.dbase)

    return render(
        request,
        'flats/microdistricts.html',
        {
            'title': 'Микрорайоны',
            'microdistricts': microdistricts,
            'form_add_microdistrict': form_add_microdistrict,
            'scripts': [ 'scripts/popup.js', ]
        }
    )

def get_all_houses_by_district(request, microdistrict_name: str):
    microdistrict = Microdistricts.objects.using(request.user.dbase).get(name=microdistrict_name)
    houses = Houses.objects.using(request.user.dbase).filter(microdistrict=microdistrict.id)

    return render(
        request,
        'flats/microdistrict.html',
        {
            'microdistrict': microdistrict,
            'houses': houses,
            'scripts': [ 'scripts/popup.js' ]
        }
    )
