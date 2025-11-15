from django.shortcuts import render, redirect, get_object_or_404
from core.models import NilaiKesiapan


def spv_dashboard(request):
    user = request.appuser

    # Data dari unit SPV yang masih draft
    items = NilaiKesiapan.objects.filter(
        peralatan__unit=user.unit,
        status="Draft"
    ).select_related("peralatan")

    return render(request, "spv/dashboard.html", {
        "items": items,
        "user": user
    })


def spv_verifikasi(request, pk):
    user = request.appuser  # Ambil SPV yg melakukan aksi
    item = get_object_or_404(NilaiKesiapan, id=pk)

    # --- SET SPV YANG VERIFIKASI ---
    item.verifikator_aoch = request.appuser
    item.status = "Diverifikasi SPV"
    item.save()     # <- Signals akan baca perubahan status & kirim notif

    return redirect("dashboard_spv")


def spv_verifikasi_semua(request):
    user = request.appuser  # SPV yang login

    # Ambil semua item yang masih Draft
    items = NilaiKesiapan.objects.filter(
        peralatan__unit=user.unit,
        status="Draft"
    )

    # Loop satu-satu agar signals berjalan
    for item in items:
        item.verifikator_aoch = request.appuser
        item.status = "Diverifikasi SPV"
        item.save()

    return redirect("dashboard_spv")
