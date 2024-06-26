from django.shortcuts import render, redirect

from app.assist.models import Address
from app.flats.models import Flat, Room, SaleStatus
from app.agents.models import BuisinessCard, Person, Passport, Bank, Client
from app.sales.models import Sale, SaleClient

def run_sales(request): 
    """Табличное предстваление сделок."""

    if request.method == 'GET':
        dbase = request.user.dbase
        sales_clients = SaleClient.objects.using(dbase).all()
        passports = Passport.objects.using(dbase).all()
        buisiness_cards = BuisinessCard.objects.using(dbase).all()

    return render(
        request,
        'sales/sales.html',
        {
            'title': 'Сделки',
            'h1': 'Сделки',
            'sales_clients': sales_clients,
            'passports': passports,
            'buisiness_cards': buisiness_cards,
            'scripts': []
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
        if request.POST['form'] == 'create_new_sale':
            # Если клиентов несколько - цикл
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
                patr_name=request.POST['person_patr_name'],
                sex=True if request.POST['person_sex'] == '1' else False,
                birthday=request.POST['person_birthday'])
            # Добавление записи в БД клиента
            # Если клиент физическое лицо
            # Добавление записи в БД о расчетном счете клиента
            bank=Bank.objects.using(dbase).create(
                bik=request.POST['bik_number'],
                branch=request.POST['bik_branch'],
                city=request.POST['bik_city'],
                address=request.POST['bik_address'],
                ks=request.POST['bik_ks'],
                rs=request.POST['bik_rs'],
                owner_type='individual')
            # Добавление записи в БД паспортных данных
            passport=Passport.objects.using(dbase).create(
                series=request.POST['passport_series'],
                number=request.POST['passport_number'],
                place_birth=request.POST['passport_place_birth'],
                dt_issue=request.POST['passport_dt_issue'],
                police_name=request.POST['passport_police_name'],
                police_code=request.POST['passport_police_code'],
                person=person,
                bank=bank,
                address=address)
            # Добавление записи в БД о новом клиенте
            client=Client.objects.using(dbase).create(
                passport=passport)
            # Если клиент юридическое лицо
            # Добавление записи в БД бизнес-карты клиента
            # ...
            # Добавление записи в БД о новой продаже
            sale=Sale.objects.using(dbase).create(
                number=request.POST['sale_number'],
                city=request.POST['sale_city'],
                dt_issue=request.POST['sale_date'],
                decoration=True if request.POST['sale_interior_decoration'] == '1' else False,
                price=request.POST['sale_price'],
                flat=Flat.objects.using(dbase).get(id=request.POST['sale_flat']),
                escrow_agent=BuisinessCard.objects.using(dbase).get(id=request.POST['escrow_agent']))
            # Добавление записи в БД об участниках в сделке
            sales_clients=SaleClient.objects.using(dbase).create(
                sale=sale,
                client=client,
                part=request.POST['sale_part'],
                pay_days=request.POST['sale_pay_days'],
                own_money=request.POST['sale_own_money'], 
                credit_money=request.POST['sale_credit_money'])
            # Изменения статуса продажи квартиры
            flat.status = SaleStatus.objects.using(dbase).get(name='sold')
            flat.save(using=dbase)
        return redirect('run_sales', permanent=True)

    return render(
        request,
        'sales/sale.html',
        {
            'title': 'Новый договор',
            'h1': 'Новый договор',
            'flat': flat,
            'rooms': rooms,
            'my_company': my_company,
            'escrow_agents': escrow_agents,
            'scripts': [ 
                'scripts/popup.js', 
                'scripts/form.js', 
                'scripts/client.js',
                'scripts/address.js',
                'scripts/bik.js']
        }
    )

def run_contract(request, uid_flat): 
    """Договор долевого участия."""
    
    if request.method == 'GET':
        dbase = request.user.dbase
        username = request.user.username
        my_company = BuisinessCard.objects.using(dbase).get(business=username)
        flat = Flat.objects.using(dbase).get(id=int(uid_flat))
        sale = Sale.objects.using(dbase).get(flat=flat)
        sales_clients = SaleClient.objects.using(dbase).filter(id=sale.id) 

    return render(
        request,
        'sales/contract.html',
        {
            'title': f'ДДУ № {sale.number}',
            'h1': f'ДДУ № {sale.number}',
            'my_company': my_company,
            'sale': sale,
            'flat': flat,
            'sales_clients': sales_clients, 
            'scripts': []
        }
    )