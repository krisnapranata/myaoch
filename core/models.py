from django.db import models
from django.utils import timezone
from decimal import Decimal
from django.core.exceptions import ValidationError
from datetime import timedelta

# ==========================
# 1️⃣ UNIT
# ==========================


class Unit(models.Model):
    nama_unit = models.CharField(max_length=100)
    kode_unit = models.CharField(
        max_length=10, unique=True, null=True, blank=True)
    lokasi = models.CharField(max_length=100, null=True, blank=True)
    keterangan = models.TextField(null=True, blank=True)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return self.nama_unit


# ==========================
# 2️⃣ USER
# ==========================
class AppUser(models.Model):
    ROLE_CHOICES = [
        ('Operator', 'Operator'),
        ('SPV', 'Supervisor'),
        ('AOCH', 'AOCH'),
        ('GM', 'General Manager'),
        ('Admin', 'Admin'),
    ]

    username = models.CharField(max_length=50, unique=True)
    password = models.CharField(max_length=128)
    nama_lengkap = models.CharField(max_length=100)
    unit = models.ForeignKey(
        Unit, on_delete=models.SET_NULL, null=True, blank=True)
    role = models.CharField(max_length=20, choices=ROLE_CHOICES)
    email = models.EmailField(max_length=100, null=True, blank=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.nama_lengkap} ({self.role})"


# ==========================
# 3️⃣ PERALATAN
# ==========================
class Peralatan(models.Model):
    STATUS_CHOICES = [
        ('Normal', 'Normal'),
        ('Serviceable', 'Serviceable'),
        ('Unserviceable', 'Unserviceable'),
        ('Tidak Normal', 'Tidak Normal'),
    ]

    KATEGOSRI_CHOICES = [
        ('Prioritas', 'Prioritas'),
        ('Non Prioritas', 'Non Prioritas'),
    ]

    unit = models.ForeignKey(Unit, on_delete=models.CASCADE)
    nama_peralatan = models.CharField(max_length=150)
    kode_peralatan = models.CharField(max_length=30, unique=True)
    jumlah_alat = models.PositiveIntegerField(
        default=1, help_text="Total alat yang dimiliki unit ini.")
    # gunakan sebagai alat prioritas atau tidak
    kategori = models.CharField(
        max_length=20, null=True, blank=True, choices=KATEGOSRI_CHOICES, default="Prioritas")
    merk = models.CharField(max_length=50, null=True, blank=True)
    model = models.CharField(max_length=50, null=True, blank=True)
    tahun_pengadaan = models.IntegerField(null=True, blank=True)
    status_operasional = models.CharField(
        max_length=20, choices=STATUS_CHOICES, default='Normal')
    keterangan = models.TextField(null=True, blank=True)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return f"{self.nama_peralatan} ({self.unit.nama_unit})"


