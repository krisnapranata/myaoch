from django.core.management.base import BaseCommand
from django.utils import timezone
from core.models import Unit, AppUser, Peralatan, NilaiKesiapan, Verifikasi, Laporan
import random
from datetime import timedelta


class Command(BaseCommand):
    help = "Seed data awal untuk proyek MyAoCH v2 (Unit, AppUser, Peralatan, NilaiKesiapan, Verifikasi, Laporan)"

    def handle(self, *args, **options):
        self.stdout.write(self.style.NOTICE(
            "🌱 Memulai proses seeding MyAoCH v2..."))

        # 1️⃣ Unit
        units = [
            ("Electrical", "ELC"),
            ("Mechanical", "MEC"),
            ("GSE", "GSE"),
            ("AOCC", "AOC"),
            ("Facility Management", "FMG"),
        ]
        unit_objs = []
        for name, code in units:
            unit, _ = Unit.objects.get_or_create(
                nama_unit=name,
                defaults={
                    "kode_unit": code,
                    "lokasi": f"Terminal {random.choice(['1', '2', '3'])}",
                    "is_active": True,
                },
            )
            unit_objs.append(unit)
        self.stdout.write(self.style.SUCCESS(
            f"✅ Unit: {len(unit_objs)} created"))

        # 2️⃣ AppUser
        users = [
            ("operator1", "Operator", "Operator Electrical", unit_objs[0]),
            ("spv1", "SPV", "Supervisor Electrical", unit_objs[0]),
            ("aoch1", "AOCH", "AOCH Terminal", unit_objs[3]),
            ("gm1", "GM", "General Manager Bandara", None),
        ]
        user_objs = []
        for username, role, name, unit in users:
            user, _ = AppUser.objects.get_or_create(
                username=username,
                defaults={
                    "password": "pbkdf2_sha256$216000$dummy$hashdummy123",  # dummy hash
                    "nama_lengkap": name,
                    "role": role,
                    "unit": unit,
                    "is_active": True,
                },
            )
            user_objs.append(user)
        self.stdout.write(self.style.SUCCESS(
            f"✅ AppUser: {len(user_objs)} created"))

        # 3️⃣ Peralatan
        equipment_data = [
            ("Genset Utama", "GEN001", "Power",
             "Caterpillar", "X200", 2018, unit_objs[0]),
            ("Runway Light", "RL001", "Lighting",
             "Philips", "Airfield-XL", 2019, unit_objs[0]),
            ("Conveyor Belt", "CVB001", "Baggage",
             "Siemens", "MTR100", 2020, unit_objs[1]),
            ("Pushback Tractor", "PBT001", "Ground Support",
             "Toyota", "GSP-12", 2017, unit_objs[2]),
        ]
        equipment_objs = []
        for nama, kode, kategori, merk, model, tahun, unit in equipment_data:
            alat, _ = Peralatan.objects.get_or_create(
                kode_peralatan=kode,
                defaults={
                    "nama_peralatan": nama,
                    "kategori": kategori,
                    "merk": merk,
                    "model": model,
                    "tahun_pengadaan": tahun,
                    "unit": unit,
                    "status_operasional": "Normal",
                },
            )
            equipment_objs.append(alat)
        self.stdout.write(self.style.SUCCESS(
            f"✅ Peralatan: {len(equipment_objs)} created"))

        # 4️⃣ Nilai Kesiapan (dengan kategori otomatis)
        for alat in equipment_objs:
            for i in range(5):
                nilai = random.uniform(30, 100)
                tanggal = timezone.now().date() - timedelta(days=i)
                NilaiKesiapan.objects.create(
                    peralatan=alat,
                    tanggal=tanggal,
                    nilai=nilai,
                    keterangan=f"Input otomatis tanggal {tanggal}",
                    status=random.choice(
                        ["Draft", "Diverifikasi SPV", "Diverifikasi AOCH", "Final"]),
                    user_input=random.choice(user_objs),
                )
        self.stdout.write(self.style.SUCCESS(
            "✅ NilaiKesiapan: sample data created"))

        # 5️⃣ Verifikasi contoh
        kesiapan_terbaru = NilaiKesiapan.objects.latest("id")
        Verifikasi.objects.create(
            kesiapan=kesiapan_terbaru,
            verifikasi_level="AOCH",
            status_verifikasi="Approved",
            catatan="Sudah diverifikasi otomatis (seeding)",
            verifikator=user_objs[2],
        )
        self.stdout.write(self.style.SUCCESS("✅ Verifikasi: 1 record created"))

        # 6️⃣ Laporan dummy
        Laporan.objects.create(
            periode="Harian",
            tanggal_awal=timezone.now().date() - timedelta(days=7),
            tanggal_akhir=timezone.now().date(),
            unit=unit_objs[0],
            rata_kesiapan=87.3,
            distribusi_kategori={
                "Normal/Serviceable": 4,
                "Normal/Unserviceable": 1,
                "Not Normal/Serviceable": 0,
                "Not Normal/Unserviceable": 0,
            },
            dibuat_oleh=user_objs[1],
        )
        self.stdout.write(self.style.SUCCESS("✅ Laporan: 1 record created"))

        self.stdout.write(self.style.SUCCESS(
            "🌳 SEEDING SELESAI — MyAoCH v2 SIAP DIGUNAKAN"))
