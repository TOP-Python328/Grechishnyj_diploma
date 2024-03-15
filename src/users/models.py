from django.db import models
from django.contrib.auth.models import AbstractUser
from utils.mixtures import randomword

class CustomUser(AbstractUser):
    """Пользователь."""

    dbase = models.CharField(max_length=16, unique=True)

    def save(self, *a, **kwa):
        self.dbase = randomword(16)
        # self.dbase = randomword(16) + self.username
        super().save(*a, **kwa)

