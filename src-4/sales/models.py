from django.db import models

from flats.models import Flat
from clients.models import Client



class ContractType(models.Model):
    """Тип договора"""
    class Meta:
        db_table = 'contracts_type'

    name = models.CharField(max_length=64, unique=True)



class Contract(models.Model):
    """Договор"""
    class Meta:
        db_table = 'contracts'

    number = models.CharField(max_length=32, primary_key=True)
    type = models.ForeignKey(ContractType, on_delete=models.CASCADE)
    flat = models.ForeignKey(Flat, on_delete=models.CASCADE)
    price = models.FloatField()
    dt_issue = models.DateField()



class Sale(models.Model):
    """Продажа"""
    class Meta:
        db_table = 'sales'

    id = models.AutoField(primary_key=True)
    contract = models.ForeignKey(Contract, on_delete=models.CASCADE)
    client = models.ForeignKey(Client, on_delete=models.CASCADE)
    part_price = models.FloatField()
