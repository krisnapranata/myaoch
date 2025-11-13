from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.db.models import Max
from django.contrib.auth.decorators import login_required
from core.models import EnergySetting, KonsumsiEnergi
from django.http import JsonResponse
from core.view.decorators import appuser_required, unit_must_be
from decimal import Decimal
from datetime import date


@appuser_required
@unit_must_be("Electrical")
def energi_list(request):
    # bersihkan messages lama
    list(messages.get_messages(request))

    setting = EnergySetting.objects.first()

    data = KonsumsiEnergi.objects.order_by("-tanggal")[:30]  # tampil 30 hari
    return render(request, "energi/energi_list.html", {
        "data": data,
        "setting": setting,
    })


@appuser_required
@unit_must_be("Electrical")
def energi_add(request):
    if request.method == "POST":

        obj = KonsumsiEnergi()

        obj.tanggal = date.fromisoformat(request.POST.get("tanggal"))

        obj.stand_awal_lwbp = Decimal(request.POST.get("awal_lwbp") or 0)
        obj.stand_akhir_lwbp = Decimal(request.POST.get("akhir_lwbp") or 0)

        obj.stand_awal_wbp = Decimal(request.POST.get("awal_wbp") or 0)
        obj.stand_akhir_wbp = Decimal(request.POST.get("akhir_wbp") or 0)

        obj.save()

        messages.success(
            request, "⚡ Data energi berhasil disimpan!", extra_tags="energi")
        return redirect("energi_list")

    return render(request, "energi/energi_form.html")


@appuser_required
@unit_must_be("Electrical")
def energi_edit(request, pk):
    data = get_object_or_404(KonsumsiEnergi, pk=pk)

    if request.method == "POST":

        # 🟦 Konversi tanggal (WAJIB kalau tidak error)
        data.tanggal = date.fromisoformat(request.POST.get("tanggal"))

        # 🟩 Konversi decimal (untuk menghindari error float/str)
        data.stand_awal_lwbp = Decimal(request.POST.get("awal_lwbp") or 0)
        data.stand_akhir_lwbp = Decimal(request.POST.get("akhir_lwbp") or 0)
        data.stand_awal_wbp = Decimal(request.POST.get("awal_wbp") or 0)
        data.stand_akhir_wbp = Decimal(request.POST.get("akhir_wbp") or 0)

        # Menjalankan ulang seluruh perhitungan
        data.save()

        messages.success(
            request, "✏️ Data energi berhasil diperbarui!", extra_tags="energi"
        )
        return redirect("energi_list")

    return redirect("energi_list")


@appuser_required
@unit_must_be("Electrical")
def energi_delete(request, pk):
    data = get_object_or_404(KonsumsiEnergi, pk=pk)
    data.delete()
    messages.success(request, "🗑️ Data energi dihapus!", extra_tags="energi")
    return redirect("energi_list")


@appuser_required
@unit_must_be("Electrical")
def energi_detail_json(request, pk):
    e = get_object_or_404(KonsumsiEnergi, pk=pk)

    return JsonResponse({
        "tanggal": e.tanggal,
        "stand_awal_lwbp": float(e.stand_awal_lwbp),
        "stand_akhir_lwbp": float(e.stand_akhir_lwbp),
        "stand_awal_wbp": float(e.stand_awal_wbp),
        "stand_akhir_wbp": float(e.stand_akhir_wbp),
        "pemakaian_lwbp": float(e.pemakaian_lwbp),
        "pemakaian_wbp": float(e.pemakaian_wbp),
        "total": float(e.total_pemakaian_energi),
        "biaya": float(e.total_biaya),
    })


@appuser_required
@unit_must_be("Electrical")
def energy_setting_update(request):
    # Ambil konfigurasi pertama (harusnya hanya 1 row)
    setting = EnergySetting.objects.first()

    if request.method == "POST":
        setting.nama_bandara = request.POST.get("nama_bandara")
        setting.faktor_kali_kwh = Decimal(
            request.POST.get("faktor_kali_kwh") or 0)
        setting.harga_lwbp = Decimal(request.POST.get("harga_lwbp") or 0)
        setting.harga_wbp = Decimal(request.POST.get("harga_wbp") or 0)
        setting.batas_pemakaian_harian = Decimal(
            request.POST.get("batas_pemakaian_harian") or 0)
        setting.save()

        messages.success(
            request, "⚙️ Setting energi berhasil diperbarui!", extra_tags="energi")
        return redirect("energi_list")

    return redirect("energi_list")
