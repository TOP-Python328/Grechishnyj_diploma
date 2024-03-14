from django.db import models
from functools import cached_property



class Country(models.Model):
    """Страна"""
    class Meta:
        db_table = 'countries'

    full_name = models.CharField(max_length=32, unique=True)
    short_name = models.CharField(max_length=16, null=True)
    int_code = models.CharField(max_length=4)
    

class Locality(models.Model):
    """Тип субъекта (размер субъекта)"""
    class Meta:
        db_table = 'locations'

    name = models.CharField(max_length=32, primary_key=True)
    size = models.CharField(max_length=8)


class Region(models.Model):
    """Регион"""
    class Meta:
        db_table = 'regions'

    name = models.CharField(max_length=64, unique=True)
    locality = models.ForeignKey(Locality, on_delete=models.CASCADE)
    country = models.ForeignKey(Country, on_delete=models.CASCADE)


class Address(models.Model):
    """Адрес"""
    class Meta:
        db_table = 'addresses'

    postal_code = models.CharField(max_length=8, null=True)
    region = models.ForeignKey(Region, on_delete=models.CASCADE)
    district = models.CharField(max_length=32, null=True)
    locality = models.ForeignKey(Locality, on_delete=models.CASCADE)
    title = models.CharField(max_length=32)
    street = models.CharField(max_length=32)
    house = models.CharField(max_length=32, null=True)
    index = models.CharField(max_length=32, null=True)
    flat = models.CharField(max_length=8, null=True)


    @cached_property
    def url(self) -> str:
        return f'{self.id}'


    @classmethod
    def select_all(cls):
        return Address.objects.all()


    @classmethod
    def insert(cls, fields):
        """Добавить адрес в БД"""
        cls(
            postal_code=fields['postal_code'],
            region_id=fields['region_id'],
            district=fields['district'],
            locality_id=fields['locality_id'],
            title=fields['title'],
            street=fields['street'],
            house=fields['house'],
            index=fields['index'],
            flat=fields['flat']
        ).save()


    @classmethod
    def select(cls, key, value) -> 'Self':
        """Получить адрес из БД"""
        return Address.objects.get(key=value)


    # @classmethod
    # def delete(cls, uniq) -> bool:
    #     """Удалить адрес из БД"""
    #     print(uniq)
        # address = cls.objects.get(id=int(uniq))
        # address.delete()

        


        
            
        

