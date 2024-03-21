from django.db import models
from django.contrib.auth.models import AbstractUser

from sqlite3 import connect
from system.utils import randomword
from system.utils import copy_db_file


from django.db import connection

from django.db import IntegrityError, transaction

from core.settings import DATABASES

# from utils.mixtures import copy_contract_file

class CustomUser(AbstractUser):
    """Пользователь."""

    dbase = models.CharField(max_length=16, unique=True)

    def save(self, *a, **kwa):
        self.dbase = randomword(16)
        # copy_db_file(self.dbase)
        # DataBaseAdapter.add_db_in_config('core/db.config', self.dbase, self.username)
        super().save(*a, **kwa)



    def migrate_from_sqlite(self):
        conn = connect(f'storage/dbases/{self.dbase}.sqlite3')
        cursor = conn.cursor()

        cursor.execute('''
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY,
                name TEXT NOT NULL,
                age INTEGER
            )
        ''')
        conn.close()
        # with connection.cursor() as cursor:
        #     with open(f'data/users_databases/{self.dbase}.sqlite3', 'r') as file:
        #         cursor.execute(file.read())





                    



