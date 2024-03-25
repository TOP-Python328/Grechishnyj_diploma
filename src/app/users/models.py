from django.db import models
from django.contrib.auth.models import AbstractUser

from sqlite3 import connect
from system.utils import randomword

from pathlib import Path

from django.db import connection




class CustomUser(AbstractUser):
    """Пользователь."""

    basemigrate = Path(__file__).resolve().parent.parent.parent / 'storage' / 'general' / 'start_migrate.sql'
    dbase = models.CharField(max_length=16, unique=True)
    

    # def save(self, *a, **kwa):
    #     self.dbase = randomword(16)
    #     print(f'save_________{self.dbase}')
        
    #     super().save(*a, **kwa)

    
    def run_base_migrate(self):
        # print(self.dbase)
        # print(f'save_________{self.dbase}')
        connection = connect(f'storage/dbases/{self.dbase}.sqlite3')
        cursor = connection.cursor()
        

        with open(f'storage/general/start_migrate.sql', 'r') as file:
            migration_queries = file.read()
            migration_queries = migration_queries.split(';')


        for sql_command in migration_queries:
            cursor.execute(sql_command)
    
        connection.commit()
        connection.close()







                    



