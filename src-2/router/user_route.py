
# from ..users.models import CustomUser

# class DatabaseRouter:
#     def db_for_read(self, model, **hints):
#         # Определите, какие модели должны читать данные из другой базы данных
#         if model._meta.app_label == 'your_app_label':
#             return 'other_database'
#         return None

class UserRouter:
    def db_for_read(self, CustomUser, **hints):
        ...
        # return f"{CustomUser.dbase}"

    def db_for_write(self, CustomUser, **hints):
        ...
        # """
        # Writes always go to primary.
        # """
        # return "primary"

    def allow_relation(self, obj1, obj2, **hints):
        ...
        # """
        # Relations between objects are allowed if both objects are
        # in the primary/replica pool.
        # """
        # db_set = {"primary", "replica1", "replica2"}
        # if obj1._state.db in db_set and obj2._state.db in db_set:
        #     return True
        # return None

    def allow_migrate(self, db, app_label, model_name=None, **hints):
        ...
        # """
        # All non-auth models end up in this pool.
        # """
        # return True


