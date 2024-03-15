from django.db import models
from django.contrib.auth.models import AbstractUser
from utils.mixtures import randomword

class CustomUser(AbstractUser):
    dbase = models.CharField(max_length=16, default=lambda: randomword(16), unique=True)

