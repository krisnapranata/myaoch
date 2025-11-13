from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from core.models import Peralatan
from django.db.models import Max
from django.contrib.auth.decorators import login_required
from core.models import Peralatan
from django.http import JsonResponse
from core.view.decorators import appuser_required


# ------------------------------------------
# AUTO KODE PERALATAN
# ------------------------------------------


def generate_kode(unit):
    prefix = unit.nama_unit[:3].upper()  # contoh: Electrical → ELE
    last = Peralatan.objects.filter(unit=unit).aggregate(n=Max("id"))["n"]

    next_num = (last or 0) + 1
    return f"{prefix}-{next_num:03d}"


# @login_required
def ajax_generate_kode(request):
    unit = request.appuser.unit
    kode = generate_kode(unit)
    return JsonResponse({"kode": kode})


@appuser_required
def peralatan_detail_json(request, pk):
    peralatan = get_object_or_404(Peralatan, pk=pk)
    data = {
        "id": peralatan.id,
        "kode_peralatan": peralatan.kode_peralatan,
        "nama_peralatan": peralatan.nama_peralatan,
        "jumlah_alat": peralatan.jumlah_alat,
        "merk": peralatan.merk or "",
        "model": peralatan.model or "",
        "tahun_pengadaan": peralatan.tahun_pengadaan or "",
        "keterangan": peralatan.keterangan or "",
    }
    return JsonResponse(data)

# ------------------------------------------
# LIST
# ------------------------------------------


def peralatan_list(request):
    # ✅ Bersihkan pesan lama dari session agar tidak muncul ulang
    list(messages.get_messages(request))

    unit = request.appuser.unit
    peralatan = Peralatan.objects.filter(unit=unit, is_active=True)
    return render(request, "peralatan/peralatan_list.html", {"peralatan": peralatan})


# ======================
#  CREATE PERALATAN
# ======================
@appuser_required
def peralatan_add(request):
    unit = request.appuser.unit  # otomatis dari user login

    if request.method == "POST":
        nama = request.POST.get("nama_peralatan")
        jumlah = request.POST.get("jumlah_alat") or 1
        merk = request.POST.get("merk")
        model = request.POST.get("model")
        tahun = request.POST.get("tahun_pengadaan")
        keterangan = request.POST.get("keterangan")

        # ✅ Validasi wajib isi nama
        if not nama:
            messages.error(
                request, "⚠️ Nama peralatan wajib diisi.", extra_tags="peralatan")
            return redirect("peralatan_list")

        # ✅ Auto generate kode
        kode = generate_kode(unit)

        # ✅ Simpan ke database lengkap
        Peralatan.objects.create(
            unit=unit,
            nama_peralatan=nama,
            jumlah_alat=jumlah,
            kode_peralatan=kode,
            merk=merk,
            model=model,
            tahun_pengadaan=tahun if tahun else None,
            keterangan=keterangan,
            kategori="Prioritas",
            status_operasional="Normal",
            is_active=True
        )

        messages.success(
            request, f"✅ Peralatan '{nama}' berhasil ditambahkan!", extra_tags="peralatan")
        return redirect("peralatan_list")

    # kalau GET → tampilkan form kosong
    form = {"kode_peralatan": generate_kode(unit)}
    return render(request, "peralatan/peralatan_form.html", {"form": form})


# ------------------------------------------
# EDIT
# ------------------------------------------

@appuser_required
def peralatan_edit(request, pk):
    alat = get_object_or_404(Peralatan, pk=pk)
    if request.method == "POST":
        alat.nama_peralatan = request.POST.get("nama_peralatan")
        alat.jumlah_alat = request.POST.get("jumlah_alat")
        alat.merk = request.POST.get("merk")
        alat.model = request.POST.get("model")
        alat.tahun_pengadaan = request.POST.get("tahun_pengadaan")
        alat.keterangan = request.POST.get("keterangan")
        alat.save()
        messages.success(
            request, "✏️ Peralatan berhasil diperbarui!", extra_tags="peralatan")
        return redirect("peralatan_list")


# ------------------------------------------
# DELETE
# ------------------------------------------
def peralatan_delete(request, pk):
    alat = get_object_or_404(Peralatan, pk=pk)
    alat.delete()
    messages.success(request, "🗑️ Peralatan dihapus.", extra_tags="peralatan")
    return redirect("peralatan_list")