# ==========================
# 4️⃣ NILAI KESIAPAN
# ==========================
class NilaiKesiapan(models.Model):
    STATUS_CHOICES = [
        ('Draft', 'Draft'),
        ('Diverifikasi SPV', 'Diverifikasi SPV'),
        ('Diverifikasi AOCH', 'Diverifikasi AOCH'),
        ('Butuh Verif GM', 'Butuh Verif GM'),
        ('Final', 'Final'),
    ]

    peralatan = models.ForeignKey(Peralatan, on_delete=models.CASCADE)
    tanggal = models.DateField(default=timezone.localdate)
    jumlah_alat_normal = models.PositiveIntegerField(
        default=1, help_text="Jumlah alat berstatus normal/serviceable.")
    nilai = models.DecimalField(max_digits=5, decimal_places=2)
    kategori_kesiapan = models.CharField(max_length=50, null=True, blank=True)
    keterangan = models.TextField(null=True, blank=True)
    status = models.CharField(
        max_length=30, choices=STATUS_CHOICES, default='Draft')
    butuh_verif_gm = models.BooleanField(default=False)
    user_input = models.ForeignKey(
        AppUser, on_delete=models.SET_NULL, null=True, blank=True, related_name='input_by')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def clean(self):
        """Validasi logika jumlah alat normal tidak boleh melebihi total alat."""
        total_alat = getattr(self.peralatan, "jumlah_alat", 1) or 1
        if self.jumlah_alat_normal > total_alat:
            raise ValidationError({
                "jumlah_alat_normal": f"Jumlah alat normal ({self.jumlah_alat_normal}) "
                f"tidak boleh melebihi total alat ({total_alat}) untuk peralatan ini."
            })

    def save(self, *args, **kwargs):
        """Hitung otomatis kategori dan nilai kesiapan."""
        total_alat = getattr(self.peralatan, "jumlah_alat", 1) or 1

        # Hitung nilai otomatis dari jumlah alat normal
        if self.jumlah_alat_normal is not None:
            self.nilai = (self.jumlah_alat_normal / total_alat) * 100

        # Tetapkan kategori otomatis dari nilai
        if self.nilai <= 25:
            self.kategori_kesiapan = "Not Normal / Unserviceable"
        elif self.nilai <= 50:
            self.kategori_kesiapan = "Not Normal / Serviceable"
        elif self.nilai <= 75:
            self.kategori_kesiapan = "Normal / Unserviceable"
        else:
            self.kategori_kesiapan = "Normal / Serviceable"

        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.peralatan.nama_peralatan} ({self.nilai:.2f}%)"


# ==========================
# 5️⃣ VERIFIKASI
# ==========================
class Verifikasi(models.Model):
    LEVEL_CHOICES = [
        ('SPV', 'SPV'),
        ('AOCH', 'AOCH'),
        ('GM', 'GM'),
    ]
    STATUS_CHOICES = [
        ('Approved', 'Approved'),
        ('Rejected', 'Rejected'),
        ('Pending', 'Pending'),
    ]

    kesiapan = models.ForeignKey(NilaiKesiapan, on_delete=models.CASCADE)
    verifikasi_level = models.CharField(max_length=10, choices=LEVEL_CHOICES)
    requested_by = models.ForeignKey(
        AppUser, on_delete=models.SET_NULL, null=True, blank=True, related_name='requested_verif')
    verifikator = models.ForeignKey(
        AppUser, on_delete=models.SET_NULL, null=True, blank=True, related_name='verifikator')
    status_verifikasi = models.CharField(
        max_length=10, choices=STATUS_CHOICES, default='Pending')
    catatan = models.TextField(null=True, blank=True)
    tanggal_verifikasi = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return f"{self.kesiapan.peralatan.nama_peralatan} - {self.verifikasi_level} ({self.status_verifikasi})"


