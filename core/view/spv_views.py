from django.shortcuts import render


def spv_dashboard(request):
    return render(request, "spv/dashboard.html")


def verifikasi_spv(request):
    return render(request, "spv/verifikasi.html")
