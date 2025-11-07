from datetime import timedelta
from django.utils import timezone
from django.http import JsonResponse
from django.shortcuts import render
from django.db.models import Avg, Count, F, Max
from django.db.models.functions import TruncDate
from core.models import NilaiKesiapan, Peralatan

import numpy as np
from sklearn.linear_model import LinearRegression  # 🔹 Tambahan

import json


def dashboard_view(request):
    today = timezone.now().date()
    start_date = today - timedelta(days=6)

    qs = (
        NilaiKesiapan.objects
        .filter(created_at__date__gte=start_date)
        .annotate(tgl_agg=TruncDate("created_at"))
        .values("tgl_agg")
        .annotate(avg_nilai=Avg("nilai"))
        .order_by("tgl_agg")
    )

    qs_dict = {d["tgl_agg"]: float(d["avg_nilai"]) for d in qs}
    tren_data = []
    for i in range(7):
        tgl = start_date + timedelta(days=i)
        tren_data.append({
            "tgl_agg": tgl.isoformat(),
            "avg_nilai": qs_dict.get(tgl, 0.0),
        })

    # === Statistik Unit Hari Ini ===
    today = timezone.now().date()
    unit_stats = (
        NilaiKesiapan.objects
        .filter(created_at__date=today)
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
        .filter(created_at__date__gte=start_date)
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

    # === 🔹 Model Baru: Prediksi Real dengan Regresi Linear ===
    forecast_risk_real = []
    units = (
        NilaiKesiapan.objects
        .values_list("peralatan__unit__nama_unit", flat=True)
        .distinct()
    )

    for unit_name in units:
        data_points = (
            NilaiKesiapan.objects
            .filter(peralatan__unit__nama_unit=unit_name, created_at__date__gte=start_date)
            .annotate(tgl_agg=TruncDate("created_at"))
            .values("tgl_agg")
            .annotate(avg_readiness=Avg("nilai"))
            .order_by("tgl_agg")
        )
        y = np.array([float(d["avg_readiness"]) for d in data_points])
        if len(y) < 2:
            continue
        X = np.arange(len(y)).reshape(-1, 1)
        model = LinearRegression()
        model.fit(X, y)

        # Prediksi readiness hari ke depan
        future_X = np.arange(len(y), len(y) + 1).reshape(-1, 1)
        pred_next = model.predict(future_X)[0]
        base_risk = max(0, min(100, 100 - pred_next))

        # Simulasi per jam ±3% dari prediksi dasar
        for jam in range(25):
            pred_risk = max(0, min(100, base_risk + np.random.uniform(-3, 3)))
            forecast_risk_real.append({
                "nama_unit": unit_name,
                "jam_ke": jam,
                "prediksi_risiko": round(pred_risk, 2),
            })

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
    }

    return render(request, "dashboard.html", context)


def dashboard_api_view(request):
    today = timezone.now().date()
    start_date = today - timedelta(days=6)

    # === (Semua kode lama tetap ada, tidak diubah) ===
    qs = (
        NilaiKesiapan.objects
        .filter(created_at__date__gte=start_date)
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

    unit_stats = list(
        NilaiKesiapan.objects
        .filter(created_at__date=today)
        .values(nama_unit=F("peralatan__unit__nama_unit"))
        .annotate(rata_nilai=Avg("nilai"))
        .order_by("nama_unit")
    )
    for u in unit_stats:
        u["rata_nilai"] = float(u["rata_nilai"])

    latest_ids = (
        NilaiKesiapan.objects
        .filter(created_at__date=today)
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
    for u in latest_unit_stats:
        u["rata_terkini"] = float(u["rata_terkini"])

    kategori_counts = list(
        NilaiKesiapan.objects
        .filter(created_at__date=today)
        .values("kategori_kesiapan")
        .annotate(jumlah=Count("id"))
    )

    peralatan_kritis = list(
        NilaiKesiapan.objects
        .filter(created_at__date=today, kategori_kesiapan__icontains="Not Normal")
        .values(
            "peralatan__nama_peralatan",
            "peralatan__unit__nama_unit",
            "nilai",
            "kategori_kesiapan"
        )
    )

    overall_readiness = (
        round(sum([u["rata_nilai"] for u in unit_stats]) / len(unit_stats), 2)
        if unit_stats else 0
    )

    total_peralatan = Peralatan.objects.count()

    # === Model Lama (simulasi) tetap ada ===
    readiness_qs = (
        NilaiKesiapan.objects
        .filter(created_at__date__gte=start_date)
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

    # === 🔹 Tambahan: Prediksi Real (Regresi Linear) ===
    forecast_risk_real = []
    units = (
        NilaiKesiapan.objects
        .values_list("peralatan__unit__nama_unit", flat=True)
        .distinct()
    )
    for unit_name in units:
        data_points = (
            NilaiKesiapan.objects
            .filter(peralatan__unit__nama_unit=unit_name, created_at__date__gte=start_date)
            .annotate(tgl_agg=TruncDate("created_at"))
            .values("tgl_agg")
            .annotate(avg_readiness=Avg("nilai"))
            .order_by("tgl_agg")
        )
        y = np.array([float(d["avg_readiness"]) for d in data_points])
        if len(y) < 2:
            continue
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

    # === Return JSON ===
    return JsonResponse({
        "unit_stats": unit_stats,
        "latest_unit_stats": latest_unit_stats,
        "kategori_counts": kategori_counts,
        "tren_data": tren_data,
        "overall_readiness": overall_readiness,
        "total_peralatan": total_peralatan,
        "peralatan_kritis": peralatan_kritis,
        "forecast_risk": forecast_risk,
        "forecast_risk_real": forecast_risk_real,  # 🔹 Tambahan baru
    })


def get_jumlah_alat(request, peralatan_id):
    try:
        p = Peralatan.objects.get(id=peralatan_id)
        return JsonResponse({
            "ok": True,
            "jumlah_alat": p.jumlah_alat,
            "nama_peralatan": p.nama_peralatan,
            "unit": p.unit.nama_unit,
            "status_operasional": p.status_operasional,
        })
    except Peralatan.DoesNotExist:
        return JsonResponse({"ok": False, "error": "Peralatan tidak ditemukan"}, status=404)
