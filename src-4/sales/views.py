from django.http import HttpResponse
from django.shortcuts import render


def get_all(request):
    return render(
        request, 
        'sales/all.html',
        {
            'title': 'Продажи',
        }    
    )

def add_contract(request):
    return render(
        request,
        'sales/trade.html',
        {
            'title': 'Новая сделка',
        }
    )




