# Generated by Django 5.0.2 on 2024-03-07 10:16

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='BuildingPermit',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('number', models.CharField(max_length=32, unique=True)),
                ('dt_issue', models.DateField()),
                ('dt_expiry', models.DateField()),
            ],
            options={
                'db_table': 'building_permits',
            },
        ),
        migrations.CreateModel(
            name='Construction',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=32, unique=True)),
            ],
            options={
                'db_table': 'constructions',
            },
        ),
        migrations.CreateModel(
            name='EnergySave',
            fields=[
                ('name', models.CharField(max_length=4, primary_key=True, serialize=False)),
            ],
            options={
                'db_table': 'energy_saves',
            },
        ),
        migrations.CreateModel(
            name='Floor',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('number', models.CharField(max_length=2)),
            ],
            options={
                'db_table': 'floors',
            },
        ),
        migrations.CreateModel(
            name='HouseType',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=128)),
            ],
            options={
                'db_table': 'house_types',
            },
        ),
        migrations.CreateModel(
            name='Room',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=32, unique=True)),
                ('living', models.BooleanField(default=False)),
                ('koef_price', models.FloatField()),
            ],
            options={
                'db_table': 'rooms',
            },
        ),
        migrations.CreateModel(
            name='SaleStatus',
            fields=[
                ('name', models.CharField(max_length=16, primary_key=True, serialize=False)),
            ],
            options={
                'db_table': 'sale_statuses',
            },
        ),
        migrations.CreateModel(
            name='SectionType',
            fields=[
                ('name', models.CharField(max_length=32, primary_key=True, serialize=False)),
            ],
            options={
                'db_table': 'section_types',
            },
        ),
        migrations.CreateModel(
            name='Seismic',
            fields=[
                ('name', models.CharField(max_length=4, primary_key=True, serialize=False)),
            ],
            options={
                'db_table': 'seismics',
            },
        ),
        migrations.CreateModel(
            name='Flat',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('number', models.CharField(max_length=4)),
                ('floor', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='flats.floor')),
                ('status', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, to='flats.salestatus')),
            ],
            options={
                'db_table': 'flats',
            },
        ),
        migrations.CreateModel(
            name='House',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('number', models.CharField(max_length=8)),
                ('building_permit', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='flats.buildingpermit')),
                ('construction', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='flats.construction')),
                ('energy_save', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='flats.energysave')),
                ('type', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='flats.housetype')),
                ('seismic', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='flats.seismic')),
            ],
            options={
                'db_table': 'houses',
            },
        ),
        migrations.CreateModel(
            name='Plan',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('square', models.FloatField()),
                ('flat', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='flats.flat')),
                ('room', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='flats.room')),
            ],
        ),
        migrations.CreateModel(
            name='Section',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('number', models.CharField(max_length=2)),
                ('house', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='flats.house')),
                ('name', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, to='flats.sectiontype')),
            ],
            options={
                'db_table': 'sections',
            },
        ),
        migrations.AddField(
            model_name='floor',
            name='section',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='flats.section'),
        ),
    ]