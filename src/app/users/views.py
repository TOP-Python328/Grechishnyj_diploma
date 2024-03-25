from django.shortcuts import render, redirect
from django.contrib.auth.forms import AuthenticationForm
from django.contrib.auth import login as auth_login, logout as auth_logout, authenticate

from system.adapter import DataBaseAdapter
from system.utils import randomword
from app.users.forms import CustomUserRegisterForm
from app.users.models import CustomUser

from core.settings import BASE_DIR, DATABASES



from .router import Router


def register(request):
    """Регистрация."""
    if request.method == 'GET':
        form = CustomUserRegisterForm()
    elif request.method == 'POST':
        form = CustomUserRegisterForm(request.POST)
        if form.is_valid():
            # сохранение пользователя в базу данных
            user = form.save(commit=False)
            user.dbase = f'{randomword(16)}'
            user.save()
            # авторизация пользователя
            username = form.cleaned_data.get('username')
            password = form.cleaned_data.get('password1')
            user = authenticate(username=username, password=password)
            auth_login(request, user)
            # создание базовых таблиц в пользовательской базе данных
            user.run_base_migrate()
            # добавление пользовательской базы данных системные настройки 

            # DATABASES[f'{user.dbase}'] = f'{BASE_DIR / user.dbase}'
            # print(f'{BASE_DIR / user.dbase}')

            # print(DATABASES)
            DataBaseAdapter.add_db_in_config(user.dbase)

            DataBaseAdapter.update_databases(DATABASES, user.dbase)
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
