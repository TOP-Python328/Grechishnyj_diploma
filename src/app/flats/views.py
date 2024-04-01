from django.shortcuts import render, redirect

from app.flats.models import (
    SaleStatus, Microdistrict, House, Flat, Room, Section, Floor, FlatsPlan, 
    FloorPlan, SectionPlan, BuildingPermit, EnergySave, Seismic, HouseType)

from app.flats.forms import AddMicrodistrictForm, AddRoomForm, AddHouseForm, AddBuildingPermitsForm, AddFlatForm

from django.db.models import Count, Avg, Sum


def run_rooms(request):

    dbase=request.user.dbase
    rooms = Room.objects.using(dbase)
    
    if request.method == 'GET':
        add_room_form = AddRoomForm(dbase=dbase)

    elif request.method == 'POST':
        add_room_form = AddRoomForm(dbase=dbase, data=request.POST)
        if add_room_form.is_valid():
            add_room_form.save_to_database()
    
    return render(
        request,
        'flats/rooms.html',
        {
            'title': 'Комнаты',
            'rooms': rooms,
            'add_room_form': add_room_form,
            'scripts': [                 
                'scripts/popup.js', 
                'scripts/form.js',
            ]
        }
    )


def run_microdistricts(request):
    microdistricts = Microdistrict.objects.using(request.user.dbase)
    
    if request.method == 'GET':
        add_microdistrict_form = AddMicrodistrictForm()

    elif request.method == 'POST':
        add_microdistrict_form = AddMicrodistrictForm(data=request.POST)
        
        if add_microdistrict_form.is_valid():
            add_microdistrict_form.save_to_database(request.user.dbase)
        

    return render(
        request,
        'flats/microdistricts.html',
        {
            'title': 'Микрорайоны',
            'microdistricts': microdistricts,
            'add_microdistrict_form': add_microdistrict_form,
            'scripts': [                 
                'scripts/popup.js', 
                'scripts/form.js',
            ]
        }
    )

def run_houses(request):
    dbase=request.user.dbase
    houses = House.objects.using(dbase)
    if request.method == 'GET':
        add_house_form = AddHouseForm(dbase=dbase)
        add_building_permits_form = AddBuildingPermitsForm()


    elif request.method == 'POST':
        add_house_form = AddHouseForm(data=request.POST, dbase=dbase)
        add_building_permits_form = AddBuildingPermitsForm(data=request.POST)
        if add_house_form.is_valid():
            add_house_form.save_to_database()
            return redirect('run_houses', permanent=True)
        if add_building_permits_form.is_valid():
            add_building_permits_form.save_to_database(request.user.dbase)
            return redirect('run_houses', permanent=True)
        

    return render(
        request,
        'flats/houses.html',
        {
            'title': 'Жилые дома',
            'houses': houses,
            'add_house_form': add_house_form,
            'add_building_permits_form': add_building_permits_form,
            'scripts': [                 
                'scripts/popup.js', 
                'scripts/form.js',
            ]
        }
    )

def run_flats(request):
    dbase=request.user.dbase
    flats = Flat.objects.using(dbase)
    
    if request.method == 'GET':
        add_flat_form = AddFlatForm(dbase=dbase)

    elif request.method == 'POST':
        add_flat_form = AddFlatForm(data=request.POST, dbase=dbase)
        
        if add_flat_form.is_valid():
            add_flat_form.save_to_database()
        

    return render(
        request,
        'flats/flats.html',
        {
            'title': 'Квартиры',
            'flats': flats,
            'add_flat_form': add_flat_form,
            'scripts': [                 
                'scripts/popup.js', 
                'scripts/form.js',
            ]
        }
    )






