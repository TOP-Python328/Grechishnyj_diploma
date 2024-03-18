# Generated by Django 5.0.2 on 2024-03-07 10:16

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('bisiness', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Client',
            fields=[
                ('unic', models.CharField(max_length=16, primary_key=True, serialize=False, unique=True)),
            ],
            options={
                'db_table': 'clients',
            },
        ),
        migrations.CreateModel(
            name='Bank',
            fields=[
                ('bik', models.CharField(max_length=16)),
                ('department', models.CharField(max_length=128)),
                ('pay_account', models.CharField(max_length=32, primary_key=True, serialize=False, unique=True)),
                ('cor_account', models.CharField(max_length=32)),
                ('bisiness_card', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='bisiness.bisinesscard')),
                ('client', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='clients.client')),
            ],
            options={
                'db_table': 'banks',
            },
        ),
    ]