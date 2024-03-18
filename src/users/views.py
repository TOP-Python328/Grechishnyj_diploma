from django.shortcuts import render, redirect
from django.contrib.auth.forms import AuthenticationForm
from django.contrib.auth import login as auth_login, logout as auth_logout, authenticate

from users.forms import CustomUserRegisterForm
from users.models import CustomUser


def register(request):
    """Регистрация."""
    if request.method == 'GET':
        form = CustomUserRegisterForm()
    elif request.method == 'POST':
        form = CustomUserRegisterForm(request.POST)
        if form.is_valid():
            form.save()
            username = form.cleaned_data.get('username')
            password = form.cleaned_data.get('password1')
            user = authenticate(username=username, password=password)
            auth_login(request, user)
            return redirect('main', permanent=True)

    return render(
        request,
        'auth/register.html',
        {
            'form': form,
            'scripts': []
        }
    )


def login(request):
    """Вход в систему."""
    if request.method == 'GET':
        form = AuthenticationForm()

    elif request.method == 'POST':
        form = AuthenticationForm(data=request.POST)

        if form.is_valid():
            auth_login(request, form.get_user())
            return redirect('main', permanent=True)

    return render(
        request,
        'auth/login.html',
        {
            'form': form,
            'scripts': [],
        }
    )


def logout(request):
    """Выход из системы."""
    auth_logout(request)
    return redirect('user_login', permanent=True)
