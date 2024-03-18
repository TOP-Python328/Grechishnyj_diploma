from django.db import models
from functools import cached_property

class Room(models.Model):
    """Комната."""
    class Meta:
        db_table = 'rooms'

    name = models.CharField(max_length=32, unique=True)
    living = models.BooleanField(default=False)
    koef_price = models.FloatField()

    def __repr__(self):
        return f'{self.name}'

    def __str__(self):
        return f'{self.name}'


class SaleStatus(models.Model):
    """Статус продажи."""
    class Meta:
        db_table = 'sale_statuses'
    
    name = models.CharField(max_length=16, primary_key=True)

    def __repr__(self):
        return f'{self.name}'

    def __str__(self):
        return f'{self.name}'


class EnergySave(models.Model):
    """Класс энергосбережения."""
    class Meta:
        db_table = 'energy_saves'

    name = models.CharField(max_length=4, primary_key=True)

    def __str__(self):
        return f'{self.name}'


class Seismic(models.Model):
    """Класс сейсмоустойчивости."""
    class Meta:
        db_table = 'seismics'

    name = models.CharField(max_length=4, primary_key=True)

    def __str__(self):
        return f'{self.name}'


class Construction(models.Model):
    """Микрорайон (квартал, застройка)."""
    class Meta:
        db_table = 'constructions'
    
    name = models.CharField(max_length=32, unique=True)

    @cached_property
    def url(self) -> str:
        return f'{self.id}'

    def __repr__(self):
        return f'{self.name}'

    def __str__(self):
        return f'{self.name}'


class BuildingPermit(models.Model):
    """Разрешение на строительство."""
    class Meta:
        db_table = 'building_permits'
    
    number = models.CharField(max_length=32, unique=True)
    dt_issue = models.DateField()
    dt_expiry = models.DateField()

    def __repr__(self):
        return f'{self.number}: {self.dt_issue} - {self.dt_expiry}'


class HouseType(models.Model):
    """Вид дома"""
    class Meta:
        db_table = 'house_types'

    name = models.CharField(max_length=128)


class House(models.Model):
    """Многоквартирный дом."""
    
    class Meta:
        db_table = 'houses'

    number = models.CharField(max_length=8)
    construction = models.ForeignKey(Construction, on_delete=models.CASCADE)
    building_permit = models.ForeignKey(BuildingPermit, on_delete=models.CASCADE)
    seismic = models.ForeignKey(Seismic, on_delete=models.CASCADE)
    energy_save = models.ForeignKey(EnergySave, on_delete=models.CASCADE)
    type = models.ForeignKey(HouseType, on_delete=models.CASCADE)

    @cached_property
    def url(self) -> str:
        return f'{self.id}'

    def __repr__(self):
        return f'{self.number}'


class SectionType(models.Model):
    """Тип секции (подъезда)."""
    class Meta:
        db_table = 'section_types'
    
    name = models.CharField(max_length=32, primary_key=True)

    def __repr__(self):
        return f'{self.name}'


class Section(models.Model):
    """Секция (подъезд)."""
    class Meta:
        db_table = 'sections'

    number = models.CharField(max_length=2)
    name = models.ForeignKey(SectionType, on_delete=models.PROTECT)
    house = models.ForeignKey(House, on_delete=models.CASCADE)

    def __repr__(self):
        return f'{self.number}'


class Floor(models.Model):
    """Этаж."""
    class Meta:
        db_table = 'floors'

    number = models.CharField(max_length=2)
    section = models.ForeignKey(Section, on_delete=models.CASCADE)

    def __repr__(self):
        return f'{self.number}'


class Flat(models.Model):
    """Квартира."""
    class Meta:
        db_table = 'flats'

    number = models.CharField(max_length=4)
    floor = models.ForeignKey(Floor, on_delete=models.CASCADE)
    status = models.ForeignKey(SaleStatus, on_delete=models.PROTECT)

    @cached_property
    def url(self) -> str:
        return f'{self.id}'

    def __repr__(self):
        return f'{self.number}'


class Plan(models.Model):
    """Планировка квартиры."""
    flat = models.ForeignKey(Flat, on_delete=models.CASCADE)
    room = models.ForeignKey(Room, on_delete=models.CASCADE)
    square = models.FloatField()


