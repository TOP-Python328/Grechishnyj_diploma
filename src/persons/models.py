from django.db import models
from functools import cached_property
from addresses.models import Address

class Sex(models.Model):
    """Пол"""
    class Meta:
        db_table = 'sex'

    id = models.BooleanField(primary_key=True, unique=True)
    name = models.CharField(max_length=8, unique=True)


class Person(models.Model):
    """Человек"""
    class Meta:
        db_table = 'persons'

    last_name = models.CharField(max_length=32)
    first_name = models.CharField(max_length=32)
    patr_name = models.CharField(max_length=32, null=True)
    birthday = models.DateField()
    sex = models.ForeignKey(Sex, on_delete=models.PROTECT)

    @cached_property
    def url(self) -> str:
        return f'{self.id}'


class Passport(models.Model):
    """Паспорт"""
    class Meta:
        db_table = 'passports'

    series = models.CharField(max_length=4)
    number = models.CharField(max_length=8)
    unic = models.CharField(max_length=16, unique=True, primary_key=True)
    police = models.CharField(max_length=256)
    police_code = models.CharField(max_length=8)
    dt_issue = models.DateField()
    birth_place = models.CharField(max_length=128) 
    address = models.ForeignKey(Address, on_delete=models.CASCADE)
    person = models.OneToOneField(Person, on_delete = models.CASCADE)
    

