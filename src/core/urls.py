from django.contrib import admin
from django.urls import path

from app.index import views as index
from app.users import views as users
from app.flats import views as rooms

urlpatterns = [
    # path('admin/', admin.site.urls),

    path('', index.main, name='main'),
    path('register', users.register, name='user_register'),
    path('login', users.login, name='user_login'),
    path('logout', users.logout, name='user_logout'),

    path('rooms', rooms.get_all_rooms, name='app_flats_rooms'),








]
