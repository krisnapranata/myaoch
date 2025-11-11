from django.shortcuts import render, redirect
from django.contrib import messages
from core.models import AppUser


def login_view(request):
    # ✅ Pastikan messages lama hilang saat buka login
    list(messages.get_messages(request))
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")

        try:
            user = AppUser.objects.get(
                username=username, password=password, is_active=True)
            request.session['appuser_id'] = user.id
            # Arahkan sesuai role
            if user.role == "Operator":
                # return redirect("operator_dashboard")
                return redirect("dashboard")
            elif user.role == "SPV":
                # return redirect("spv_dashboard")
                return redirect("dashboard")
            elif user.role == "AOCH":
                # return redirect("aoch_dashboard")
                return redirect("dashboard")
            elif user.role == "GM":
                # return redirect("gm_dashboard")
                return redirect("dashboard")
            else:
                # return redirect("portal_dashboard")
                return redirect("dashboard")
        except AppUser.DoesNotExist:
            messages.error(request, "Username atau password salah.")
    return render(request, "login.html")


def logout_view(request):
    # Hapus session / cookie login
    request.session.flush()

    # ✅ Bersihkan semua pesan yang tersisa
    list(messages.get_messages(request))

    return redirect("portal_login")
