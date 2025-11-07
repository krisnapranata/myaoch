from django.contrib import admin
from django import forms
from .models import (
    Unit,
    AppUser,
    Peralatan,
    NilaiKesiapan,
    Verifikasi,
    Laporan,
    RiwayatPeralatan,
    Notifikasi,
    FileUpload,
    AIAnalitik,
    SettingAIModel,
    AIDatasetHistory,
    LogAktivitas,
    EnergySetting,
    KonsumsiEnergi,
)

from django.utils.html import format_html
from datetime import timedelta

# ==============================
# 🧱 UNIT
# ==============================


@admin.register(Unit)
class UnitAdmin(admin.ModelAdmin):
    list_display = ('id', 'nama_unit', 'kode_unit', 'lokasi', 'is_active')
    search_fields = ('nama_unit', 'kode_unit')
    list_filter = ('is_active',)


# ==============================
# 👤 USER
# ==============================
@admin.register(AppUser)
class AppUserAdmin(admin.ModelAdmin):
    list_display = ('id', 'nama_lengkap', 'username',
                    'role', 'unit', 'is_active')
    search_fields = ('nama_lengkap', 'username', 'email')
    list_filter = ('role', 'is_active')

    @property
    def is_operator(self):
        return self.role == "Operator"

    @property
    def is_spv(self):
        return self.role == "SPV"

    @property
    def is_aoch(self):
        return self.role == "AOCH"

    @property
    def is_gm(self):
        return self.role == "GM"

    @property
    def is_admin(self):
        return self.role == "Admin"

    @property
    def is_privileged(self):
        """Admin, AOCH, dan GM dapat melihat semua unit."""
        return self.role in ["Admin", "AOCH", "GM"]


# ==============================
# ⚙️ PERALATAN
# ==============================
@admin.register(Peralatan)
class PeralatanAdmin(admin.ModelAdmin):
    list_display = ('nama_peralatan', 'unit',
                    'status_operasional', 'kategori', 'jumlah_alat', 'is_active')
    search_fields = ('nama_peralatan', 'kode_peralatan', 'kategori')
    list_filter = ('status_operasional', 'unit', 'is_active')

    def has_view_permission(self, request, obj=None):
        return request.user.is_superuser or hasattr(request.user, 'appuser')

    def has_change_permission(self, request, obj=None):
        return request.user.is_superuser or hasattr(request.user, 'appuser')

    def has_delete_permission(self, request, obj=None):
        return request.user.is_superuser or hasattr(request.user, 'appuser')

    def has_add_permission(self, request):
        return request.user.is_superuser or (
            hasattr(request.user, 'appuser') and request.user.appuser.is_operator
        )


# ==============================
# 📊 NILAI KESIAPAN
# ==============================
class NilaiKesiapanAdminForm(forms.ModelForm):
    class Meta:
        model = NilaiKesiapan
        fields = '__all__'

    class Media:
        js = ('js/nilai_otomatis.js',)  # file JS custom


@admin.register(NilaiKesiapan)
class NilaiKesiapanAdmin(admin.ModelAdmin):
    form = NilaiKesiapanAdminForm
    # exclude = ('nilai', 'kategori_kesiapan')
    # readonly_fields = ('jumlah_alat_peralatan', 'nilai',)
    # fields = ('peralatan', 'jumlah_alat_normal', 'nilai',
    #           'kategori_kesiapan', 'status', 'user_input')

    list_display = (
        'peralatan',
        'jumlah_alat_peralatan',  # 🔹 tampilkan juga di tabel admin list
        'jumlah_alat_normal',
        'tanggal',
        'nilai',
        'kategori_kesiapan',
        'status',
        'butuh_verif_gm',
        'user_input',
    )

    list_filter = ('status', 'kategori_kesiapan', 'tanggal', 'butuh_verif_gm')
    search_fields = ('peralatan__nama_peralatan', 'kategori_kesiapan')
    date_hierarchy = 'tanggal'

    # 🔹 Tambahkan method custom untuk menampilkan jumlah alat
    def jumlah_alat_peralatan(self, obj):
        if obj.peralatan:
            return obj.peralatan.jumlah_alat
        return "-"
    jumlah_alat_peralatan.short_description = "Jumlah Alat di Peralatan"

    # # 🔹 Fieldsets agar tampil rapi
    # fieldsets = (
    #     (None, {
    #         'fields': (
    #             'peralatan',
    #             'jumlah_alat_peralatan',
    #             'jumlah_alat_normal',
    #             'tanggal',
    #             'status',
    #             'butuh_verif_gm',
    #             'user_input',
    #         )
    #     }),
    # )


