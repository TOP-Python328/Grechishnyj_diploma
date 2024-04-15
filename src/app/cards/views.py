from django.shortcuts import render, redirect

from app.assist.models import Address

from app.cards.models import Person, OrgForm, BuisinessCard, Bank


def run_buisiness(request):
    username = request.user.username
    dbase = request.user.dbase
    orgforms = OrgForm.objects.using(dbase)
    
    if request.method == 'GET':
        ...
    
    if request.method == 'POST':
        if request.POST['form'] == 'create_new_firm':
            # Данные компании
            post_business = str(request.POST['business'])
            post_orgform = str(request.POST['orgform'])
            post_full_name = str(request.POST['full_name'])
            post_short_name = str(request.POST['short_name'])
            post_inn = str(request.POST['inn'])
            post_kpp = str(request.POST['kpp'])
            post_ogrn = int(request.POST['orgform'])
            post_site = str(request.POST['site'])
            post_email = str(request.POST['email'])
            # Данные об адресе
            post_region = str(request.POST['region'])
            post_district = str(request.POST['district'])
            post_locality = str(request.POST['locality'])
            post_city = str(request.POST['city'])
            post_street = str(request.POST['street'])
            post_home = str(request.POST['home'])
            post_flat = str(request.POST['flat'])
            # Данные о руководителе
            post_last_name = str(request.POST['last_name'])
            post_first_name = str(request.POST['first_name'])
            post_patr_name = str(request.POST['patr_name'])
            post_sex = True if request.POST.get('sex') == '1' else False
            post_birthday = request.POST['birthday']
            post_director_power_type = request.POST['director_power_type']
            post_director_power_number = request.POST['director_power_number']
            post_director_power_date = request.POST['director_power_date'] or None
            # Данные о расчетном счете
            post_bik_number = str(request.POST['bik_number'])
            post_bik_branch = str(request.POST['bik_branch'])
            post_bik_city = str(request.POST['bik_city'])
            post_bik_address = str(request.POST['bik_address'])
            post_bik_ks = str(request.POST['bik_ks'])
            post_bik_rs = str(request.POST['bik_rs'])

            # Запись в БД данных о руководителе компании
            director=Person.objects.using(dbase).create(
                last_name=post_last_name,
                first_name=post_first_name,
                patr_name=post_patr_name,
                sex=post_sex,
                birthday=post_birthday)
    
            # Запись в БД данных об адресе компании
            address=Address.objects.using(dbase).create(
                country_name='Россия',
                country_full_name='Российская Федерация',
                region=post_region,
                district=post_district,
                locality=post_locality,
                city=post_city,
                street=post_street,
                home=post_home,
                flat=post_flat)
            
            # Запись в БД данных о новой компании
            buisiness=BuisinessCard.objects.using(dbase).create(
                business=post_business,
                orgform=OrgForm.objects.using(dbase).get(id=post_ogrn),
                full_name=post_full_name,
                short_name=post_short_name,
                inn=post_inn,
                kpp=post_kpp,
                ogrn=post_ogrn,
                site=post_site,
                email=post_email,
                address=address,
                director=director,
                director_power_type=post_director_power_type,
                director_power_number=post_director_power_number,
                director_power_date=post_director_power_date)
            
            # Запись в БД данных о расчетном счёте компании
            bank=Bank.objects.using(dbase).create(
                bik=post_bik_number,
                branch=post_bik_branch,
                city=post_bik_city,
                address=post_bik_address,
                ks=post_bik_ks,
                rs=post_bik_rs,
                owner_uid=post_inn,
                owner_type='bisiness')
    
    return render(
        request,
        'cards/buisiness.html',
        {
            'title': 'Компании',
            'orgforms': orgforms,
            'scripts': [                 
                'scripts/popup.js', 
                'scripts/form.js',
                'scripts/address.js',
                'scripts/bik.js',

            ]
        }
    )

