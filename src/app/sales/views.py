from django.shortcuts import render

from app.flats.models import Flat, Room
from app.firms.models import BuisinessCard

def run_sales(request): 
    """Табличное предстваление сделок."""
    # if request.method == 'GET':
    #     flats = Flat.objects.using(request.user.dbase)
    return render(
        request,
        'sales/sales.html',
        {
            'title': 'Сделки',
            # 'flats': flats,
            'scripts': [ 
                'scripts/popup.js', 
                'scripts/form.js', 
            ]
        }
    )

def run_sale(request, uid_flat): 
    """Продажа квартиры."""
    dbase = request.user.dbase
    username = request.user.username
    my_company = BuisinessCard.objects.using(dbase).get(business=username)
    escrow_agents = BuisinessCard.objects.using(dbase).filter(business='escrow')

    if request.method == 'GET':
        flat = Flat.objects.using(dbase).get(id=int(uid_flat))
        rooms = flat.room_set.all()
        
    
    return render(
        request,
        'sales/sale.html',
        {
            'title': 'Новый договор',
            'flat': flat,
            'rooms': rooms,
            'my_company': my_company,
            'escrow_agents': escrow_agents,
            'scripts': [ 
                'scripts/popup.js', 
                'scripts/form.js', 
            ]
        }
    )
