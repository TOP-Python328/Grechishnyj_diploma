from django.shortcuts import render, redirect

from app.assist.models import Address

from app.firms.models import Person, OrgForm, BusinessCard





def run_my_company(request): 
    username = request.user.username
    dbase = request.user.dbase
    persons = Person.objects.using(dbase)
    orgforms = OrgForm.objects.using(dbase)    
    try:
        my_bisiness_card = BusinessCard.objects.using(dbase).get(username=username)
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
            if not my_bisiness_card:
                BusinessCard(
                    orgform = OrgForm.objects.using(dbase).get(id=post_ogrn),
                    username = username,
                    full_name = post_full_name,
                    short_name = post_short_name,
                    inn = post_inn,
                    kpp = post_kpp,
                    ogrn = post_ogrn,
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
            director = Person.objects.using(dbase).create(
                last_name=post_last_name,
                first_name=post_first_name,
                patr_name=post_patr_name,
                sex=post_sex,
                birthday=post_birthday
            )
            my_bisiness_card.director = director
            my_bisiness_card.save(using=dbase)

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
        'firms/my_company.html',
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


