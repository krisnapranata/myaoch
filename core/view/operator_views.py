from django.shortcuts import render, redirect
from django.utils import timezone
from django.contrib import messages

from django.views.decorators.http import require_POST
from django.db import transaction
# pastikan ini benar sesuai path app kamu
from core.models import Peralatan, NilaiKesiapan


# def operator_dashboard(request):
#     return render(request, "operator/dashboard.html")


def input_kesiapan(request):
    return render(request, "operator/input_kesiapan.html")


def operator_history(request):
    return render(request, "operator/history.html")


def operator_dashboard(request):
    user = request.appuser

    # Ambil semua peralatan unit
    peralatan_list = Peralatan.objects.filter(
        unit=user.unit, is_active=True
    ).order_by("nama_peralatan")

    today = timezone.localdate()

    # Ambil nilai kesiapan yang sudah tersimpan hari ini
    existing = {
        nk.peralatan_id: nk
        for nk in NilaiKesiapan.objects.filter(
            peralatan__unit=user.unit,
            tanggal=today
        )
    }

    # Inject nilai existing ke setiap peralatan
    for p in peralatan_list:
        nk = existing.get(p.id)

        if nk:
            # ✅ jumlah alat normal langsung dari database
            p.jumlah_normal_hari_ini = nk.jumlah_alat_normal

            # ✅ nilai kesiapan (%) langsung dari kolom di tabel NilaiKesiapan
            p.nilai_hari_ini = nk.nilai
        else:
            p.jumlah_normal_hari_ini = ""
            p.nilai_hari_ini = ""

    context = {
        "peralatan_list": peralatan_list,
        "today": today,
        "user": user,
    }
    return render(request, "operator/dashboard.html", context)


@require_POST
def operator_save_kesiapan(request):
    user = request.appuser
    peralatan_id = request.POST.get("peralatan_id")
    raw = (request.POST.get("jumlah_normal") or "").strip()

    # 1) Wajib diisi
    if raw == "":
        messages.error(
            request, "Jumlah normal tidak boleh kosong. Minimal isi angka 0.")
        return redirect("operator_dashboard")

    # 2) Harus angka
    try:
        jumlah_normal = int(raw)
    except (TypeError, ValueError):
        messages.error(request, "Jumlah normal harus berupa angka.")
        return redirect("operator_dashboard")

    # 3) Ambil peralatan
    try:
        peralatan = Peralatan.objects.get(id=peralatan_id, is_active=True)
    except Peralatan.DoesNotExist:
        messages.error(request, "Peralatan tidak ditemukan atau tidak aktif.")
        return redirect("operator_dashboard")

    total = peralatan.jumlah_alat or 0

    # 4) Validasi batas bawah
    if jumlah_normal < 0:
        messages.error(
            request, f"{peralatan.nama_peralatan}: jumlah normal tidak boleh < 0.")
        return redirect("operator_dashboard")

    # ✅ 5) Validasi batas atas (SEPERTI save_all)
    if jumlah_normal > total:
        messages.error(
            request,
            f"{peralatan.nama_peralatan}: {jumlah_normal} > total alat ({total})."
        )
        return redirect("operator_dashboard")

    # 6) Simpan nilai kesiapan
    today = timezone.localdate()
    nk, created = NilaiKesiapan.objects.get_or_create(
        peralatan=peralatan,
        tanggal=today,
        defaults={
            "jumlah_alat_normal": jumlah_normal,
            "user_input": user,
            "status": "Draft",
        }
    )

    if not created:
        nk.jumlah_alat_normal = jumlah_normal
        nk.user_input = user
        if not nk.status:
            nk.status = "Draft"
        nk.full_clean()
        nk.save()

    messages.success(
        request, f"✅ Data '{peralatan.nama_peralatan}' berhasil disimpan.")
    return redirect("operator_dashboard")


@require_POST
@transaction.atomic
def operator_save_all(request):
    user = request.appuser
    today = timezone.localdate()

    errors = []
    saved = 0

    # Loop semua field jumlah_normal_<id>
    for key, value in request.POST.items():
        if not key.startswith("jumlah_normal_"):
            continue

        peralatan_id_str = key.replace("jumlah_normal_", "")
        try:
            peralatan_id = int(peralatan_id_str)
        except (TypeError, ValueError):
            continue

        raw = (value or "").strip()

        # Kosong → SKIP (tidak menimpa data lama)
        if raw == "":
            continue

        # Harus angka
        try:
            jumlah_normal = int(raw)
        except (TypeError, ValueError):
            errors.append(f"Peralatan ID {peralatan_id}: nilai bukan angka.")
            continue

        peralatan = Peralatan.objects.filter(
            id=peralatan_id, is_active=True).first()
        if not peralatan:
            errors.append(
                f"Peralatan ID {peralatan_id}: tidak ditemukan/ non-aktif.")
            continue

        total = peralatan.jumlah_alat or 0

        # Validasi batas bawah & atas
        if jumlah_normal < 0:
            errors.append(f"{peralatan.nama_peralatan}: tidak boleh < 0.")
            continue

        if jumlah_normal > total:
            errors.append(
                f"{peralatan.nama_peralatan}: {jumlah_normal} > total alat ({total})."
            )
            continue

        # Simpan yang valid
        nk, created = NilaiKesiapan.objects.get_or_create(
            peralatan=peralatan,
            tanggal=today,
            defaults={
                "jumlah_alat_normal": jumlah_normal,
                "user_input": user,
                "status": "Draft",
            }
        )
        if not created:
            nk.jumlah_alat_normal = jumlah_normal
            nk.user_input = user
            if not nk.status:
                nk.status = "Draft"
            nk.full_clean()  # hormati validasi model
            nk.save()

        saved += 1

    if saved:
        messages.success(request, f"✅ {saved} baris berhasil disimpan.")
    if errors:
        # Tampilkan semua error sebagai satu pesan
        messages.error(
            request, "❌ Beberapa baris tidak disimpan:\n- " + "\n- ".join(errors))

    return redirect("operator_dashboard")
