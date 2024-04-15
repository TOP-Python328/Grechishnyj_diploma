from django.db import models
from functools import cached_property
from app.assist.models import Address
from app.users.models import CustomUser

class Person(models.Model):
    """Персона."""
    class Meta:
        db_table = 'persons'
    last_name = models.CharField(max_length=64)
    first_name = models.CharField(max_length=64)
    patr_name = models.CharField(max_length=64, blank=True, null=True)
    sex = models.BooleanField()
    birthday = models.DateField()

class Client(models.Model):
    """Клиент."""
    class Meta:
        db_table = 'clients'
    uid = models.CharField(max_length=16, unique=True)

class Passport(Client):
    """Паспорт."""
    class Meta:
        db_table = 'passports'
    series = models.CharField(max_length=8)
    number = models.CharField(max_length=8)
    police_name = models.CharField(max_length=256)
    police_code = models.CharField(max_length=16)
    place_birth = models.CharField(max_length=256)
    dt_issue = models.DateField()
    address = models.ForeignKey(Address, on_delete=models.CASCADE)
    person = models.ForeignKey(Person, on_delete=models.CASCADE)
    client = models.ForeignKey(Client, on_delete=models.CASCADE, related_name='passports') 

class OrgForm(models.Model):
    """Организационно правовая форма."""
    class Meta:
        db_table = 'orgforms'
    full_name = models.CharField(max_length=256)
    short_name = models.CharField(max_length=16)

class BuisinessCard(models.Model):
    """Бизнес-карта."""
    class Meta:
        db_table = 'buisiness_cards'
    full_name = models.CharField(max_length=256, blank=True, null=True)
    short_name = models.CharField(max_length=64)
    inn = models.CharField(max_length=16)
    kpp = models.CharField(max_length=16)
    ogrn = models.CharField(max_length=16)
    business = models.CharField(max_length=32)
    site = models.CharField(max_length=64, null=True)
    email = models.CharField(max_length=64, null=True)
    director_power_type = models.CharField(max_length=32, null=True)
    director_power_number = models.CharField(max_length=32, null=True)
    director_power_date = models.DateField(null=True)
    director = models.ForeignKey(Person, on_delete=models.CASCADE, null=True)
    address = models.ForeignKey(Address, on_delete=models.CASCADE, null=True)
    orgform = models.ForeignKey(OrgForm, on_delete=models.CASCADE)



class Bank(models.Model):
    """Банк."""
    class Meta:
        db_table = 'banks'
    bik = models.CharField(max_length=16)
    branch = models.CharField(max_length=128)
    ks = models.CharField(max_length=32)
    rs = models.CharField(max_length=32)
    city = models.CharField(max_length=(64), null=True)
    address = models.CharField(max_length=(128), null=True)
    owner_uid = models.CharField(max_length=16) # на удаление
    owner_type = models.CharField(max_length=16) #buisiness and individuals # на удаление

class ClientBank(models.Model):
    """Банковские счета клиентов."""
    class Meta:
        db_table = 'clients_banks'
    client = models.ForeignKey(Client, on_delete=models.CASCADE)
    bank = models.ForeignKey(Bank, on_delete=models.CASCADE)

