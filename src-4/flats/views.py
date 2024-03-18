from django.http import HttpResponse
from django.shortcuts import render

from flats.models import Room, Flat, Plan, Construction, House, Section, Floor

def get_all_flats(request):
    return render(
        request,
        'immovables/flats.html',
        {
            'title': 'Квартиры',
            'flats': Flat.objects.order_by('id'),
        }
    )

def get_flat(request, uniq: str):
    flat = Flat.objects.get(id=int(uniq))
    plans = Plan.objects.filter(flat_id=flat.id)
    square = 0
    for plan in plans:
        square += plan.square

    return render(
        request, 
        'immovables/flat.html',
        {
            'title': f'Квартира {flat.number}',
            'flat': flat,
            'plans': plans,
            'square': square
        }
    )


def get_all_constructions(request):
    constructions = Construction.objects.order_by('id')
 
    return render(
        request,
        'immovables/constructions.html',
        {
            'title': 'Микрорайоны',
            'constructions': constructions,
        }
    )

def get_construction(request, uniq: str):
    construction = Construction.objects.get(id=int(uniq))
    houses = House.objects.filter(construction_id=construction.id)
    return render(
        request,
        'immovables/construction.html',
        {
            'title': f'Микрорайон {construction.name}',
            'construction': construction,
            'houses': houses
        }
    )

def get_all_houses(request):
    houses = House.objects.order_by('id')
    return render(
        request,
        'immovables/houses.html',
        {
            'title': 'Дома',
            'houses': houses,
        }
    )

def get_house(request, uniq: str):
    flats = {}
    house = House.objects.get(id=int(uniq))
    sections = house.section_set.all()
        
    for section in sections:
        floors = Floor.objects.filter(section_id=section.id)
        for floor in floors:           
            flats[section] = {floor: list(Flat.objects.filter(floor_id=floor.id))}

    return render(
        request,
        'immovables/house.html',
        {
            'title': f'Многоквартирный жилой дом {house.number}',
            'house': house,
            'sections': sections,
            'floors': floors,
            'flats': flats
        }
    )

def add_room(request):
    try:
        Room(
            name=request.POST['name'],
            living=bool(request.POST['living']),
            koef_price=float(request.POST['koef_price'])
        ).save()
        return True
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return False


def get_all_rooms(request):
    rooms = Room.objects.order_by('id')
    
    if request.method == 'POST':
        print(add_room(request))
    
    return render(
        request,
        'immovables/rooms.html',
        {
            'title': 'Комнаты',
            'rooms': rooms,
            'scripts': [
                'scripts/popup.js',
            ]
            # 'errors': errors
        }
    )

