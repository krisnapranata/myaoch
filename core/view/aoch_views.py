from django.shortcuts import render


def aoch_dashboard(request):
    return render(request, "aoch/dashboard.html")


def laporan_aoch(request):
    return render(request, "aoch/laporan.html")
