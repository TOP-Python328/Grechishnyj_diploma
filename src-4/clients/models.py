from django.db import models

from persons.models import Passport
from bisiness.models import BisinessCard

class Client(models.Model):
    """Клиент покупатель"""
    class Meta:
        db_table = 'clients'
    
    # Связь c Passport или BisinessCard
    unic = models.CharField(max_length=16, unique=True, primary_key=True)



class Bank(models.Model):
    """Банк - отделение, счёт"""
    class Meta:
        db_table = 'banks'

    bik = models.CharField(max_length=16)
    department = models.CharField(max_length=128)
    bisiness_card = models.ForeignKey(BisinessCard, on_delete=models.CASCADE)
    pay_account = models.CharField(max_length=32, unique=True, primary_key=True)
    cor_account = models.CharField(max_length=32)
    client = models.ForeignKey(Client, on_delete=models.CASCADE)

    

