from django.shortcuts import render, get_object_or_404, redirect
from core.models import Notifikasi


def notif_read_and_go(request, notif_id):
    user = request.appuser
    notif = get_object_or_404(Notifikasi, id=notif_id, user=user)
    notif.status_baca = True
    notif.save(update_fields=["status_baca"])
    return redirect("dashboard_global")  # ganti ke halaman tujuanmu


def notifikasi_list(request):
    user = request.appuser
    data = Notifikasi.objects.filter(user=user).order_by("-created_at")
    return render(request, "core/notifikasi_list.html", {"data": data})
