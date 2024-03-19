from users.models import CustomUser

class Router:

    def db_for_read(self, model, path=None, **hints):
        if isinstance(model, CustomUser) and path:           
            return path
        return None
       

    def db_for_write(self, model, path=None, **hints):
        if isinstance(model, CustomUser) and path:           
            return path
        return None


    def allow_relation(self, obj1, obj2, **hints):
        ...


    def allow_migrate(self, db, app_label, model_name=None, **hints):
        ...
