from pprint import pprint
from json import dump

with open('change.log', 'r', encoding='utf-8') as file:
    data = file.read().split('\n')
    data = [item.split('\t') for item in data]

address = {}

for item in data:
    if len(item) == 5:
        sity, district, _, region, _ = item
        address.setdefault(region, {}).setdefault(district, []).append(sity)

with open('addresses.py', 'w', encoding='utf-8') as file:
    dump(address, file, ensure_ascii=False, indent=4)