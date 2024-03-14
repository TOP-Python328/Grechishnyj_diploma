from django.shortcuts import render
from datetime import date

from persons.models import Person, Passport
from addresses.models import Country, Locality, Region, Address


def add_person(request):
    Person(
        last_name=request.POST['last_name'],
        first_name=request.POST['first_name'],
        patr_name=request.POST['patr_name'],
        birthday=request.POST['birthday'],
        sex_id=bool(request.POST['sex'])
    ).save()


def get_all_persons(request):
    persons = Person.objects.order_by('id')

    if request.method == 'POST':
        print(add_person(request))

    return render(
        request,
        'persons/persons.html',
        {
            'title': 'Persons',
            'persons': persons,
            'scripts': [
                'scripts/popup.js',
            ]
        }
    )

def get_person(request, uniq: str):
    person = Person.objects.get(id=int(uniq))

    return render(
        request, 
        'persons/person.html',
        {
            'title': f'Person {person.last_name}',
            'person': person,
        }
    )

def get_all_passports(request):
    passports = Passport.objects.order_by('id')

    # if request.method == 'POST':
    #     print(add_person(request))

    return render(
        request,
        'persons/passports.html',
        {
            'title': 'Passports',
            'persons': passports,
            'scripts': [
                'scripts/popup.js',
            ]
        }
    )