# ==============================
# 🧾 VERIFIKASI
# ==============================
@admin.register(Verifikasi)
class VerifikasiAdmin(admin.ModelAdmin):
    list_display = (
        'kesiapan',
        'verifikasi_level',
        'status_verifikasi',
        'requested_by',
        'verifikator',
        'tanggal_verifikasi',
    )
    list_filter = ('verifikasi_level', 'status_verifikasi',
                   'tanggal_verifikasi')
    search_fields = ('kesiapan__peralatan__nama_peralatan', 'catatan')


# ==============================
# 📋 LAPORAN
# ==============================
@admin.register(Laporan)
class LaporanAdmin(admin.ModelAdmin):
    list_display = ('id', 'unit', 'periode', 'rata_kesiapan',
                    'tanggal_awal', 'tanggal_akhir')
    list_filter = ('periode', 'unit')
    date_hierarchy = 'tanggal_awal'
    search_fields = ('unit__nama_unit',)
    readonly_fields = ('created_at',)


# ==============================
# 🧰 RIWAYAT PERALATAN
# ==============================
@admin.register(RiwayatPeralatan)
class RiwayatPeralatanAdmin(admin.ModelAdmin):
    list_display = ('id', 'peralatan', 'jenis_riwayat',
                    'status', 'tanggal_mulai', 'tanggal_selesai')
    list_filter = ('jenis_riwayat', 'status')
    search_fields = ('peralatan__nama_peralatan',)


# ==============================
# 🔔 NOTIFIKASI
# ==============================
@admin.register(Notifikasi)
class NotifikasiAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'judul', 'jenis',
                    'status_baca', 'created_at')
    list_filter = ('jenis', 'status_baca')
    search_fields = ('judul', 'pesan', 'user__nama_lengkap')


# ==============================
# 📎 FILE UPLOAD
# ==============================
@admin.register(FileUpload)
class FileUploadAdmin(admin.ModelAdmin):
    list_display = ('id', 'nama_file', 'peralatan',
                    'jenis_file', 'uploaded_by', 'created_at')
    list_filter = ('jenis_file',)
    search_fields = ('nama_file', 'path_file')


# ==============================
# 🤖 AI ANALITIK
# ==============================
@admin.register(AIAnalitik)
class AIAnalitikAdmin(admin.ModelAdmin):
    list_display = ('id', 'unit', 'periode', 'hasil_prediksi',
                    'confidence_score', 'dibuat_otomatis')
    list_filter = ('periode', 'unit', 'dibuat_otomatis')
    search_fields = ('hasil_prediksi', 'unit__nama_unit')


# ==============================
# ⚙️ SETTING AI MODEL
# ==============================
@admin.register(SettingAIModel)
class SettingAIModelAdmin(admin.ModelAdmin):
    list_display = ('id', 'nama_model', 'versi', 'akurasi', 'created_at')
    search_fields = ('nama_model', 'versi')


# ==============================
# 🧾 AI DATASET HISTORY
# ==============================
@admin.register(AIDatasetHistory)
class AIDatasetHistoryAdmin(admin.ModelAdmin):
    list_display = ('id', 'tanggal', 'jumlah_data',
                    'versi_model', 'status', 'created_at')
    list_filter = ('status', 'tanggal')
    search_fields = ('versi_model',)


# ==============================
# 🧠 LOG AKTIVITAS
# ==============================
@admin.register(LogAktivitas)
class LogAktivitasAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'aksi', 'tabel_terkait',
                    'id_referensi', 'created_at')
    search_fields = ('aksi', 'deskripsi')
    date_hierarchy = 'created_at'


# ===============================
# 1. Admin untuk EnergySetting
# ===============================
@admin.register(EnergySetting)
class EnergySettingAdmin(admin.ModelAdmin):
    list_display = ("nama_bandara", "faktor_kali_kwh", "harga_lwbp", "harga_wbp",
                    "batas_pemakaian_harian", "updated_at")

    fieldsets = (
        ("Info Bandara", {
            "fields": ("nama_bandara",)
        }),
        ("Konfigurasi Faktor", {
            "fields": ("faktor_kali_kwh",)
        }),
        ("Tarif Energi", {
            "fields": ("harga_lwbp", "harga_wbp")
        }),
        ("Batasan Pemakaian", {
            "fields": ("batas_pemakaian_harian",)
        }),
        ("Metadata", {
            "fields": ("updated_at",),
        }),
    )

    readonly_fields = ("updated_at",)

    # OPTIONAL: hanya boleh ada 1 setting
    def has_add_permission(self, request):
        return not EnergySetting.objects.exists()


# ===============================
# 2. Admin untuk KonsumsiEnergi
# ===============================

def to_rupiah(amount):
    if amount is None:
        return "Rp 0"
    return "Rp {:,}".format(int(amount)).replace(",", ".")


