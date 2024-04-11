from django.shortcuts import render

from app.flats.models import Flat
from app.firms.models import BusinessCard

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

    if request.method == 'GET':
        flat = Flat.objects.using(dbase).get(id=int(uid_flat))
        my_company = BusinessCard.objects.using(dbase).get(username=username)
    
    return render(
        request,
        'sales/sale.html',
        {
            'title': 'Новый договор',
            'flat': flat,
            'my_company': my_company,
            'scripts': [ 
                'scripts/popup.js', 
                'scripts/form.js', 
            ]
        }
    )
