from django.shortcuts import render

from bisiness.models import BisinessCard
from addresses.models import Address
from persons.models import Person 

def get_all_bisiness(request):
    return render(
        request,
        'bisiness/bisiness.html',
        {
            'title': 'Bisiness',
            'bisiness_cards': BisinessCard.objects.order_by('unic'),
        }
    )

def get_bisiness_card(request, uniq: str):
    bisiness_card = BisinessCard.objects.get(unic=uniq)
    print(bisiness_card)
    return render(
        request, 
        'bisiness/bisiness_card.html',
        {
            'title': f'Bisiness card {bisiness_card.name}',
            'bisiness_card': bisiness_card,
        }
    )


