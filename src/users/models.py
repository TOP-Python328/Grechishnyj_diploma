from django.db import models
from django.contrib.auth.models import AbstractUser

class CustomUser(AbstractUser):
    dbase = models.CharField(max_length=256, unique=True)