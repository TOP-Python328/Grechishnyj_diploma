from django.contrib import admin
from django.urls import path

from index import views as index
from users import views as users

urlpatterns = [
    # path('admin/', admin.site.urls),

    path('', index.main, name='main'),
    path('register', users.register, name='user_register'),
    path('login', users.login, name='user_login'),
    path('logout', users.logout, name='user_logout'),








]
