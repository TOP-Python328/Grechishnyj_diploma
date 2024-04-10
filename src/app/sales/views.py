from django.shortcuts import render

from app.flats.models import Flat

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
    if request.method == 'GET':
        flat = Flat.objects.using(request.user.dbase).get(id=int(uid_flat))
    
    return render(
        request,
        'sales/sale.html',
        {
            'title': 'Новый договор',
            'flat': flat,
            'scripts': [ 
                'scripts/popup.js', 
                'scripts/form.js', 
            ]
        }
    )
