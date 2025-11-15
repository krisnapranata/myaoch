from django.shortcuts import render, redirect, get_object_or_404
from core.models import NilaiKesiapan


def aoch_dashboard(request):
    items = NilaiKesiapan.objects.filter(
        status="Diverifikasi SPV"
    ).select_related("peralatan__unit")

    return render(request, "aoch/dashboard.html", {
        "items": items
    })


def aoch_verifikasi(request, pk):
    item = get_object_or_404(NilaiKesiapan, id=pk)

    if item.butuh_verif_gm:
        item.status = "Butuh Verif GM"
    else:
        item.status = "Final"

    item.save()
    return redirect("dashboard_aoch")


def aoch_verifikasi_semua(request):
    items = NilaiKesiapan.objects.filter(status="Diverifikasi SPV")

    for item in items:
        if item.butuh_verif_gm:
            item.status = "Butuh Verif GM"
        else:
            item.status = "Final"
        item.save()

    return redirect("dashboard_aoch")
