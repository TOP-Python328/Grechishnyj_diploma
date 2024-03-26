from django.db import models

class EnergySaves(models.Model):
    """Эноргосбережение."""
    class Meta:
        db_table = 'energy_saves'
    name = models.CharField(max_length=4, primary_key=True)

class Seismics(models.Model):
    """Сейсмостойкость."""
    class Meta:
        db_table = 'seismics'
    name = models.CharField(max_length=4, primary_key=True)

class SaleStatuses(models.Model):
    """Статус продажи."""
    class Meta:
        db_table = 'sale_statuses'
    name = models.CharField(max_length=16, primary_key=True)

class Rooms(models.Model):
    """Комната."""
    class Meta:
        db_table = 'rooms'
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=32, unique=True)
    living = models.BooleanField()
    koef_price = models.FloatField()

class BuildingPermits(models.Model):
    """Разрешение на строительство."""
    class Meta:
        db_table = 'building_permits'
    id = models.AutoField(primary_key=True)
    number = models.CharField(max_length=32, unique=True)
    dt_issue = models.DateField()
    dt_expiry = models.DateField()

class HouseTypes(models.Model):
    """Тип многоэтажного дома."""
    class Meta:
        db_table = 'house_types'
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=128)

class Microdistricts(models.Model):
    """Микрорайон."""
    class Meta:
        db_table = 'microdistricts'
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=32, unique=True)

class Houses(models.Model):
    """Многоквартирый дом."""
    class Meta:
        db_table = 'houses'
    id = models.AutoField(primary_key=True)
    number = models.CharField(max_length=8)
    building_permit = models.ForeignKey(BuildingPermits, on_delete=models.CASCADE)
    microdistrict = models.ForeignKey(Microdistricts, on_delete=models.CASCADE)
    energy_save = models.ForeignKey(EnergySaves, on_delete=models.CASCADE)
    seismic = models.ForeignKey(Seismics, on_delete=models.CASCADE)
    type = models.ForeignKey(HouseTypes, on_delete=models.CASCADE)

class SectionTypes(models.Model):
    """Тип подьезда."""
    class Meta:
        db_table = 'section_types'
    name = models.CharField(max_length=32, primary_key=True)

class Sections(models.Model):
    """Секция (подьезд)."""
    class Meta:
        db_table = 'sections'
    id = models.AutoField(primary_key=True)
    number = models.CharField(max_length=2)
    house = models.ForeignKey(Houses, on_delete=models.CASCADE)
    type = models.ForeignKey(SectionTypes, on_delete=models.CASCADE)

class Floors(models.Model):
    """Этаж."""
    class Meta:
        db_table = 'floors'
    id = models.AutoField(primary_key=True)
    number = models.CharField(max_length=4)

class Flats(models.Model):
    """Квартира."""
    class Meta:
        db_table = 'flats'
    id = models.AutoField(primary_key=True)
    number = models.CharField(max_length=4)
    floor = models.ForeignKey(Floors, on_delete=models.CASCADE)
    status = models.ForeignKey(SaleStatuses, on_delete=models.CASCADE)

class FlatsPlan(models.Model):
    """Планировка квартиры."""
    class Meta:
        db_table = 'flats_rooms'
    id = models.AutoField(primary_key=True)
    square = models.FloatField()
    flat = models.ForeignKey(Flats, on_delete=models.CASCADE)
    room = models.ForeignKey(Rooms, on_delete=models.CASCADE)