def run_flat_constructor(request):
    database = request.user.dbase
    rooms = Room.objects.using(database).order_by('name')
    flats = FlatsPlan.objects.using(database).values('name').annotate(total=Count('name')).order_by()
    building_permits = BuildingPermit.objects.using(database).order_by('number')
    microdistricts = Microdistrict.objects.using(database).order_by('name')
    energy_saves = EnergySave.objects.using(database).order_by('name')
    seismics = Seismic.objects.using(database).order_by('name')
    house_types = HouseType.objects.using(database).order_by('name')
    flats_plans = FlatsPlan.objects.using(database).values('name').annotate(square_rooms=Sum('square')).annotate(count_rooms=Count('id'))
    floors_plans = FloorPlan.objects.using(database).values('name').annotate(total=Count('name')).order_by()
    sections_plans = SectionPlan.objects.using(database).values('name').annotate(total=Count('name')).order_by()


    if request.method == 'GET':
        ...


    if request.method == 'POST':
        if request.POST['form'] == 'new_flat':
            post_rooms = request.POST.getlist('room')
            post_square = request.POST.getlist('square')
            post_flat_name = request.POST['flat_name']
            for i in range(len(post_rooms)):
                FlatsPlan.objects.using(database).create(
                    name = post_flat_name,
                    square = post_square[i],
                    room = Room.objects.using(database).get(pk=post_rooms[i])
                )

        elif request.POST['form'] == 'new_floor':
            post_floor = request.POST['floor_name']
            post_flats = request.POST.getlist('flat')
            for i in range(len(post_flats)):
                FloorPlan.objects.using(database).create(
                    name=post_floor,
                    flat_plan_name=post_flats[i]
                )

        elif request.POST['form'] == 'new_section':
            post_section = request.POST['section_name']
            post_floors = request.POST.getlist('floor')
            for i in range(len(post_floors)):
                SectionPlan.objects.using(database).create(
                    name=post_section,
                    floor_plan_name=post_floors[i]
                )

        elif request.POST['form'] == 'new_building_permit':
            BuildingPermit.objects.using(database).create(
                    number=request.POST['number'],
                    dt_issue=request.POST['dt_issue'],
                    dt_expiry=request.POST['dt_expiry']
                )

        elif request.POST['form'] == 'new_microdistrict':
            Microdistrict.objects.using(database).create(
                    name=request.POST['name'],
                )


        elif request.POST['form'] == 'new_house':
            flat_number = 1
            house = House.objects.using(database).create(
                    building_permit_id=BuildingPermit.objects.using(database).get(number=request.POST['building_permit']).id,
                    microdistrict_id=Microdistrict.objects.using(database).get(name=request.POST['microdistrict']).id,
                    energy_save_id=EnergySave.objects.using(database).get(name=request.POST['energy_save']).name,
                    seismic_id=Seismic.objects.using(database).get(name=request.POST['seismic']).name,
                    type_id=HouseType.objects.using(database).get(name=request.POST['house_type']).id,
                    number=request.POST['house_number'],
                )
            sections_plans = request.POST.getlist('section')
            for i in range(len(sections_plans)):
                section_plan = SectionPlan.objects.using(database).filter(name=sections_plans[i]).first()
                section = Section.objects.using(database).create(
                    number=str(i+1),
                    house=house,
                    section_plan=section_plan
                )
                floors_plans = FloorPlan.objects.using(database).filter(name=section_plan.floor_plan_name)
                for j in range(len(floors_plans)):
                    floor_plan = FloorPlan.objects.using(database).filter(name=floors_plans[j].name).first()
                    floor = Floor.objects.using(database).create(
                        number = str(j+1),
                        section = section,
                        floor_plan = floor_plan
                    )
                    flats_plans = FlatsPlan.objects.using(database).filter(name=floor_plan.flat_plan_name)
                    for k in range(len(flats_plans)):
                        flat_plan = FlatsPlan.objects.using(database).filter(name=flats_plans[k].name).first()
                        flat = Flat.objects.using(database).create(
                            number = flat_number,
                            status = SaleStatus.objects.using(database).filter(name='free').first(),
                            floor = floor,
                            flat_plan = flat_plan
                        )
                        flat_number += 1
                        # print(flat_plan)

    # section = models.ForeignKey(Section, on_delete=models.CASCADE)
    # floor_plan = models.ForeignKey(FloorPlan, on_delete=models.CASCADE)
                

# 'form': ['new_house'], 
# 'building_permit': ['ru20220-04'], 
# 'microdistrict': ['vesnushki'], 
# 'energy_save': ['A++'], 
# 'seismic': ['C7'], 
# 'house_type': ['кирпичный'], 
# 'house_number': ['241'], 
# 'section': ['17-p', '17-p', '17-p', '17-p']


    # id = models.AutoField(primary_key=True)
    # number = models.CharField(max_length=8)
    # building_permit = models.ForeignKey(BuildingPermit, on_delete=models.CASCADE)
    # microdistrict = models.ForeignKey(Microdistrict, on_delete=models.CASCADE)
    # energy_save = models.ForeignKey(EnergySave, on_delete=models.CASCADE)
    # seismic = models.ForeignKey(Seismic, on_delete=models.CASCADE)
    # type = models.ForeignKey(HouseType, on_delete=models.CASCADE)

            

                    
        return redirect('run_flat_constructor', permanent=True)
        
        

    return render(
        request,
        'flats/flats_plans.html',
        {
            'title': 'Квартирные планы',
            'rooms': rooms,
            'flats': flats,
            'flats_plans': flats_plans,
            'floors_plans': floors_plans,
            'sections_plans': sections_plans,
            'building_permits': building_permits,
            'microdistricts': microdistricts,
            'energy_saves': energy_saves,
            'seismics': seismics,
            'house_types': house_types,
            'scripts': [ 
                'scripts/popup.js', 
                'scripts/form.js',

            ]
        }
    )
