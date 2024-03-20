from django.db import models
from django.contrib.auth.models import AbstractUser
from django.db import connection
from system.utils import randomword
from system.utils import copy_db_file
from system.adapter import DataBaseAdapter

import sqlite3

from django.db import IntegrityError, transaction

from core.settings import DATABASES

# from utils.mixtures import copy_contract_file

class CustomUser(AbstractUser):
    """Пользователь."""

    dbase = models.CharField(max_length=16, unique=True)

    def save(self, *a, **kwa):
        self.dbase = randomword(16)
        copy_db_file(self.dbase)
        DataBaseAdapter.write_base_sqlite('core/db.config', self.dbase, self.username)
        super().save(*a, **kwa)


    def create_db(self):
        with open('db.sql', 'r') as file:
            sql_content = file.readlines()
    
        sql_content[0] = f'CREATE DATABASE {self.dbase} DEFAULT CHARACTER SET utf8mb4;\n'
        sql_content[1] = f'USE {self.dbase};\n'
        
        with open(f'data/{self.dbase}.sql', 'w') as file:
            file.writelines(sql_content)



    def migrate_from_sqlite(self):

        conn = sqlite3.connect(f'data/users_databases/{self.dbase}.sqlite3')
        cursor = conn.cursor()

        cursor.execute('''
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY,
                name TEXT NOT NULL,
                age INTEGER
            )
        ''')

        # Выполнение других операций с базой данных...

        # Закрытие соединения с базой данных
        conn.close()
        # with connection.cursor() as cursor:
        #     with open(f'data/users_databases/{self.dbase}.sqlite3', 'r') as file:
        #         cursor.execute(file.read())

    def update_databases(self):
        DATABASES[f"{self.dbase}"] = {
                "ENGINE": "django.db.backends.mysql",
                "NAME": f"{self.dbase}",
                "USER": "root",
                "PASSWORD": "root",
                "HOST": "localhost",
                "PORT": "3306",
                "OPTIONS": {
                    "init_command": "SET sql_mode='STRICT_TRANS_TABLES'"
                }
            }
        # print(DATABASES)

    def update_databases_sqlite(self):
        DATABASES[f"{self.dbase}"] = {
            "ENGINE": "django.db.backends.sqlite3",
            "NAME": f'"data/users_databases/{self.dbase}.sqlite3"'
        }
        print(DATABASES)



                    



