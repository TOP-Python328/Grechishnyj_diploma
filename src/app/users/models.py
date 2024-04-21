from django.db import models
from django.contrib.auth.models import AbstractUser

from sqlite3 import connect
from django.db import connection

class CustomUser(AbstractUser):
    """Пользователь."""

    dbase = models.CharField(max_length=16, unique=True)
    email = models.EmailField(blank=True, max_length=254, unique=True)
    
    def run_base_migrate(self):
        connection = connect(f'storage/dbases/{self.dbase}.sqlite3')
        cursor = connection.cursor()

        with open(f'storage/general/start_migrate.sql', 'r', encoding='utf-8') as file:
            migration_queries = file.read()
            migration_queries = migration_queries.split(';')

        for sql_command in migration_queries:
            cursor.execute(sql_command)

        connection.commit()
        connection.close()







                    



