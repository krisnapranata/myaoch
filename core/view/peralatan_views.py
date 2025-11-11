from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from core.models import Peralatan
from django.db.models import Max

# ------------------------------------------
# AUTO KODE PERALATAN
# ------------------------------------------


def generate_kode(unit):
    prefix = unit.nama_unit[:3].upper()  # contoh: Electrical → ELE
    last = Peralatan.objects.filter(unit=unit).aggregate(n=Max("id"))["n"]

    next_num = (last or 0) + 1
    return f"{prefix}-{next_num:03d}"


# ------------------------------------------
# LIST
# ------------------------------------------
def peralatan_list(request):
    unit = request.appuser.unit
    peralatan = Peralatan.objects.filter(unit=unit, is_active=True)
    return render(request, "peralatan/peralatan_list.html", {"peralatan": peralatan})


# ------------------------------------------
# CREATE
# ------------------------------------------
def peralatan_add(request):
    unit = request.appuser.unit

    if request.method == "POST":
        nama = request.POST.get("nama_peralatan")
        jumlah = request.POST.get("jumlah_alat")

        kode = generate_kode(unit)

        Peralatan.objects.create(
            unit=unit,
            nama_peralatan=nama,
            jumlah_alat=jumlah,
            kode_peralatan=kode
        )

        messages.success(request, "✅ Peralatan berhasil ditambahkan!")
        return redirect("peralatan/peralatan_list")

    form = {
        "kode_peralatan": generate_kode(unit)
    }

    return render(request, "peralatan/peralatan_form.html", {"form": form})


# ------------------------------------------
# EDIT
# ------------------------------------------
def peralatan_edit(request, pk):
    alat = get_object_or_404(Peralatan, pk=pk)

    if request.method == "POST":
        alat.nama_peralatan = request.POST.get("nama_peralatan")
        alat.jumlah_alat = request.POST.get("jumlah_alat")
        alat.save()

        messages.success(request, "✅ Peralatan berhasil diperbarui!")
        return redirect("peralatan/peralatan_list")

    form = {
        "kode_peralatan": alat.kode_peralatan,
        "nama_peralatan": alat.nama_peralatan,
        "jumlah_alat": alat.jumlah_alat,
    }

    return render(request, "peralatan/peralatan_form.html", {"form": form})


# ------------------------------------------
# DELETE
# ------------------------------------------
def peralatan_delete(request, pk):
    alat = get_object_or_404(Peralatan, pk=pk)
    alat.delete()
    messages.success(request, "🗑️ Peralatan dihapus.")
    return redirect("peralatan/peralatan_list")
