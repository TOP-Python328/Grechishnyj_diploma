from json import load as jload, dump as jdump




class Adapter:

    @classmethod
    def load_bases(cls, db_config_path) -> dict[str, dict]:
        # try:
        with open(db_config_path, encoding='utf-8') as filein:
            dbconfig: dict = jload(filein)
        return dbconfig

    @classmethod
    def write_base(cls, db_config_path, db_name, user_name) -> None:
        with open(db_config_path, 'r+', encoding='utf-8') as fileout:
            dbconfig: dict = jload(fileout)
            dbconfig[db_name] = {
                "ENGINE": "django.db.backends.mysql",
                "NAME": f"{db_name}",
                "USER": f"{user_name}",
                "PASSWORD": f"{user_name}",
                "HOST": "localhost",
                "PORT": "3306",
                "OPTIONS": {
                    "init_command": "SET sql_mode='STRICT_TRANS_TABLES'"
                }
            }
            fileout.seek(0)
            jdump(dbconfig, fileout, indent = 4)

    @classmethod
    def write_base_sqlite(cls, db_config_path, db_name, user_name) -> None:
        with open(db_config_path, 'r+', encoding='utf-8') as fileout:
            dbconfig: dict = jload(fileout)
            dbconfig[db_name] = {
                "ENGINE": "django.db.backends.sqlite3",
                "NAME": f'"data/users_databases/{db_name}.sqlite3"'
            }
            fileout.seek(0)
            jdump(dbconfig, fileout, indent = 4)


    @classmethod
    def create_sql(cls):
        with open(db_config_path, encoding='utf-8') as filein:
            dbconfig: dict = jload(filein)













