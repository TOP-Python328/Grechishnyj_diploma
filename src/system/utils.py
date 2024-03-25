from random import choice
from string import ascii_lowercase
from shutil import copyfile


def randomword(length):
    """Генерация строки"""
    return ''.join(choice(ascii_lowercase) for i in range(length))
    


# def copy_db_file(filename):
#     """Копировние файла базы данных."""
#     copyfile('db.sqlite3', f'data/users_databases/{filename}.sqlite3')


# def copy_contract_file(filename):
#     """Копировние файла шаблона контракта."""
#     copyfile('contract_sale_flat.txt', f'data/users_documents/contracts_templates/{filename}.txt')