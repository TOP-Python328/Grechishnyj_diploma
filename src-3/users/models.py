from django.db import models
from django.contrib.auth.models import AbstractUser
from utils.mixtures import randomword
from utils.mixtures import copy_db_file
# from utils.mixtures import copy_contract_file

class CustomUser(AbstractUser):
    """Пользователь."""

    dbase = models.CharField(max_length=16, unique=True)

    def save(self, *a, **kwa):
        self.dbase = randomword(16)
        copy_db_file(self.dbase)
        super().save(*a, **kwa)
        # return self




