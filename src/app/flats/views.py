from django.shortcuts import render, redirect

from app.flats.models import Microdistrict, House, Room

from app.flats.forms import AddMicrodistrictForm, AddRoomForm, AddHouseForm, AddBuildingPermitsForm



def run_rooms(request):
    rooms = Room.objects.using(request.user.dbase)
    
    if request.method == 'GET':
        add_room_form = AddRoomForm()

    elif request.method == 'POST':
        add_room_form = AddRoomForm(data=request.POST)
        if add_room_form.is_valid():
            add_room_form.save_to_database(request.user.dbase)
    
    return render(
        request,
        'flats/rooms.html',
        {
            'title': 'Комнаты',
            'rooms': rooms,
            'add_room_form': add_room_form,
            'scripts': [ 'scripts/popup.js', ]
        }
    )

def run_microdistricts(request):
    microdistricts = Microdistrict.objects.using(request.user.dbase)
    
    if request.method == 'GET':
        add_microdistrict_form = AddMicrodistrictForm()

    elif request.method == 'POST':
        add_microdistrict_form = AddMicrodistrictForm(data=request.POST)
        
        if add_microdistrict_form.is_valid():
            add_microdistrict_form.save_to_database(request.user.dbase)
        

    return render(
        request,
        'flats/microdistricts.html',
        {
            'title': 'Микрорайоны',
            'microdistricts': microdistricts,
            'add_microdistrict_form': add_microdistrict_form,
            'scripts': [ 'scripts/popup.js', ]
        }
    )

def run_houses(request):
    dbase=request.user.dbase
    houses = House.objects.using(dbase)
    if request.method == 'GET':
        add_house_form = AddHouseForm(dbase=request.user.dbase)
        add_building_permits_form = AddBuildingPermitsForm()


    elif request.method == 'POST':
        add_house_form = AddHouseForm(data=request.POST, dbase=dbase)
        add_building_permits_form = AddBuildingPermitsForm(data=request.POST)
        if add_house_form.is_valid():
            add_house_form.save_to_database()
        if add_building_permits_form.is_valid():
            add_building_permits_form.save_to_database(request.user.dbase)
            return redirect('run_houses', permanent=True)
        

    return render(
        request,
        'flats/houses.html',
        {
            'title': 'Жилые дома',
            'microdistricts': houses,
            'add_house_form': add_house_form,
            'add_building_permits_form': add_building_permits_form,
            'scripts': [ 'scripts/popup.js', ]
        }
    )



def get_all_houses_by_district(request, microdistrict_name: str):
    microdistrict = Microdistrict.objects.using(request.user.dbase).get(name=microdistrict_name)
    houses = House.objects.using(request.user.dbase).filter(microdistrict=microdistrict.id)



    return render(
        request,
        'flats/microdistrict.html',
        {
            'microdistrict': microdistrict,
            'houses': houses,
            'scripts': [ 'scripts/popup.js' ]
        }
    )
