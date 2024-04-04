from django.db import models

class Address(models.Model):
    """Адрес."""
    class Meta:
        db_table = 'addresses'
    id = models.AutoField(primary_key=True)
    contry_name = models.CharField(max_length=32)
    country_full_name = models.CharField(max_length=64)
    region = models.CharField(max_length=64)
    district = models.CharField(max_length=64)
    sity = models.CharField(max_length=64)
    street = models.CharField(max_length=64)
    home = models.CharField(max_length=16)
    flat = models.CharField(max_length=4)
