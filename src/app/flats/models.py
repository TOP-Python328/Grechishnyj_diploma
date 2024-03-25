from django.db import models
from functools import cached_property

class Room(models.Model):
    """Комната."""
    class Meta:
        db_table = 'rooms'

    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=32, unique=True)
    living = models.BooleanField(default=False)
    koef_price = models.FloatField()

    def __repr__(self):
        return f'{self.name}'

    def __str__(self):
        return f'{self.name}'
