from django import forms
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.forms import AuthenticationForm

from app.users.models import CustomUser

class CustomUserRegisterForm(UserCreationForm):

    class Meta:
        model = CustomUser
        dbase = forms.CharField(widget=forms.HiddenInput())
        fields = ('username', 'password1', 'password2', 'email')

    username = forms.CharField(max_length=20, label=False) 
    password1 = forms.CharField(max_length=20, label=False, widget=forms.PasswordInput)
    password2 = forms.CharField(max_length=20, label=False, widget=forms.PasswordInput)
    email = forms.EmailField(max_length=100, label=False) 
    

    def __init__(self, *args, **kwargs): 
        super().__init__(*args, **kwargs) 
        self.class_name = 'сustom_form'
        self.fields['username'].widget.attrs.update({ 
            'class': 'form-input', 
            'required':'', 
            'autocomplete': 'off',
            'name':'username', 
            'id':'username', 
            'type':'text', 
            'placeholder':'username'
            }) 
        self.fields['password1'].widget.attrs.update({ 
            'class': 'form-input', 
            'required':'',
            'autocomplete': 'off', 
            'name':'password1', 
            'id':'password1', 
            'type':'password', 
            'placeholder':'password'
            }) 
        self.fields['password2'].widget.attrs.update({ 
            'class': 'form-input', 
            'required':'', 
            'autocomplete': 'off',
            'name':'password2', 
            'id':'password2', 
            'type':'password', 
            'placeholder':'password'
            }) 
        self.fields['email'].widget.attrs.update({ 
            'class': 'form-input', 
            'required':'', 
            'autocomplete': 'off',
            'name':'email', 
            'id':'email', 
            'type':'email', 
            'placeholder':'email'
            }) 
        
        
class CustomAuthenticationForm(AuthenticationForm):
    class Meta:
        model = CustomUser
        fields = ('username', 'password')

    username = forms.CharField(max_length=20, label=False) 
    password = forms.CharField(max_length=20, label=False, widget=forms.PasswordInput)

    def __init__(self, *args, **kwargs): 
        super().__init__(*args, **kwargs) 
        self.class_name = 'сustom_form'
        self.fields['username'].widget.attrs.update({ 
            'class': 'form-input', 
            'required':'', 
            'autocomplete': 'off',
            'name':'username', 
            'id':'username', 
            'type':'text', 
            'placeholder':'username'
            }) 
        self.fields['password'].widget.attrs.update({ 
            'class': 'form-input', 
            'required':'',
            'autocomplete': 'off', 
            'name':'password', 
            'id':'password', 
            'type':'password', 
            'placeholder':'password'
            }) 

 




        