# ==========================
# 6️⃣ LAPORAN
# ==========================
class Laporan(models.Model):
    PERIODE_CHOICES = [
        ('Harian', 'Harian'),
        ('Mingguan', 'Mingguan'),
        ('Bulanan', 'Bulanan'),
    ]

    periode = models.CharField(max_length=10, choices=PERIODE_CHOICES)
    tanggal_awal = models.DateField()
    tanggal_akhir = models.DateField()
    unit = models.ForeignKey(Unit, on_delete=models.CASCADE)
    rata_kesiapan = models.DecimalField(
        max_digits=5, decimal_places=2, null=True, blank=True)
    distribusi_kategori = models.JSONField(null=True, blank=True)
    catatan = models.TextField(null=True, blank=True)
    dibuat_oleh = models.ForeignKey(
        AppUser, on_delete=models.SET_NULL, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Laporan {self.periode} - {self.unit.nama_unit}"


# ==========================
# 7️⃣ RIWAYAT PERALATAN
# ==========================
class RiwayatPeralatan(models.Model):
    JENIS_CHOICES = [
        ('Perawatan', 'Perawatan'),
        ('Perbaikan', 'Perbaikan'),
        ('Downtime', 'Downtime'),
        ('Kalibrasi', 'Kalibrasi'),
    ]
    STATUS_CHOICES = [
        ('Selesai', 'Selesai'),
        ('Proses', 'Proses'),
        ('Dijadwalkan', 'Dijadwalkan'),
    ]

    peralatan = models.ForeignKey(Peralatan, on_delete=models.CASCADE)
    jenis_riwayat = models.CharField(max_length=20, choices=JENIS_CHOICES)
    tanggal_mulai = models.DateField(null=True, blank=True)
    tanggal_selesai = models.DateField(null=True, blank=True)
    deskripsi = models.TextField(null=True, blank=True)
    hasil = models.TextField(null=True, blank=True)
    status = models.CharField(
        max_length=20, choices=STATUS_CHOICES, default='Proses')
    dibuat_oleh = models.ForeignKey(
        AppUser, on_delete=models.SET_NULL, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.peralatan.nama_peralatan} - {self.jenis_riwayat}"


# ==========================
# 8️⃣ NOTIFIKASI
# ==========================
class Notifikasi(models.Model):
    JENIS_CHOICES = [
        ('Kesiapan', 'Kesiapan'),
        ('Verifikasi', 'Verifikasi'),
        ('Peralatan', 'Peralatan'),
        ('AI Insight', 'AI Insight'),
    ]

    user = models.ForeignKey(AppUser, on_delete=models.CASCADE)
    judul = models.CharField(max_length=150)
    pesan = models.TextField()
    jenis = models.CharField(
        max_length=30, choices=JENIS_CHOICES, default='Kesiapan')
    status_baca = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.judul} ({self.user})"


# ==========================
# 9️⃣ FILE UPLOAD
# ==========================
class FileUpload(models.Model):
    JENIS_CHOICES = [
        ('Foto', 'Foto'),
        ('Dokumen', 'Dokumen'),
        ('Lainnya', 'Lainnya'),
    ]

    peralatan = models.ForeignKey(
        Peralatan, on_delete=models.CASCADE, null=True, blank=True)
    kesiapan = models.ForeignKey(
        NilaiKesiapan, on_delete=models.CASCADE, null=True, blank=True)
    nama_file = models.CharField(max_length=255)
    path_file = models.CharField(max_length=255)
    jenis_file = models.CharField(
        max_length=20, choices=JENIS_CHOICES, default='Foto')
    uploaded_by = models.ForeignKey(
        AppUser, on_delete=models.SET_NULL, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.nama_file


# ==========================
# 🔍 AI & ANALYTICS TABLES
# ==========================
class AIAnalitik(models.Model):
    unit = models.ForeignKey(Unit, on_delete=models.CASCADE)
    periode = models.DateField()
    hasil_prediksi = models.CharField(max_length=150, null=True, blank=True)
    faktor_penyebab = models.TextField(null=True, blank=True)
    saran_tindakan = models.TextField(null=True, blank=True)
    confidence_score = models.DecimalField(
        max_digits=5, decimal_places=2, null=True, blank=True)
    dibuat_otomatis = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)


class SettingAIModel(models.Model):
    nama_model = models.CharField(max_length=100)
    versi = models.CharField(max_length=20)
    akurasi = models.DecimalField(max_digits=5, decimal_places=2)
    path_model = models.CharField(max_length=255)
    deskripsi = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)


class AIDatasetHistory(models.Model):
    tanggal = models.DateField()
    jumlah_data = models.IntegerField(null=True, blank=True)
    sumber_data = models.CharField(max_length=100, null=True, blank=True)
    versi_model = models.CharField(max_length=20, null=True, blank=True)
    akurasi_model = models.DecimalField(
        max_digits=5, decimal_places=2, null=True, blank=True)
    status = models.CharField(max_length=20, default='Training')
    created_at = models.DateTimeField(auto_now_add=True)


# ==========================
# 🧠 LOG AKTIVITAS
# ==========================
class LogAktivitas(models.Model):
    user = models.ForeignKey(
        AppUser, on_delete=models.SET_NULL, null=True, blank=True)
    aksi = models.CharField(max_length=150)
    tabel_terkait = models.CharField(max_length=50, null=True, blank=True)
    id_referensi = models.IntegerField(null=True, blank=True)
    deskripsi = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user} - {self.aksi}"


