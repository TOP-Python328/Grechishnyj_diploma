from django.db import models
from functools import cached_property
from addresses.models import Address
from persons.models import Person


class Orgform(models.Model):
    """Организационная форма"""
    class Meta:
        db_table = 'orgforms'

    name = models.CharField(max_length=256)
    short_name = models.CharField(max_length=16)



class BisinessCard(models.Model):
    """Деловая карта"""
    class Meta:
        db_table = 'bisiness_cards'

    orgform = models.ForeignKey(Orgform, on_delete=models.CASCADE)
    name = models.CharField(max_length=256)
    ogrn = models.CharField(max_length=16, unique=True)
    # инн
    unic = models.CharField(max_length=16, unique=True, primary_key=True)
    kpp = models.CharField(max_length=16, null=True)
    address = models.ForeignKey(Address, on_delete=models.CASCADE)
    director = models.ForeignKey(Person, on_delete=models.CASCADE, null=True)

    @cached_property
    def url(self) -> str:
        return f'{self.unic}'

    




