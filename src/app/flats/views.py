from django.http import HttpResponse
from django.shortcuts import render

from app.flats.models import Room

from core.settings import BASE_DIR



def add_room(request):
    try:
        last_id = Room.objects.using(request.user.dbase).latest('id').id
        room = Room.objects.using(request.user.dbase).create(
            id = last_id + 1,
            name=request.POST['name'], 
            living=request.POST.get('living', False), 
            koef_price=float(request.POST['koef_price'])
        )
        room.save()
        return True
    except Exception as error:
        print(f"Unexpected {error=}, {type(error)=}")
        return False

def get_all_rooms(request):
    rooms = Room.objects.using(request.user.dbase)
    
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

