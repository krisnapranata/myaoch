from django.shortcuts import render


def gm_dashboard(request):
    return render(request, "gm/dashboard.html")


def gm_laporan(request):
    return render(request, "gm/laporan_global.html")
