from json import load as jload, dump as jdump
from pathlib import Path, WindowsPath


class DataBaseAdapter:
    """Адаптер баз данных."""



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
    def check_db_in_config(self, config_file: str, data_base_name: str) -> bool:
        """Проверка наличия базы данных в конфигурационном файле."""
        with open(config_file, encoding='utf-8') as filein:
            db_config: dict = jload(filein)    
        return data_base_name in db_config


    @classmethod
    def load_data_bases(self, config_file) -> dict[str, dict]:
        """Загрузка баз данных из конфигурационного файла.""" 
        try:
            with open(config_file, encoding='utf-8') as filein:
                db_config: dict = jload(filein)
            return db_config
        except Exception:
            return self.default


    @classmethod
    def add_db_in_config(self, config_file: WindowsPath, db_name: str) -> None:
        """Запись базы данных в конфигурационный файл."""
        try:
            with open(config_file, 'r+', encoding='utf-8') as fileout:
                db_config: dict = jload(fileout)
                db_config[db_name] = {
                    "ENGINE": "django.db.backends.sqlite3",
                    "NAME": config_file / f'{db_name}.sqlite3'
                }
                fileout.seek(0)
                jdump(db_config, fileout, indent = 4)
        except Exception:
            raise


    @classmethod
    def create_sql(cls):
        with open(db_config_path, encoding='utf-8') as filein:
            dbconfig: dict = jload(filein)













