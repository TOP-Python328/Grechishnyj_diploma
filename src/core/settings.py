from pathlib import Path
from sys import path 
from system.adapter import DataBaseAdapter


# BASE_DIR  - каталог проекта
# STR_PATH  - путь к файловому хранилищу
# DB_DIR    - путь к каталогу конфиг-файлов
# DB_CONFIG - имя конфиг-файл баз данных 

BASE_DIR  = Path(__file__).resolve().parent.parent


# print(BASE_DIR)
# print(STR_PATH)
# print(DB_DIR)
# print(DB_CONFIG)
# C:\Users\User\Desktop\diploma\src
# C:\Users\User\Desktop\diploma\src\storage
# C:\Users\User\Desktop\diploma\src\storage\general
# C:\Users\User\Desktop\diploma\src\storage\general\db.config

# DATABASE_ROUTERS = ["system.router.Router"]

# ATOMIC_REQUESTS = True

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/5.0/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'django-insecure-sgq(fgl#4-7%u3x*n8_6)713lt=1uwp28!x5&_iz((x*lchk^e'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = []


# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    'app.index',
    'app.users',
    'app.flats',
    'app.sales',
    'app.agents',
    'app.assist',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'core.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [ BASE_DIR / 'templates', ],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'core.wsgi.application'

# Database
# https://docs.djangoproject.com/en/5.0/ref/settings/#databases

# DATABASES = {
#     'default': { 
#         'ENGINE': 'django.db.backends.mysql', 
#         'NAME': 'topdip', 
#         'USER': 'root', 
#         'PASSWORD': 'root', 
#         'HOST': 'localhost', 
#         'PORT': '3306', 
#         'OPTIONS': { 'init_command': "SET sql_mode='STRICT_TRANS_TABLES'" } 
#     },
# }
DATABASES = DataBaseAdapter.load_data_bases()

# print(DATABASES)

# Password validation
# https://docs.djangoproject.com/en/5.0/ref/settings/#auth-password-validators
AUTH_USER_MODEL = 'users.CustomUser'

AUTH_PASSWORD_VALIDATORS = [
    # {'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',},
    # {'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',},
    # {'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',},
    # {'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',},
]


# Internationalization
# https://docs.djangoproject.com/en/5.0/topics/i18n/

LANGUAGE_CODE = 'ru-ru'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/5.0/howto/static-files/

STATIC_URL = '/addons/'

STATICFILES_DIRS = [ BASE_DIR / 'addons' ]

# Default primary key field type
# https://docs.djangoproject.com/en/5.0/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.AutoField'
