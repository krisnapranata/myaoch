from datetime import timedelta, datetime, timezone as dt_timezone
from django.utils import timezone
from django.http import JsonResponse
from django.shortcuts import render
from django.db.models import Avg, Count, F, Max
from django.db.models.functions import TruncDate, Trunc
from core.models import NilaiKesiapan, Peralatan, KonsumsiEnergi

import numpy as np
from sklearn.linear_model import LinearRegression  # 🔹 Tambahan

import json


def dashboard_view(request):
    # today = timezone.now().date()
    today = timezone.localtime(timezone.now()).date()
    start_date = today - timedelta(days=6)
    start_dt = timezone.make_aware(
        datetime.combine(start_date, datetime.min.time()))

    qs = (
        NilaiKesiapan.objects
        .filter(created_at__gte=timezone.make_aware(datetime.combine(start_date, datetime.min.time())))
        .annotate(tgl_agg=TruncDate("created_at"))
        .values("tgl_agg")
        .annotate(avg_nilai=Avg("nilai"))
        .order_by("tgl_agg")
    )
    qs_dict = {d["tgl_agg"]: float(d["avg_nilai"]) for d in qs}
    tren_data = [
        {"tgl_agg": (start_date + timedelta(days=i)).isoformat(),
         "avg_nilai": qs_dict.get(start_date + timedelta(days=i), 0.0)}
        for i in range(7)
    ]
    # print(today)

    # print(today)
    # qs = (
    #     NilaiKesiapan.objects
    #     .filter(created_at__gte=timezone.make_aware(datetime.combine(start_date, datetime.min.time())))
    #     .annotate(tgl_agg=TruncDate("created_at"))
    #     .values("tgl_agg")
    #     .annotate(avg_nilai=Avg("nilai"))
    #     .order_by("tgl_agg")
    # )

    # # qs_dict = {d["tgl_agg"]: float(d["avg_nilai"]) for d in qs}
    # qs_dict = {d["tgl_agg"].isoformat(): float(d["avg_nilai"]) for d in qs}
    # Hitung rentang waktu 7 hari terakhir secara timezone-aware
    tz = timezone.get_current_timezone()
    today_local = timezone.localdate()
    start_dateqs = today_local - timedelta(days=6)

    # Buat datetime aware untuk awal (start) dan akhir (end) range
    start_dtqs = timezone.make_aware(
        datetime.combine(start_dateqs, datetime.min.time()), tz)
    end_dtqs = timezone.make_aware(datetime.combine(
        today_local, datetime.max.time()), tz)

    # qs = (
    #     NilaiKesiapan.objects
    #     .filter(created_at__range=(start_dtqs, end_dtqs))
    #     # penting: konversi timezone!
    #     .annotate(tgl_agg=Trunc("created_at", "day", tzinfo=tz))
    #     .values("tgl_agg")
    #     .annotate(avg_nilai=Avg("nilai"))
    #     .order_by("tgl_agg")
    # )

    # # Buat dictionary { '2025-11-01': 82.5, ... } aman dari NoneType
    # qs_dict = {
    #     d["tgl_agg"].isoformat(): float(d["avg_nilai"])
    #     for d in qs if d["tgl_agg"] is not None
    # }

    # # Siapkan 7 titik data tren (kalau hari tanpa data → 0.0)
    # tren_data = [
    #     {
    #         "tgl_agg": (start_dateqs + timedelta(days=i)).isoformat(),
    #         "avg_nilai": qs_dict.get((start_dateqs + timedelta(days=i)).isoformat(), 0.0),
    #     }
    #     for i in range(7)
    # ]

    # === Statistik Unit Hari Ini (Timezone-safe) ===
    today_local = timezone.localdate()
    today_start = timezone.make_aware(
        datetime.combine(today_local, datetime.min.time()))
    today_end = timezone.make_aware(
        datetime.combine(today_local, datetime.max.time()))

    # === Statistik Unit Hari Ini ===
    # today = timezone.now().date()
    # unit_stats = (
    #     NilaiKesiapan.objects
    #     .filter(created_at__date=today)
    #     .values(nama_unit=F("peralatan__unit__nama_unit"))
    #     .annotate(rata_nilai=Avg("nilai"))
    #     .order_by("nama_unit")
    # )
    unit_stats = (
        NilaiKesiapan.objects
        .filter(created_at__range=(today_start, today_end))
        .values(nama_unit=F("peralatan__unit__nama_unit"))
        .annotate(rata_nilai=Avg("nilai"))
        .order_by("nama_unit")
    )

    kategori_counts = (
        NilaiKesiapan.objects
        .values("kategori_kesiapan")
        .annotate(jumlah=Count("id"))
    )

    for item in unit_stats:
        item["rata_nilai"] = float(item["rata_nilai"])
    for item in kategori_counts:
        item["jumlah"] = int(item["jumlah"])

    # ✅ Tambahan kecil agar chart perbandingan muncul
    latest_ids = (
        NilaiKesiapan.objects
        .values("peralatan_id")
        .annotate(latest_id=Max("id"))
        .values_list("latest_id", flat=True)
    )

    latest_unit_stats = list(
        NilaiKesiapan.objects
        .filter(id__in=latest_ids)
        .values(nama_unit=F("peralatan__unit__nama_unit"))
        .annotate(rata_terkini=Avg("nilai"))
        .order_by("nama_unit")
    )

    unit_comparison = []
    unit_names = {u["nama_unit"] for u in unit_stats} | {
        u["nama_unit"] for u in latest_unit_stats}
    for name in unit_names:
        overall_val = next((u["rata_nilai"]
                           for u in unit_stats if u["nama_unit"] == name), 0)
        latest_val = next((u["rata_terkini"]
                          for u in latest_unit_stats if u["nama_unit"] == name), 0)
        unit_comparison.append({
            "nama_unit": name,
            "rata_keseluruhan": overall_val,
            "rata_terkini": latest_val,
        })

    # === 7️⃣ Prediksi Risiko Operasional (Simulasi lama tetap dipertahankan) ===
    start_date = timezone.now().date() - timedelta(days=6)
    readiness_qs = (
        NilaiKesiapan.objects
        .filter(created_at__gte=timezone.make_aware(datetime.combine(start_date, datetime.min.time())))
        .values(nama_unit=F("peralatan__unit__nama_unit"))
        .annotate(avg_readiness=Avg("nilai"))
    )

    forecast_risk = []
    np.random.seed(42)
    for r in readiness_qs:
        nama_unit = r["nama_unit"]
        avg_ready = float(r["avg_readiness"])
        for jam in range(0, 25):
            noise = np.random.uniform(-5, 5)
            pred_risk = max(0, min(100, (100 - avg_ready) + noise))
            forecast_risk.append({
                "nama_unit": nama_unit,
                "jam_ke": jam,
                "prediksi_risiko": round(pred_risk, 2),
            })

    # # === 🔹 Model Baru: Prediksi Real dengan Regresi Linear ===
    # forecast_risk_real = []
    # units = (
    #     NilaiKesiapan.objects
    #     .values_list("peralatan__unit__nama_unit", flat=True)
    #     .distinct()
    # )

    # for unit_name in units:
    #     data_points = (
    #         NilaiKesiapan.objects
    #         .filter(peralatan__unit__nama_unit=unit_name, created_at__date__gte=start_date)
    #         .annotate(tgl_agg=TruncDate("created_at"))
    #         .values("tgl_agg")
    #         .annotate(avg_readiness=Avg("nilai"))
    #         .order_by("tgl_agg")
    #     )
    #     y = np.array([float(d["avg_readiness"]) for d in data_points])
    #     if len(y) < 2:
    #         continue
    #     X = np.arange(len(y)).reshape(-1, 1)
    #     model = LinearRegression()
    #     model.fit(X, y)

    #     # Prediksi readiness hari ke depan
    #     future_X = np.arange(len(y), len(y) + 1).reshape(-1, 1)
    #     pred_next = model.predict(future_X)[0]
    #     base_risk = max(0, min(100, 100 - pred_next))

    #     # Simulasi per jam ±3% dari prediksi dasar
    #     for jam in range(25):
    #         pred_risk = max(0, min(100, base_risk + np.random.uniform(-3, 3)))
    #         forecast_risk_real.append({
    #             "nama_unit": unit_name,
    #             "jam_ke": jam,
    #             "prediksi_risiko": round(pred_risk, 2),
    #         })

    # === 🔹 Model Baru: Prediksi Real dengan Regresi Linear ===
    # === 🔹 Model Baru: Prediksi Real dengan Regresi Linear (Timezone-aware) ===
    forecast_risk_real = []
    units = (
        NilaiKesiapan.objects
        .values_list("peralatan__unit__nama_unit", flat=True)
        .distinct()
    )

    for unit_name in units:
        # timezone-aware filter untuk 7 hari terakhir
        data_points = (
            NilaiKesiapan.objects
            .filter(peralatan__unit__nama_unit=unit_name, created_at__gte=start_dt)
            .annotate(tgl_agg=TruncDate("created_at", tzinfo=timezone.get_current_timezone()))
            .values("tgl_agg")
            .annotate(avg_readiness=Avg("nilai"))
            .order_by("tgl_agg")
        )

        y_list = [float(d["avg_readiness"]) for d in data_points]
        y = np.array(y_list)

        if len(y) == 0:
            continue  # tidak ada data
        elif len(y) == 1:
            base_risk = max(0, min(100, 100 - y[0]))  # fallback satu hari
        else:
            X = np.arange(len(y)).reshape(-1, 1)
            model = LinearRegression()
            model.fit(X, y)
            future_X = np.arange(len(y), len(y) + 1).reshape(-1, 1)
            pred_next = model.predict(future_X)[0]
            base_risk = max(0, min(100, 100 - pred_next))

        for jam in range(25):
            pred_risk = max(0, min(100, base_risk + np.random.uniform(-3, 3)))
            forecast_risk_real.append({
                "nama_unit": unit_name,
                "jam_ke": jam,
                "prediksi_risiko": round(pred_risk, 2),
            })

    # print(f"[DEBUG] forecast_risk_real count = {len(forecast_risk_real)}")

    # print(f"[DEBUG] unit_stats: {len(unit_stats)}")
    # print(f"[DEBUG] tren_data: {len(tren_data)}")
    # print(f"[DEBUG] forecast_risk_real: {len(forecast_risk_real)}")

    # Konsumsi Energi

    last_7 = KonsumsiEnergi.objects.order_by('-tanggal')[:7][::-1]

    energy_data = [
        {
            "tanggal": e.tanggal.strftime("%d %b"),
            "tanggal_raw": e.tanggal.isoformat(),     # ✅ Tambahan penting!
            "total_pemakaian": float(e.total_pemakaian_energi),
            "total_biaya": float(e.total_biaya),
            "selisih_biaya": float(e.selisih_pemakaian_biaya),
            "deviasi": float(e.deviasi_pemakaian_persen),
        }
        for e in last_7
    ]

    # ==============================
    # ✅ Ambil Hari Ini & Kemarin dari energy_data
    # ==============================

    energi_today = energy_data[-1] if len(energy_data) >= 1 else None
    energi_yesterday = energy_data[-2] if len(energy_data) >= 2 else None

    # Safe handling jika tidak ada data
    total_energi_today = energi_today["total_pemakaian"] if energi_today else 0
    biaya_today = energi_today["total_biaya"] if energi_today else 0

    biaya_yesterday = energi_yesterday["total_biaya"] if energi_yesterday else 0

    selisih_biaya = biaya_today - biaya_yesterday
    deviasi = (selisih_biaya / biaya_yesterday * 100) if biaya_yesterday else 0

    # ✅ Tanggal terakhir tersedia
    last_date_str = last_7[-1].tanggal.strftime(
        "%d %B %Y") if last_7 else "Tidak ada data"

    # === Context ===
    context = {
        "unit_stats": list(unit_stats),
        "kategori_counts": list(kategori_counts),
        "tren_data": list(tren_data),
        "heatmap_data": list(unit_stats),
        "overall_readiness": round(sum([u["rata_nilai"] for u in unit_stats]) / len(unit_stats), 2) if unit_stats else 0,
        "total_peralatan": Peralatan.objects.count(),
        "peralatan_kritis": NilaiKesiapan.objects.filter(kategori_kesiapan__icontains="Not Normal", created_at__date=today),
        "forecast_risk": forecast_risk,               # lama (simulasi)
        "forecast_risk_real": forecast_risk_real,     # baru (regresi linear)
        "unit_comparison": unit_comparison,
        "energy_data": energy_data,
        # ✅ Data untuk bar chart energi hari ini
        "energi_today": total_energi_today,
        "biaya_today": biaya_today,
        "biaya_yesterday": biaya_yesterday,
        "selisih_biaya_today": selisih_biaya,
        "deviasi_today": deviasi,
        "energy_last_date": last_date_str,   # ✅ kirim ke HTML
    }

    # print("Tren Data", context["unit_stats"])
    # print("Overall ", context["overall_readiness"])
    # print("UNIT ", context["unit_stats"])

    return render(request, "dashboard_global.html", context)
