from django.shortcuts import render


from django.http import HttpResponseRedirect, HttpResponseNotFound

from addresses.models import Address, Region, Country, Locality



def get_small_locality():
    return Locality.objects.all()


def main_address(request):
    
    if request.method == 'POST':
        Address.insert(request.POST)

    
    return render(
        request,
        'addresses/addresses.html',
        {
            'title': 'Addresses',
            'addresses': Address.select_all(),
            'regions': Region.objects.order_by('name'),
            'locations': Locality.objects.filter(size='small'),
            'scripts': [
                'scripts/popup.js',
            ]
        }
    )


def delete_address(request, uniq):
    try:
        address = Address.objects.get(id=int(uniq))
        address.delete()
        return HttpResponseRedirect("/addresses")
    except Address.DoesNotExist:
        return HttpResponseNotFound("<h2>Address not found</h2>")


