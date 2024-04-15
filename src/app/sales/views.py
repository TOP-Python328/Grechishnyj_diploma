from django.shortcuts import render

from app.assist.models import Address
from app.flats.models import Flat, Room
from app.cards.models import BuisinessCard, Person, Passport, Bank, Client

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
    flat = Flat.objects.using(dbase).get(id=int(uid_flat))
    rooms = flat.room_set.all()

    if request.method == 'POST':
        print(request.POST)


        if request.POST['form'] == 'create_new_sale':
            # Добавление записи в БД об адресе клиента
            client=Client.objects.using(dbase).create(
                uid=f"{request.POST['passport_series']}{request.POST['passport_number']}"
            )

            address=Address.objects.using(dbase).create( 
                country_name='Россия',
                country_full_name='Российская Федерация',
                region=request.POST['region'],
                district=request.POST['district'],
                locality=request.POST['locality'],
                city=request.POST['city'],
                street=request.POST['street'],
                home=request.POST['home'],
                flat=request.POST['flat'])
            # Добавление записи в БД о клиенте
            person=Person.objects.using(dbase).create(
                last_name=request.POST['person_last_name'],
                first_name=request.POST['person_first_name'],
                patr_name=request.POST['person_last_name'],
                sex=request.POST['person_sex'],
                birthday=request.POST['person_birthday'])
            # Добавление записи в БД паспортных клиента
            client=Client.objects.using(dbase).create(
                uid=f"{request.POST['passport_series']}{request.POST['passport_number']}"
            )
            passport=Passport.objects.using(dbase).create(
                client=client,
                series=request.POST['passport_series'],
                number=request.POST['passport_number'],
                place_birth=request.POST['passport_place_birth'],
                dt_issue=request.POST['passport_dt_issue'],
                police_name=request.POST['passport_police_name'],
                police_code=request.POST['passport_police_code'],
                person=person,
                address=address)
            # Добавление записи в БД о расчетным счете клиента
            bank=Bank.objects.using(dbase).create(
                bik=request.POST['bik_number'],
                branch=request.POST['bik_branch'],
                city=request.POST['bik_city'],
                address=request.POST['bik_address'],
                ks=request.POST['bik_ks'],
                rs=request.POST['bik_rs'],
                owner_uid=f'{passport.series}{passport.number}',
                owner_type='individual')
            # Добавление записи в БД о новом клиенте
            # Client


        

        
        
    # 'form': ['create_new_sale'], 
 

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
                'scripts/client.js',
                'scripts/address.js',
                'scripts/bik.js',
            ]
        }
    )
