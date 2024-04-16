from django.db import models
from functools import cached_property

from app.agents.models import BankClient, BuisinessCard


class Sale(models.Model):
    """Договор продажи."""
    class Meta:
        db_table = 'sales'
    number = models.CharField(max_length=32)
    dt_issue = models.DateField()
    city = models.CharField(max_length=32)
    price = models.FloatField(default=0.0)
    decoration = models.BooleanField()
    escrow_agent = models.ForeignKey(BuisinessCard, on_delete=models.CASCADE)

    @cached_property
    def url(self) -> str:
        return f'{self.id}'

class SaleBankClient(models.Model):
    """Сделки с клиентами."""
    class Meta:
        db_table = 'sales_banks_clients'
    part = models.FloatField(default=0.0)
    pay_days = models.CharField(max_length=3)
    own_money = models.FloatField(default=0.0)
    credit_money = models.FloatField(default=0.0)
    sale = models.ForeignKey(Sale, on_delete=models.CASCADE)
    bank_client = models.ForeignKey(BankClient, on_delete=models.CASCADE)