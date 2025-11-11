from datetime import datetime, timedelta, date
from django.utils import timezone
from django.http import JsonResponse
from django.shortcuts import render
from django.db.models import Avg, Count, F, Max, Sum, FloatField, ExpressionWrapper, OuterRef, Subquery
from django.db.models.functions import TruncDate
from core.models import NilaiKesiapan, Peralatan, KonsumsiEnergi, Unit

import numpy as np
from sklearn.linear_model import LinearRegression  # 🔹 Tambahan

import json


def api_view(request):
    today = timezone.localtime(timezone.now()).date()
    start_date = today - timedelta(days=6)
    start_dt = timezone.make_aware(
        datetime.combine(start_date, datetime.min.time()))

    # === (Semua kode lama tetap ada, tidak diubah) ===
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
    #     .filter(created_at__gte=timezone.make_aware(datetime.combine(start_date, datetime.min.time())))
    #     .annotate(tgl_agg=TruncDate("created_at"))
    #     .values("tgl_agg")
    #     .annotate(avg_nilai=Avg("nilai"))
    #     .order_by("tgl_agg")
    # )

    # qs_dict = {d["tgl_agg"]: float(d["avg_nilai"]) for d in qs}
    # tren_data = [
    #     {"tgl_agg": (start_date + timedelta(days=i)).isoformat(),
    #      "avg_nilai": qs_dict.get(start_date + timedelta(days=i), 0.0)}
    #     for i in range(7)
    # ]

    tren_data = []

    total_units = (
        Peralatan.objects
        .values("unit_id")
        .distinct()
        .count()
    )

    for i in range(7):
        day = start_date + timedelta(days=i)
        day_start = timezone.make_aware(
            datetime.combine(day, datetime.min.time()))
        day_end = timezone.make_aware(
            datetime.combine(day, datetime.max.time()))

        # Ambil semua nilai kesiapan hari itu
        nilai_qs = (
            NilaiKesiapan.objects
            .filter(created_at__range=(day_start, day_end))
            .select_related("peralatan__unit")
        )

        if not nilai_qs.exists():
            tren_data.append({
                "tgl_agg": day.isoformat(),
                "avg_nilai": 0
            })
            continue

        # Kumpulkan total nilai per unit
        nilai_per_unit = {}
        for nk in nilai_qs:
            uid = nk.peralatan.unit_id
            nilai_per_unit.setdefault(uid, 0)
            nilai_per_unit[uid] += nk.nilai

        # Hitung rata_nilai per unit
        rata_per_unit = []
        for uid, total_nilai_unit in nilai_per_unit.items():
            jumlah_alat_unit = (
                Peralatan.objects
                .filter(unit_id=uid, is_active=True)
                .count()
            )

            if jumlah_alat_unit == 0:
                continue

            rata_val = total_nilai_unit / jumlah_alat_unit
            rata_per_unit.append(rata_val)

        # Jika tidak ada unit yang punya data
        if not rata_per_unit:
            tren_data.append({
                "tgl_agg": day.isoformat(),
                "avg_nilai": 0
            })
            continue

        # === Rumus Versi B ===
        # Sama seperti overall_readiness
        tren_hari = sum(rata_per_unit) / total_units

        tren_data.append({
            "tgl_agg": day.isoformat(),
            "avg_nilai": round(tren_hari, 2)
        })

    # === Statistik Unit Hari Ini (Timezone-safe) ===
    today_local = timezone.localdate()
    today_start = timezone.make_aware(
        datetime.combine(today_local, datetime.min.time()))
    today_end = timezone.make_aware(
        datetime.combine(today_local, datetime.max.time()))

    # unit_stats = list(
    #     NilaiKesiapan.objects
    #     .filter(created_at__range=(today_start, today_end))
    #     .values(nama_unit=F("peralatan__unit__nama_unit"))
    #     .annotate(rata_nilai=Avg("nilai"))
    #     .order_by("nama_unit")
    # )

    # Subquery: hitung jumlah alat dalam 1 unit
    jumlah_peralatan_subquery = (
        Peralatan.objects
        .filter(unit=OuterRef("peralatan__unit"))
        .filter(is_active=True)
        .values("unit")
        .annotate(jml=Count("id"))
        .values("jml")
    )

    # Hitung statistik nilai per unit
    unit_stats = list(
        NilaiKesiapan.objects
        .filter(created_at__range=(today_start, today_end))
        .values(nama_unit=F("peralatan__unit__nama_unit"))
        .annotate(
            total_nilai=Sum("nilai"),
            jumlah_peralatan=Subquery(jumlah_peralatan_subquery[:1]),
        )
        .annotate(
            rata_nilai=ExpressionWrapper(
                F("total_nilai") * 1.0 / F("jumlah_peralatan"),
                output_field=FloatField(),
            )
        )
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

    total_units = Unit.objects.count()
    if total_units == 0:
        total_units = 1

    overall_readiness = (
        round(sum([u["rata_nilai"] for u in unit_stats]) / total_units, 2)
        if unit_stats else 0
    )

    total_peralatan = Peralatan.objects.count()

    # === Model Lama (simulasi) tetap ada ===
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

    # === 🔹 Tambahan: Prediksi Real (Regresi Linear) ===
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
    #     future_X = np.arange(len(y), len(y) + 1).reshape(-1, 1)
    #     pred_next = model.predict(future_X)[0]
    #     base_risk = max(0, min(100, 100 - pred_next))
    #     for jam in range(25):
    #         pred_risk = max(0, min(100, base_risk + np.random.uniform(-3, 3)))
    #         forecast_risk_real.append({
    #             "nama_unit": unit_name,
    #             "jam_ke": jam,
    #             "prediksi_risiko": round(pred_risk, 2),
    #         })

    # === 🔹 Model Baru: Prediksi Real dengan Regresi Linear ===
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

    # print(forecast_risk_real)

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


def get_biaya_kemarin(request):
    tanggal = request.GET.get("tanggal")
    if not tanggal:
        return JsonResponse({"biaya_kemarin": 0})

    tgl = date.fromisoformat(tanggal)
    tgl_kemarin = tgl - timedelta(days=1)

    yesterday = KonsumsiEnergi.objects.filter(tanggal=tgl_kemarin).first()

    if yesterday:
        return JsonResponse({"biaya_kemarin": float(yesterday.total_biaya)})

    return JsonResponse({"biaya_kemarin": 0})
