from django.shortcuts import render
from app.users.models import CustomUser
from app.users.forms import CustomUserRegisterForm

def main(request):
    form = CustomUserRegisterForm()
    return render(
        request, 
        'index.html', 
        {
            'title': 'Главная страница',
            'h1': 'Главная страница',
            'form': form,
        }
    )