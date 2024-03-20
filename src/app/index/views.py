from django.shortcuts import render
from app.users.models import CustomUser



def main(request):
    print(CustomUser)
    # print(request)
    return render(
        request, 
        'index.html', 
        {
            'title': 'Главная страница',
        }
    )



