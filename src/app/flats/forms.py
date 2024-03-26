from django import forms
from django.core.exceptions import ValidationError
from re import compile
from app.flats.models import Microdistricts, Houses, Rooms



def validate_name(value: str):
    reg_name = compile(r'[A-Za-zА-ЯЁа-яё\- ]{3,}')
    if not reg_name.fullmatch(value):
        raise ValidationError(f'Валидация строки {value!r} не пройдена.')


class AddRoomForm(forms.Form):
    name = forms.CharField(label='Name', max_length=32, validators=[validate_name])
    living = forms.BooleanField(label='Living', required=False)
    koef_price = forms.FloatField(label='Koef Price')


class AddMicrodistrictForm(forms.Form):
    name = forms.CharField(label='Name', max_length=32, validators=[validate_name])

    def save_to_database(self, user_database):
        Microdistricts.objects.using(user_database).create(
            name=self.cleaned_data['name']
        )

class AddHouseForm(forms.Form):
    number = forms.CharField(label='Number', max_length=8)

    def save_to_database(self, user_database):
        Houses.objects.using(user_database).create(
            name=self.cleaned_data['name']
        )

    # id = models.AutoField(primary_key=True)
    # number = models.CharField(max_length=8)
    # building_permit = models.ForeignKey(BuildingPermits, on_delete=models.CASCADE)
    # microdistrict = models.ForeignKey(Microdistricts, on_delete=models.CASCADE)
    # energy_save = models.ForeignKey(EnergySaves, on_delete=models.CASCADE)
    # seismic = models.ForeignKey(Seismics, on_delete=models.CASCADE)
    # type = models.ForeignKey(HouseTypes, on_delete=models.CASCADE)

