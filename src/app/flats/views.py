from django.shortcuts import render, redirect

from app.flats.models import Microdistrict, House, Flat, Room, FlatsPlan

from app.flats.forms import AddMicrodistrictForm, AddRoomForm, AddHouseForm, AddBuildingPermitsForm, AddFlatForm



def run_rooms(request):

    dbase=request.user.dbase
    rooms = Room.objects.using(dbase)
    
    if request.method == 'GET':
        add_room_form = AddRoomForm(dbase=dbase)

    elif request.method == 'POST':
        add_room_form = AddRoomForm(dbase=dbase, data=request.POST)
        if add_room_form.is_valid():
            add_room_form.save_to_database()
    
    return render(
        request,
        'flats/rooms.html',
        {
            'title': 'Комнаты',
            'rooms': rooms,
            'add_room_form': add_room_form,
            'scripts': [                 
                'scripts/popup.js', 
                'scripts/form.js',
            ]
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
            'scripts': [                 
                'scripts/popup.js', 
                'scripts/form.js',
            ]
        }
    )

def run_houses(request):
    dbase=request.user.dbase
    houses = House.objects.using(dbase)
    if request.method == 'GET':
        add_house_form = AddHouseForm(dbase=dbase)
        add_building_permits_form = AddBuildingPermitsForm()


    elif request.method == 'POST':
        add_house_form = AddHouseForm(data=request.POST, dbase=dbase)
        add_building_permits_form = AddBuildingPermitsForm(data=request.POST)
        if add_house_form.is_valid():
            add_house_form.save_to_database()
            return redirect('run_houses', permanent=True)
        if add_building_permits_form.is_valid():
            add_building_permits_form.save_to_database(request.user.dbase)
            return redirect('run_houses', permanent=True)
        

    return render(
        request,
        'flats/houses.html',
        {
            'title': 'Жилые дома',
            'houses': houses,
            'add_house_form': add_house_form,
            'add_building_permits_form': add_building_permits_form,
            'scripts': [                 
                'scripts/popup.js', 
                'scripts/form.js',
            ]
        }
    )

def run_flats(request):
    dbase=request.user.dbase
    flats = Flat.objects.using(dbase)
    
    if request.method == 'GET':
        add_flat_form = AddFlatForm(dbase=dbase)

    elif request.method == 'POST':
        add_flat_form = AddFlatForm(data=request.POST, dbase=dbase)
        
        if add_flat_form.is_valid():
            add_flat_form.save_to_database()
        

    return render(
        request,
        'flats/flats.html',
        {
            'title': 'Квартиры',
            'flats': flats,
            'add_flat_form': add_flat_form,
            'scripts': [                 
                'scripts/popup.js', 
                'scripts/form.js',
            ]
        }
    )

def run_rooms(request):
    dbase=request.user.dbase
    rooms = Room.objects.using(dbase)
    
    if request.method == 'GET':
        add_room_form = AddRoomForm(dbase=dbase)

    elif request.method == 'POST':
        add_room_form = AddRoomForm(data=request.POST, dbase=dbase)
        if add_room_form.is_valid():
            add_room_form.save_to_database()
    
    return render(
        request,
        'flats/rooms.html',
        {
            'title': 'Комнаты',
            'rooms': rooms,
            'add_room_form': add_room_form,
            'scripts': [                 
                'scripts/popup.js', 
                'scripts/form.js',
            ]
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
            'scripts': [ 
                'scripts/popup.js', 
                'scripts/form.js',
             ]
        }
    )


def run_flat_constructor(request):
    database = request.user.dbase
    rooms = Room.objects.using(database).order_by('name')
    flats_plans = FlatsPlan.objects.using(database)

    if request.method == 'GET':
        ...


    if request.method == 'POST':
        post_rooms = request.POST.getlist('room')
        post_square = request.POST.getlist('square')
        post_flat_name = request.POST['flat_name']
        
        for i in range(len(post_rooms)):
            FlatsPlan.objects.using(database).create(
                name = post_flat_name,
                square = post_square[i],
                room = Room.objects.using(database).get(pk=post_rooms[i])
            )
        return redirect('run_flat_constructor', permanent=True)
        
        

    return render(
        request,
        'flats/flats_plans.html',
        {
            'title': 'Квартирные планы',
            'rooms': rooms,
            'flats_plans': flats_plans,
            'scripts': [ 
                'scripts/popup.js', 
                'scripts/form.js',

            ]
        }
    )
