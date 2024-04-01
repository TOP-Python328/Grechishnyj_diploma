from django import forms
from django.core.exceptions import ValidationError
from re import compile
from app.flats.models import Microdistrict, House, EnergySave, Seismic, SaleStatus, HouseType, BuildingPermit, Section, Floor, Flat, Room



def validate_name(value: str):
    reg_name = compile(r'[A-Za-zА-ЯЁа-яё\- ]{3,}')
    if not reg_name.fullmatch(value):
        raise ValidationError(f'Валидация строки {value!r} не пройдена.')

# class CustomForm(forms.Form):

#     def __init__(self, *args, **kwargs):
#         self.dbase = kwargs.pop('dbase', None)
#         super(self.__class__.__mro__[1], self).__init__(*args, **kwargs)



class AddRoomForm(forms.Form):
    class Meta:
        model = Room
        fields = ['name', 'living', 'koef_price']

    def __init__(self, *args, **kwargs):
        self.dbase = kwargs.pop('dbase', None)
        super(AddRoomForm, self).__init__(*args, **kwargs)

        self.fields['name'] = forms.CharField(label='Наименование комнаты', max_length=32, validators=[validate_name])
        self.fields['living'] = forms.BooleanField(label='Жилая / нежилая', required=False)
        self.fields['koef_price'] = forms.ChoiceField(label='Ценовой коэффициент', choices={'1.0': '1.0', '0.5': '0.5', '0.3': '0.3'})

    def save_to_database(self):
        Room.objects.using(self.dbase).create(
            name=self.cleaned_data['name'],
            living=self.cleaned_data['living'],
            koef_price=self.cleaned_data['koef_price']
        )





class AddFlatForm(forms.Form):
    class Meta:
        model = Flat
        fields = ['number', 'floor', 'status']

    def __init__(self, *args, **kwargs):
        self.dbase = kwargs.pop('dbase', None)
        super(AddFlatForm, self).__init__(*args, **kwargs)

        self.fields['number'] = forms.CharField(label='номер квартиры', max_length=4)
        self.fields['floor'] = forms.CharField(label='номер квартиры', max_length=4)
        self.fields['status'] = forms.ChoiceField(label='Статус', choices={'':''}|{
            status.name : status.name
            for status in SaleStatuse.objects.using(self.dbase)
        })

    def save_to_database(self):
        Flat.objects.using(self.dbase).create(
            number=self.cleaned_data['name'],
            floor=self.cleaned_data['living'],
            status=self.cleaned_data['koef_price']
        )

# class AddFlatForm(forms.Form):
#     def __init__(self, *args, **kwargs):
#         self.dbase = kwargs.pop('dbase', None)
#         super(AddFlatForm, self).__init__(*args, **kwargs)

#         self.fields['number'] = forms.CharField(label='номер квартиры', max_length=4)
#         self.fields['floor'] = forms.CharField(label='номер квартиры', max_length=4)
#         self.fields['status'] = forms.ChoiceField(label='Статус', choices={
#             status.name: status.name
#             for status in SaleStatuse.objects.using(self.dbase)
#         })

#     def save_to_database(self):
#         Flat.objects.using(self.dbase).create(
#             number=self.cleaned_data['name'],
#             floor=self.cleaned_data['living'],
#             status=self.cleaned_data['koef_price']
#         )
    

    

    def save_to_database(self):
        Flat.objects.using(self.dbase).create(
            number=self.cleaned_data['name'],
            # floor=Floor.objects.using(self.dbase).get(pk=self.cleaned_data['floor']),
            status=self.cleaned_data['status'],
        )



class AddMicrodistrictForm(forms.Form):
    class Meta:
        model = Microdistrict
        fields = ['name']

    name = forms.CharField(label='Name', max_length=32, validators=[validate_name])

    def save_to_database(self, user_database):
        Microdistrict.objects.using(user_database).create(
            name=self.cleaned_data['name']
        )

class AddHouseForm(forms.Form):

    class Meta:
        model = House
        fields = ['number', 'building_permit', 'microdistrict', 'energy_save', 'seismic', 'type']

    def __init__(self, *args, **kwargs):
        self.dbase = kwargs.pop('dbase', None)
        super(AddHouseForm, self).__init__(*args, **kwargs)

        self.fields['number'] = forms.CharField(label='Number', max_length=8)
        self.fields['microdistrict'] = forms.ChoiceField(label='Микрорайон', choices={'':''}|{
            microdistrict.id : microdistrict.name
            for microdistrict in Microdistrict.objects.using(self.dbase).order_by('name')
        })
        self.fields['building_permit'] = forms.ChoiceField(label='Разрешение на строительство', choices={'':''}|{
            building_permit.id : building_permit.number
            for building_permit in BuildingPermit.objects.using(self.dbase).order_by('number')
        })
        self.fields['energy_save'] = forms.ChoiceField(label='Энергоэффективность', choices={'':''}|{
            energy_save.name : energy_save.name
            for energy_save in EnergySave.objects.using(self.dbase)
        })
        self.fields['seismic'] = forms.ChoiceField(label='Сейсмостройкость', choices={'':''}|{
            seismic.name : seismic.name
            for seismic in Seismic.objects.using(self.dbase)
        })
        self.fields['type'] = forms.ChoiceField(label='Тип дома', choices={'':''}|{
            house_type.id : house_type.name
            for house_type in HouseType.objects.using(self.dbase)
        })


    def save_to_database(self):
        house = House.objects.using(self.dbase).create(
            number=self.cleaned_data['number'],
            building_permit=BuildingPermit.objects.using(self.dbase).get(pk=self.cleaned_data['building_permit']),
            microdistrict=Microdistrict.objects.using(self.dbase).get(pk=self.cleaned_data['microdistrict']),
            energy_save=EnergySave.objects.using(self.dbase).get(name=self.cleaned_data['energy_save']),
            seismic=Seismic.objects.using(self.dbase).get(name=self.cleaned_data['seismic']),
            type=HouseType.objects.using(self.dbase).get(pk=self.cleaned_data['type']),
        )




class AddBuildingPermitsForm(forms.Form):
    class Meta:
        model = BuildingPermit
        fields = ['number', 'dt_issue', 'dt_expiry']

    number = forms.CharField(label='Number', max_length=32)
    dt_issue = forms.DateField()
    dt_expiry = forms.DateField()

    def save_to_database(self, user_database):
        building = BuildingPermit.objects.using(user_database).create(
            number=self.cleaned_data['number'],
            dt_issue=self.cleaned_data['dt_issue'],
            dt_expiry=self.cleaned_data['dt_expiry']
        )
        print(building.__dict__)


class AddSectionForm(forms.Form):
    class Meta:
        model = Section
        fields = ['number', 'house', 'type']

        # number = models.CharField(max_length=2)
        # house = models.ForeignKey(House, on_delete=models.CASCADE)
        # type = models.ForeignKey(SectionType, on_delete=models.CASCADE)





    
    
