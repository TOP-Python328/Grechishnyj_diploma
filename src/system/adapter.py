from json import load, dump
from pathlib import Path



class DataBaseAdapter:
    """Адаптер баз данных."""
# database
    config_file_path = Path(__file__).resolve().parent.parent / 'storage' / 'general' / 'db.config'
    databases_path = Path(__file__).resolve().parent.parent / 'storage' / 'dbases'
    default = { "default": {
            "ENGINE": "django.db.backends.mysql",
            "NAME": "topdip",
            "USER": "root",
            "PASSWORD": "root",
            "HOST": "localhost",
            "PORT": "3306",
            "OPTIONS": { "init_command": "SET sql_mode='STRICT_TRANS_TABLES'" }
        }
    }


    @classmethod
    def check_db_in_config(self, data_base_name: str) -> bool:
        """Проверка наличия базы данных в конфигурационном файле."""
        with open(self.config_file_path, encoding='utf-8') as filein:
            db_config: dict = load(filein)    
        return data_base_name in db_config


    @classmethod
    def load_data_bases(self) -> dict[str, dict]:
        """Загрузка баз данных из конфигурационного файла.""" 
        try:
            with open(self.config_file_path, encoding='utf-8') as filein:
                db_config: dict = load(filein)
            return db_config
        except Exception:
            return self.default


    @classmethod
    def add_db_in_config(self, db_name: str) -> None:
        """Запись базы данных в конфигурационный файл."""
        try:
            with open(self.config_file_path, 'r+', encoding='utf-8') as fileout:
                db_config: dict = load(fileout)
                db_config[db_name] = {
                    "ENGINE": "django.db.backends.sqlite3",
                    "NAME": f'{self.databases_path / db_name}.sqlite3'
                }
                fileout.seek(0)
                dump(db_config, fileout, indent = 4)
        except Exception:
            raise


    @classmethod
    def create_data_base(self, name: str) -> None:
        """Создание базы данных для пользователя."""
        sqlite3_file = f'{self.databases_path / name}.sqlite3'
        with open(sqlite3_file, 'w', encoding='utf-8') as newfile:
            newfile.write('')


    @classmethod
    def update_databases(self, databases: 'DATABASES', new_db_name: str) -> None:
        """Добавление новой базы данныx в переменную DATABASES."""
        databases[new_db_name] = {
            "ENGINE": "django.db.backends.sqlite3",
            "NAME": f'{self.databases_path / new_db_name}.sqlite3',
            'ATOMIC_REQUESTS': False, 
            'AUTOCOMMIT': True, 
            'CONN_MAX_AGE': 0, 
            'CONN_HEALTH_CHECKS': False, 
            'OPTIONS': {}, 
            'TIME_ZONE': None, 
            'USER': '', 
            'PASSWORD': '', 
            'HOST': '', 
            'PORT': '', 
            'TEST': {'CHARSET': None, 'COLLATION': None, 'MIGRATE': True, 'MIRROR': None, 'NAME': None}
        }
        return None
        
