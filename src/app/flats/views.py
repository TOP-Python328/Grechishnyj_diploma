from django.shortcuts import render, redirect

from app.flats.models import ( 
    SaleStatus, Microdistrict, House, Flat, RoomType, Section, Floor, FlatsPlan, FloorPlan, SectionPlan, 
    BuildingPermit, EnergySave, Seismic, HouseType, Room)

from django.db.models import Count, Avg, Sum



def run_microdistricts(request): 
    microdistricts = Microdistrict.objects.using(request.user.dbase)
    return render(
        request,
        'flats/microdistricts.html',
        {
            'title': 'Микрорайоны',
            'microdistricts': microdistricts,
            'scripts': [                 
                'scripts/popup.js', 
                'scripts/form.js',
            ]
        }
    )

def run_houses(request): 
    dbase=request.user.dbase 
    houses = House.objects.using(dbase) 
    return render(
        request,
        'flats/houses.html',
        {
            'title': 'Жилые дома',
            'houses': houses,
            'scripts': [                 
                'scripts/popup.js', 
                'scripts/form.js',
            ]
        }
    )

def run_flats(request): 
    """Табличное предстваление квартир."""
    if request.method == 'GET':
        flats = Flat.objects.using(request.user.dbase)
    return render(
        request,
        'flats/flats.html',
        {
            'title': 'Квартиры',
            'flats': flats,
            'scripts': [ 'scripts/popup.js', 'scripts/form.js', ]
        }
    )

def run_flat_constructor(request):
    """Конструктор недвижимости.""" 
    database = request.user.dbase 
    room_types = RoomType.objects.using(database).order_by('name') 
    flats = FlatsPlan.objects.using(database).values('name').annotate(total=Count('name')).order_by() 
    building_permits = BuildingPermit.objects.using(database).order_by('number') 
    microdistricts = Microdistrict.objects.using(database).order_by('name') 
    energy_saves = EnergySave.objects.using(database).order_by('name') 
    seismics = Seismic.objects.using(database).order_by('name') 
    house_types = HouseType.objects.using(database).order_by('name') 
    flats_plans = FlatsPlan.objects.using(database).values('name').annotate(square_rooms=Sum('square')).annotate(count_rooms=Count('id')) 
    floors_plans = FloorPlan.objects.using(database).values('name').annotate(total=Count('name')).order_by() 
    sections_plans = SectionPlan.objects.using(database).values('name').annotate(total=Count('name')).order_by()

    if request.method == 'POST':
        if request.POST['form'] == 'new_flat':
            post_rooms = request.POST.getlist('room')
            post_square = request.POST.getlist('square')
            post_flat_name = request.POST['flat_name']
            for i in range(len(post_rooms)):
                FlatsPlan.objects.using(database).create(
                    name = post_flat_name,
                    square = post_square[i],
                    room_type = RoomType.objects.using(database).get(pk=post_rooms[i])
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
            for i in range(1, len(sections_plans) + 1):
                section_plan = SectionPlan.objects.using(database).filter(name=sections_plans[i-1]).first()
                # print(f'\tsection.floor_plan_name № {sections_plans[i-1]}')
                section = Section(
                    number=str(i),
                    house=house,
                    section_plan=section_plan
                )
                section.save(using=database)
                floor_plans = SectionPlan.objects.using(database).filter(name=sections_plans[i-1])
                
                for j in range(1, len(floor_plans) + 1):
                    floor_plan = floor_plans[j-1].floor_plan_name
                    # print(f'\t\tfloor № {j} {floor_plan}')
                    floor = Floor(
                        number = str(j),
                        section = section,
                        floor_plan = FloorPlan.objects.using(database).filter(name=floor_plan).first()
                    )
                    floor.save(using=database)
                    flats_plans = FloorPlan.objects.using(database).filter(name=floor_plan)
                    print(f'{flats_plans=}')
                    for k in range(1, len(flats_plans) + 1):
                        flat_plan = flats_plans[k-1].flat_plan_name
                        # print(f'\t\t\tflats_plans № {flats_plans[k-1].flat_plan_name}')
                        flat = Flat(
                            number = flat_number,
                            status = SaleStatus.objects.using(database).filter(name='free').first(),
                            floor = floor,
                            flat_plan = FlatsPlan.objects.using(database).filter(name=flat_plan).first()
                        )
                        flat.save(using=database)
                        flat_number += 1
                        room_types = FlatsPlan.objects.using(database).filter(name=flat_plan)
                        for r in range(1, len(room_types) + 1):
                            room_type = room_types[r-1]
                            # print(f'\t\t\t\troom_type № {room_type.square, room_type.room_type_id}')
                            room = Room(
                                square = room_type.square,
                                flat = flat,
                                room_type = RoomType.objects.using(database).filter(id=room_type.room_type_id).first()
                            )
                            room.save(using=database)
        return redirect('run_flat_constructor', permanent=True)

    return render(
        request,
        'flats/constructor.html',
        {
            'title': 'Квартирные планы',
            'room_types': room_types,
            'flats': flats,
            'flats_plans': flats_plans,
            'floors_plans': floors_plans,
            'sections_plans': sections_plans,
            'building_permits': building_permits,
            'microdistricts': microdistricts,
            'energy_saves': energy_saves,
            'seismics': seismics,
            'house_types': house_types,
            'scripts': [ 'scripts/popup.js', 'scripts/form.js', ]
        }
    )
