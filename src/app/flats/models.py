from django.db import models
from functools import cached_property
from app.assist.models import Address

class EnergySave(models.Model):
    """Эноргосбережение."""
    class Meta:
        db_table = 'energy_saves'
    name = models.CharField(max_length=4, primary_key=True)

class Seismic(models.Model):
    """Сейсмостойкость."""
    class Meta:
        db_table = 'seismics'
    name = models.CharField(max_length=4, primary_key=True)

class SaleStatus(models.Model):
    """Статус продажи."""
    class Meta:
        db_table = 'sale_statuses'
    name = models.CharField(max_length=16, primary_key=True)

class Material(models.Model):
    """Материалы."""
    class Meta:
        db_table = 'materials'
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=32, unique=True)

class LandPlot(models.Model):
    """Земельный участок."""
    class Meta:
        db_table = 'land_plots'
    id = models.AutoField(primary_key=True)
    number = models.CharField(max_length=64, unique=True)
    square = models.FloatField(null=True, default=0.0)
    usage = models.CharField(max_length=128)
    category = models.CharField(max_length=128)
    owner_type = models.CharField(max_length=64)
    owner_number = models.CharField(max_length=64)
    owner_date = models.DateField()
    owner_reg_number = models.CharField(max_length=64)
    owner_reg_date = models.DateField()
    document_egrn = models.DateField()

class BuildingPermit(models.Model):
    """Разрешение на строительство."""
    class Meta:
        db_table = 'building_permits'
    id = models.AutoField(primary_key=True)
    number = models.CharField(max_length=32, unique=True)
    dt_issue = models.DateField()
    dt_expiry = models.DateField()
    land_plot = models.ForeignKey(LandPlot, on_delete=models.CASCADE)

class HouseType(models.Model):
    """Тип многоэтажного дома."""
    class Meta:
        db_table = 'house_types'
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=128)

class Microdistrict(models.Model):
    """Микрорайон."""
    class Meta:
        db_table = 'microdistricts'
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=32, unique=True)
    full_name = models.TextField(max_length=1000, null=True)

class House(models.Model):
    """Многоквартирый дом."""
    class Meta:
        db_table = 'houses'
    id = models.AutoField(primary_key=True)
    number = models.CharField(max_length=8)
    building_permit = models.ForeignKey(BuildingPermit, on_delete=models.CASCADE)
    microdistrict = models.ForeignKey(Microdistrict, on_delete=models.CASCADE)
    energy_save = models.ForeignKey(EnergySave, on_delete=models.CASCADE)
    seismic = models.ForeignKey(Seismic, on_delete=models.CASCADE)
    type = models.ForeignKey(HouseType, on_delete=models.CASCADE)
    material_wall = models.ForeignKey(Material, on_delete=models.CASCADE, related_name='wall_houses')
    material_floor = models.ForeignKey(Material, on_delete=models.CASCADE, related_name='floor_houses')
    address = models.ForeignKey(Address, on_delete=models.CASCADE)

    @cached_property
    def url(self) -> str:
        return f'{self.id}'

    @property
    def square(self):
        """Общая площадь."""
        return sum(section.square for section in self.section_set.all())

    @property
    def number_of_floors(self):
        """Этажность."""
        return max(len(section.floor_set.all()) for section in self.section_set.all())

class SectionPlan(models.Model):
    """Типовые секции (подъезды)."""
    class Meta:
        db_table = 'sections_plan'
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=32)
    floor_plan_name = models.CharField(max_length=32)  

class Section(models.Model):
    """Секция (подьезд)."""
    class Meta:
        db_table = 'sections'
    id = models.AutoField(primary_key=True)
    number = models.CharField(max_length=2)
    house = models.ForeignKey(House, on_delete=models.CASCADE)
    section_plan = models.ForeignKey(SectionPlan, on_delete=models.CASCADE)

    @property
    def square(self):
        square = sum(floor.square for floor in self.floor_set.all())
        return square

class FloorPlan(models.Model):
    """План этажа"""
    class Meta:
        db_table = 'floors_plan'
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=32)
    flat_plan_name = models.CharField(max_length=32)

class Floor(models.Model):
    """Этаж."""
    class Meta:
        db_table = 'floors'
    id = models.AutoField(primary_key=True)
    number = models.CharField(max_length=4)
    section = models.ForeignKey(Section, on_delete=models.CASCADE)
    floor_plan = models.ForeignKey(FloorPlan, on_delete=models.CASCADE)

    @property
    def get_number_as_int(self):
        return int(self.number)

    @property
    def square(self):
        square = sum(flat.square for flat in self.flat_set.all())
        return square

class RoomType(models.Model): 
    """Тип комнаты.""" 
    class Meta: 
        db_table = 'room_types' 
    id = models.AutoField(primary_key=True) 
    name = models.CharField(max_length=32, unique=True) 
    living = models.BooleanField() 
    koef_price = models.FloatField(null=True, default=1.0)

class FlatsPlan(models.Model): 
    """Планировка квартиры.""" 
    class Meta: 
        db_table = 'flats_plan'
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=32)
    square = models.FloatField(null=True, default=0.0)
    room_type = models.ForeignKey(RoomType, on_delete=models.CASCADE)  

class Flat(models.Model): 
    """Квартира.""" 
    class Meta: 
        db_table = 'flats' 
    id = models.AutoField(primary_key=True) 
    number = models.CharField(max_length=4) 
    floor = models.ForeignKey(Floor, on_delete=models.CASCADE) 
    flat_plan = models.ForeignKey(FlatsPlan, on_delete=models.CASCADE) 
    status = models.ForeignKey(SaleStatus, on_delete=models.CASCADE)

    @cached_property
    def url(self) -> str:
        return f'{self.id}'

    @property
    def square(self):
        """Общая площадь."""
        return sum(room.square for room in self.room_set.all())

    @property
    def living_rooms(self):
        """Общая площадь."""
        living = 0
        for room in self.room_set.all():
            living += 1 if room.room_type.living else 0
        return living

    @property
    def sale_number(self):
        return (f'M{self.floor.section.house.microdistrict.name[:3].upper()}'
                f'H{int(self.floor.section.house.number):03}'
                f'S{int(self.floor.section.number):03}'
                f'F{int(self.floor.number):03}'
                f'-{int(self.number):03}')

    @property
    def count_rooms(self):
        return len(self.room_set.all())
    

class Room(models.Model):
    """Комната."""
    class Meta:
        db_table = 'rooms'
    id = models.AutoField(primary_key=True)
    square = models.FloatField(null=True, default=0.0)
    flat = models.ForeignKey(Flat, on_delete=models.CASCADE)
    room_type = models.ForeignKey(RoomType, on_delete=models.CASCADE)