def run_my_company(request): 
    username = request.user.username
    dbase = request.user.dbase
    persons = Person.objects.using(dbase)
    orgforms = OrgForm.objects.using(dbase)    
    try:
        my_bisiness_card = BuisinessCard.objects.using(dbase).get(business=username)
    except Exception:
        my_bisiness_card = None

    if request.method == 'GET':
        ...

    if request.method == 'POST':
        if request.POST['form'] == 'create_my_company':
            post_orgform = str(request.POST['orgform'])
            post_full_name = str(request.POST['full_name'])
            post_short_name = str(request.POST['short_name'])
            post_inn = str(request.POST['inn'])
            post_kpp = str(request.POST['kpp'])
            post_ogrn = int(request.POST['orgform'])
            post_site = str(request.POST['site'])
            post_email = str(request.POST['email'])
            if not my_bisiness_card:
                BuisinessCard(
                    orgform=OrgForm.objects.using(dbase).get(id=post_ogrn),
                    business=username,
                    full_name=post_full_name,
                    short_name=post_short_name,
                    inn=post_inn,
                    kpp=post_kpp,
                    ogrn=post_ogrn,
                    site=post_site,
                    email=post_email
                ).save(using=dbase)
            else:
                ...
                # print('I already have a business card', my_bisiness_card)

        elif request.POST['form'] == 'create_my_address':
            post_region = str(request.POST['region'])
            post_district = str(request.POST['district'])
            post_locality = str(request.POST['locality'])
            post_city = str(request.POST['city'])
            post_street = str(request.POST['street']) or ''
            post_home = str(request.POST['home']) or ''
            post_flat = str(request.POST['flat']) or ''            
            address = Address.objects.using(dbase).create(
                country_name='Россия',
                country_full_name='Российская Федерация',
                region=post_region,
                district=post_district,
                locality=post_locality,
                city=post_city,
                street=post_street,
                home=post_home,
                flat=post_flat
            )
            my_bisiness_card.address = address
            my_bisiness_card.save(using=dbase)

        elif request.POST['form'] == 'create_my_director':
            post_last_name = str(request.POST['last_name'])
            post_first_name = str(request.POST['first_name'])
            post_patr_name = str(request.POST['patr_name'])
            post_sex = True if request.POST.get('sex') == '1' else False
            post_birthday = request.POST['birthday']
            post_director_power_type = request.POST['director_power_type']
            post_director_power_number = request.POST['director_power_number']
            post_director_power_date = request.POST['director_power_date'] or None
            director = Person.objects.using(dbase).create(
                last_name=post_last_name,
                first_name=post_first_name,
                patr_name=post_patr_name,
                sex=post_sex,
                birthday=post_birthday,
            )
            my_bisiness_card.director = director
            my_bisiness_card.director_power_type = post_director_power_type
            my_bisiness_card.director_power_number = post_director_power_number
            my_bisiness_card.director_power_date = post_director_power_date
            my_bisiness_card.save(using=dbase)


# ======================================================================================================
        elif request.POST['form'] == 'new_person':
            post_last_name = str(request.POST['last_name'])
            post_first_name = str(request.POST['first_name'])
            post_patr_name = str(request.POST['patr_name'])
            post_sex = True if request.POST.get('sex') == '1' else False
            post_birthday = request.POST['birthday']
            Person(
                last_name=post_last_name,
                first_name=post_first_name,
                patr_name=post_patr_name,
                sex=post_sex,
                birthday=post_birthday
            ).save(using=dbase)

        elif request.POST['form'] == 'new_orgform':
            post_full_name = str(request.POST['full_name'])
            post_short_name = str(request.POST['short_name'])
            OrgForm(
                full_name=post_full_name,
                short_name=post_short_name
            ).save(using=dbase)

        elif request.POST['form'] == 'new_address':
            post_region = str(request.POST['region'])
            post_district = str(request.POST['district'])
            post_locality = str(request.POST['locality'])
            post_city = str(request.POST['city'])
            post_street = str(request.POST['street']) or ''
            post_home = str(request.POST['home']) or ''
            post_flat = str(request.POST['flat']) or ''            
            Address(
                country_name='Россия',
                country_full_name='Российская Федерация',
                region=post_region,
                district=post_district,
                locality=post_locality,
                city=post_city,
                street=post_street,
                home=post_home,
                flat=post_flat
            ).save(using=dbase)

        return redirect('run_my_company', permanent=True)


    
    return render(
        request,
        'cards/my_company.html',
        {
            'title': 'Моя компания',
            'persons': persons,
            'orgforms': orgforms,
            'my_bisiness_card': my_bisiness_card,
            'scripts': [                 
                'scripts/popup.js', 
                'scripts/form.js',
                'scripts/address.js',
            ]
        }
    )


