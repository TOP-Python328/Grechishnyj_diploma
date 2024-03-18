from django.http import HttpResponse
from django.shortcuts import render

p = "<h1>Main</h1>"

# Create your views here.
# def main(request):
#     # author = authors[name]
#     return render(
#         request, 
#         'main.html',
#         {
#             # 'author': author,
#             # 'books': author.book_set.all(),
#         }
#     )

page1 = """
<html>
<head>
    <title>Flats</title>
</head>
<body>
    <h1>Main</h1>
</body>
</html>
"""


def main(request):
    print(request)
    return render(
        request, 
        'index.html', 
        {
            'title': 'Главная страница',
        }
    )



def show(request):
    return HttpResponse(page1)