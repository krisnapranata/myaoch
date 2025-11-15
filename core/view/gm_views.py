from django.shortcuts import render, redirect, get_object_or_404
from core.models import NilaiKesiapan


def gm_dashboard(request):
    items = NilaiKesiapan.objects.filter(
        status="Butuh Verif GM"
    ).select_related("peralatan__unit")

    return render(request, "gm/dashboard.html", {
        "items": items
    })


def gm_verifikasi(request, pk):
    item = get_object_or_404(NilaiKesiapan, id=pk)
    item.status = "Final"
    item.save()
    return redirect("dashboard_gm")


def gm_verifikasi_semua(request):
    NilaiKesiapan.objects.filter(
        status="Butuh Verif GM"
    ).update(status="Final")

    return redirect("dashboard_gm")