@admin.register(KonsumsiEnergi)
class KonsumsiEnergiAdmin(admin.ModelAdmin):

    def get_form(self, request, obj=None, **kwargs):
        form = super().get_form(request, obj, **kwargs)
        self.setting = EnergySetting.objects.first()
        return form

    def get_changeform_initial_data(self, request):
        return {'setting': self.setting}

    def render_change_form(self, request, context, *args, **kwargs):
        # kirim konfigurasi statis
        context['setting'] = EnergySetting.objects.first()

        # kirim total_biaya_kemarin (khusus deviasi/selisih)
        instance = context.get('original')
        yesterday_total = 0
        if instance and instance.tanggal:
            tanggal_kemarin = instance.tanggal - timedelta(days=1)
            yesterday = KonsumsiEnergi.objects.filter(
                tanggal=tanggal_kemarin).first()
            if yesterday:
                yesterday_total = yesterday.total_biaya
        context['total_biaya_kemarin'] = yesterday_total

        return super().render_change_form(request, context, *args, **kwargs)

    change_form_template = "admin/core/konsumsi_form.html"

    class Media:
        js = ['js/admin_konsumsi.js']

    list_display = (
        "tanggal",
        "stand_awal_lwbp", "stand_akhir_lwbp",
        "stand_awal_wbp", "stand_akhir_wbp",
        "total_pemakaian_energi",
        "total_biaya",
        "selisih_pemakaian_biaya",
        "deviasi_pemakaian_persen",
    )

    list_filter = ("tanggal",)
    search_fields = ("tanggal",)

    fieldsets = (
        ("Tanggal", {
            "fields": ("tanggal",)
        }),
        ("Stand Meter LWBP", {
            "fields": ("stand_awal_lwbp", "stand_akhir_lwbp")
        }),
        ("Stand Meter WBP", {
            "fields": ("stand_awal_wbp", "stand_akhir_wbp")
        }),
        ("Perhitungan Pemakaian (Otomatis)", {
            "fields": ("pemakaian_lwbp", "pemakaian_wbp", "total_pemakaian_energi"),
        }),
        ("Perhitungan Biaya (Otomatis)", {
            "fields": (
                "biaya_lwbp",
                "biaya_wbp",
                "total_biaya"),
        }),
        ("Deviasi & Selisih", {
            "fields": ("selisih_pemakaian_biaya", "deviasi_pemakaian_persen"),
        }),
        # ✅ DI SINI TEMPATNYA
        ("Perhitungan Biaya (Otomatis)", {
            "fields": (
                ("display_total_biaya",),
                ("display_selisih", "display_deviasi"),
            ),
        }),
        # ✅ SAMPAI SINI
    )

    # fieldsets = (
    #     ("Deviasi & Selisih", {
    #         "fields": (
    #             ("display_selisih", "display_deviasi"),
    #         )
    #     }),
    # )

    readonly_fields = (
        "display_pemakaian_lwbp",
        "display_pemakaian_wbp",
        "display_total_energi",
        "display_biaya_lwbp",
        "display_biaya_wbp",
        "display_total_biaya",
        "display_selisih",
        "display_deviasi",
        "display_total_biaya",
    )

    # Field yang tidak boleh diedit karena dihitung otomatis
    # readonly_fields = (
    #     "pemakaian_lwbp",
    #     "pemakaian_wbp",
    #     "total_pemakaian_energi",
    #     "biaya_lwbp",
    #     "biaya_wbp",
    #     "total_biaya",
    #     "selisih_pemakaian_biaya",
    #     "deviasi_pemakaian_persen",
    # )
    def display_pemakaian_lwbp(self, obj):
        return format_html('<input type="text" id="id_pemakaian_lwbp" value="{}" readonly>', obj.pemakaian_lwbp)

    def display_pemakaian_wbp(self, obj):
        return format_html('<input type="text" id="id_pemakaian_wbp" value="{}" readonly>', obj.pemakaian_wbp)

    def display_total_energi(self, obj):
        return format_html('<input type="text" id="id_total_pemakaian_energi" value="{}" readonly>', obj.total_pemakaian_energi)

    def display_biaya_lwbp(self, obj):
        return format_html('<input type="text" id="id_biaya_lwbp" value="{}" readonly>', obj.biaya_lwbp)

    def display_biaya_wbp(self, obj):
        return format_html('<input type="text" id="id_biaya_wbp" value="{}" readonly>', obj.biaya_wbp)

    def display_total_biaya(self, obj):
        return format_html(
            '<input type="text" id="id_total_biaya" value="{}" readonly>',
            to_rupiah(obj.total_biaya)
        )

    def display_selisih(self, obj):
        return format_html(
            '<input type="text" id="id_selisih_pemakaian_biaya" value="{}" readonly>',
            to_rupiah(obj.selisih_pemakaian_biaya)
        )

    def display_deviasi(self, obj):
        return format_html('<input type="text" id="id_deviasi_pemakaian_persen" value="{}" readonly>', obj.deviasi_pemakaian_persen)
