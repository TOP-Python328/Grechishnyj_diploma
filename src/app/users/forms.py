from django import forms
from django.contrib.auth.forms import UserCreationForm

from app.users.models import CustomUser


class CustomUserRegisterForm(UserCreationForm):
    class Meta:
        model = CustomUser
        dbase = forms.CharField(widget=forms.HiddenInput())
        fields = ('username', 'password1', 'password2', 'email')

        
