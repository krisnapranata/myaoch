from functools import wraps
from django.shortcuts import redirect
from django.contrib import messages
from core.models import AppUser


def appuser_required(view_func):
    @wraps(view_func)
    def wrapper(request, *args, **kwargs):
        user_id = request.session.get('appuser_id')
        if not user_id:
            messages.error(request, "⚠️ Anda harus login terlebih dahulu.")
            return redirect('portal_login')

        try:
            appuser = AppUser.objects.get(id=user_id, is_active=True)
            request.appuser = appuser  # 🔹 simpan agar bisa dipakai di template & view
        except AppUser.DoesNotExist:
            messages.error(
                request, "⚠️ Sesi login tidak valid. Silakan login kembali.")
            return redirect('portal_login')

        return view_func(request, *args, **kwargs)
    return wrapper


def unit_must_be(unit_name):
    """Hanya bisa diakses oleh user dari unit tertentu (misal: Electric)."""

    def decorator(view_func):
        @wraps(view_func)
        def wrapper(request, *args, **kwargs):

            # Pastikan appuser_required sudah jalan
            appuser = getattr(request, "appuser", None)

            if not appuser:
                messages.error(request, "⚠️ Anda harus login terlebih dahulu.")
                return redirect("portal_login")

            # Cek unit
            if appuser.unit.nama_unit.lower() != unit_name.lower():
                messages.error(
                    request,
                    f"⚡ Menu ini hanya dapat diakses oleh Unit {unit_name}."
                )
                return redirect("dashboard")  # arahkan ke halaman aman

            return view_func(request, *args, **kwargs)

        return wrapper
    return decorator
