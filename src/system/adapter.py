from json import load as jload, dump as jdump
from pathlib import Path



class DataBaseAdapter:
    """Адаптер баз данных."""

    config = Path(__file__).resolve().parent.parent / 'storage' / 'general' / 'db.config'
    database = Path(__file__).resolve().parent.parent / 'storage' / 'dbases'
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
        with open(self.config, encoding='utf-8') as filein:
            db_config: dict = jload(filein)    
        return data_base_name in db_config


    @classmethod
    def load_data_bases(self) -> dict[str, dict]:
        """Загрузка баз данных из конфигурационного файла.""" 
        try:
            with open(self.config, encoding='utf-8') as filein:
                db_config: dict = jload(filein)
            return db_config
        except Exception:
            return self.default


    @classmethod
    def add_db_in_config(self, db_name: str) -> None:
        """Запись базы данных в конфигурационный файл."""
        try:
            with open(self.config, 'r+', encoding='utf-8') as fileout:
                db_config: dict = jload(fileout)
                db_config[db_name] = {
                    "ENGINE": "django.db.backends.sqlite3",
                    "NAME": f'{db_name}.sqlite3'
                }
                fileout.seek(0)
                jdump(db_config, fileout, indent = 4)
        except Exception:
            raise


    @classmethod
    def create_data_base(self, name):
        """Создание базы данных для пользователя."""
        sqlite3_file = f'{self.database / name}.sqlite3'
        with open(sqlite3_file, 'w', encoding='utf-8') as newfile:
            newfile.write('')

