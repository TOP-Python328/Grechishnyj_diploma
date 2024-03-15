from random import choice
from string import ascii_lowercase


def randomword(length):
    """Генерация строки"""
    return ''.join(choice(ascii_lowercase) for i in range(length))