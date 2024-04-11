import xml.etree.ElementTree as ET
from json import dump

# Чтение XML из файла bic.txt
tree = ET.parse('bikbase.xml')
# print(dir(tree))
root = tree.getroot()
# print(root)
# <Element 'biks' at 0x0000020E82817970>
# print(dir(root))
biksall = root.findall('bik')
# print(biksall)
# [<Element 'bik' at 0x000001CB60BEF6F0>, <Element 'bik' at 0x000001CB60BEF790>, ...]
bik_data = []
for bik in biksall:
    bik_item = {
        'bik': bik.get('bik'),
        'ks': bik.get('ks'),
        'name': bik.get('name'),
        'namemini': bik.get('namemini'),
        'index': bik.get('index'),
        'city': bik.get('city'),
        'address': bik.get('address'),
        'phone': bik.get('phone'),
        'okato': bik.get('okato'),
        'okpo': bik.get('okpo'),
        'regnum': bik.get('regnum'),
        'srok': bik.get('srok'),
        'dateadd': bik.get('dateadd'),
        'datechange': bik.get('datechange')
    }
    bik_data.append(bik_item)
# print(bik_data)
# [...,{
#     'bik': '245011072', 
#     'ks': '40503810245250000051', 
#     'name': 'ГК "АСВ", АСВ.РФ', 
#     'namemini': 'ГК "АСВ", АСВ.РФ', 
#     'index': '109240', 
#     'city': 'Москва', 
#     'address': 'ул. Высоцкого, д.4', 
#     'phone': '', 'okato': '45', 
#     'okpo': '', 
#     'regnum': '', 
#     'srok': '', 
#     'dateadd': '2015-12-29', 
#     'datechange': ''
# }, ...]

with open('banks.py', 'w', encoding='utf-8') as file:
    dump(bik_data, file, ensure_ascii=False, indent=4)