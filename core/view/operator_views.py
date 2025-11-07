from django.shortcuts import render


def operator_dashboard(request):
    return render(request, "operator/dashboard.html")


def input_kesiapan(request):
    return render(request, "operator/input_kesiapan.html")


def operator_history(request):
    return render(request, "operator/history.html")