class EnergySetting(models.Model):
    nama_bandara = models.CharField(max_length=100, default="BIZAM")

    # Data statis
    faktor_kali_kwh = models.DecimalField(
        max_digits=10, decimal_places=2, default=8000)
    harga_lwbp = models.DecimalField(
        max_digits=12, decimal_places=2, default=1035.78)
    harga_wbp = models.DecimalField(
        max_digits=12, decimal_places=2, default=1553.67)
    batas_pemakaian_harian = models.DecimalField(
        max_digits=12, decimal_places=2, default=30000)

    # Metadata
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Konfigurasi Energi {self.nama_bandara}"


class KonsumsiEnergi(models.Model):
    # Informasi dasar
    tanggal = models.DateField(default=timezone.localdate)

    # Stand meter
    stand_awal_lwbp = models.DecimalField(max_digits=12, decimal_places=2)
    stand_akhir_lwbp = models.DecimalField(max_digits=12, decimal_places=2)

    stand_awal_wbp = models.DecimalField(max_digits=12, decimal_places=2)
    stand_akhir_wbp = models.DecimalField(max_digits=12, decimal_places=2)

    # Hasil perhitungan otomatis
    pemakaian_lwbp = models.DecimalField(
        max_digits=12, decimal_places=2, default=0)
    pemakaian_wbp = models.DecimalField(
        max_digits=12, decimal_places=2, default=0)
    total_pemakaian_energi = models.DecimalField(
        max_digits=12, decimal_places=2, default=0)

    biaya_lwbp = models.DecimalField(
        max_digits=15, decimal_places=2, default=0)
    biaya_wbp = models.DecimalField(max_digits=15, decimal_places=2, default=0)
    total_biaya = models.DecimalField(
        max_digits=15, decimal_places=2, default=0)

    selisih_pemakaian_biaya = models.DecimalField(
        max_digits=15, decimal_places=2, default=0)
    deviasi_pemakaian_persen = models.DecimalField(
        max_digits=10, decimal_places=2, default=0)

    def save(self, *args, **kwargs):
        setting = EnergySetting.objects.first()
        faktor = setting.faktor_kali_kwh
        harga_lwbp = setting.harga_lwbp
        harga_wbp = setting.harga_wbp

        # --- 1 & 2: Hitung pemakaian ---
        self.pemakaian_lwbp = (self.stand_akhir_lwbp -
                               self.stand_awal_lwbp) * faktor
        self.pemakaian_wbp = (self.stand_akhir_wbp -
                              self.stand_awal_wbp) * faktor

        # --- 3: Total energi ---
        self.total_pemakaian_energi = self.pemakaian_lwbp + self.pemakaian_wbp

        # --- 4 & 5: Hitung biaya ---
        self.biaya_lwbp = self.pemakaian_lwbp * harga_lwbp
        self.biaya_wbp = self.pemakaian_wbp * harga_wbp

        # --- 6: Total biaya ---
        self.total_biaya = self.biaya_lwbp + self.biaya_wbp

        # --- 7: Selisih berdasarkan tanggal kemarin SPESIFIK ---
        tanggal_kemarin = self.tanggal - timedelta(days=1)
        yesterday = KonsumsiEnergi.objects.filter(
            tanggal=tanggal_kemarin).first()

        if yesterday:
            self.selisih_pemakaian_biaya = self.total_biaya - yesterday.total_biaya
        else:
            self.selisih_pemakaian_biaya = Decimal(0)

        # --- 8: Deviasi (% dari selisih) ---
        if yesterday and yesterday.total_biaya > 0:
            self.deviasi_pemakaian_persen = (
                self.selisih_pemakaian_biaya / yesterday.total_biaya
            ) * 100
        else:
            self.deviasi_pemakaian_persen = Decimal(0)

        super().save(*args, **kwargs)
