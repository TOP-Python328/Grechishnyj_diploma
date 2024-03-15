from django.shortcuts import render, redirect
from users.forms import CustomUserRegisterForm
from users.models import CustomUser


from utils.mixtures import randomword


def register(request):
    """Регистрация."""
    if request.method == 'GET':
        form = CustomUserRegisterForm()

    elif request.method == 'POST':
        form = CustomUserRegisterForm(request.POST)
        print(form.fields)
        if form.is_valid():
            

            form.save()
            return redirect('main', permanent=True)


    return render(
        request,
        'auth/register.html',
        {
            'form': form,
            'scripts': []
        }
    )


