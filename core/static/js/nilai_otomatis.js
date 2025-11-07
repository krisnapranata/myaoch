document.addEventListener("DOMContentLoaded", function () {
  const normalField = document.querySelector("#id_jumlah_alat_normal");
  const nilaiField = document.querySelector("#id_nilai");
  const peralatanField = document.querySelector("#id_peralatan");

  let totalAlatTerakhir = null; // simpan jumlah_alat dari server
  let infoBox = null;           // elemen info peralatan (dibuat sekali)

  if (!normalField || !nilaiField || !peralatanField) {
    console.warn("⚠️ Field yang diperlukan tidak ditemukan di halaman admin.");
    return;
  }

  console.log("✅ nilai_otomatis.js loaded");

  // 1️⃣ buat box info di bawah field "Peralatan" (kalau belum ada)
  function ensureInfoBox() {
    if (infoBox) return infoBox;

    // cari wrapper row dari select peralatan (#id_peralatan)
    const peralatanRow = peralatanField.closest(".form-row, .form-row.field-peralatan, .form-row.field");
    // fallback: parent langsung
    const parent = peralatanRow || peralatanField.parentElement;

    infoBox = document.createElement("div");
    infoBox.id = "info_peralatan";
    infoBox.style.marginTop = "6px";
    infoBox.style.fontSize = "12px";
    infoBox.style.lineHeight = "1.4";
    infoBox.style.color = "#9cdcfe"; // warna biru muda cocok theme dark admin bawaan
    infoBox.style.fontFamily = "system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif";

    // isi awal
    infoBox.textContent = "ℹ️ Pilih peralatan untuk melihat detail aset aktif.";
    parent.appendChild(infoBox);

    return infoBox;
  }

  // 2️⃣ Hitung nilai otomatis + validasi
  function hitungNilai() {
    const normal = parseFloat(normalField.value) || 0;
    const total = totalAlatTerakhir || 1;
    const nilai = (normal / total) * 100;

    nilaiField.value = nilai.toFixed(2);

    // validasi batas
    if (normal > total) {
      alert(
        `⚠️ Jumlah alat normal (${normal}) tidak boleh melebihi total alat (${total})`
      );
      normalField.style.border = "2px solid red";
    } else {
      normalField.style.border = "";
    }

    console.log(
      `✅ Hitung nilai: normal=${normal}, total=${total}, hasil=${nilai.toFixed(
        2
      )}%`
    );
  }

  // 3️⃣ Ambil info jumlah_alat dari server saat peralatan dipilih
  function fetchJumlahAlat(peralatanId) {
    if (!peralatanId) return;

    console.log("📦 Peralatan dipilih:", peralatanId);

    fetch(`/ajax/get_jumlah_alat/${peralatanId}/`)
      .then((res) => res.json())
      .then((data) => {
        // simpan angka global
        totalAlatTerakhir = data.jumlah_alat || 1;

        console.log("✅ Jumlah alat aktif:", totalAlatTerakhir);

        // tampilkan info di form
        const box = ensureInfoBox();
        box.innerHTML = `
          <span style="color:#ffd700;">📦 Total alat aktif: <b>${totalAlatTerakhir}</b></span><br>
          <span style="opacity:0.8;">Masukkan jumlah alat normal/serviceable di bawah ini.</span>
        `;

        // setelah kita tahu total alatnya -> hitung ulang nilai % (kalau user sudah ngetik angka)
        hitungNilai();
      })
      .catch((err) => {
        console.error("❌ Gagal fetch jumlah alat:", err);
        const box = ensureInfoBox();
        box.textContent = "⚠️ Tidak bisa mengambil data aset peralatan.";
      });
  }

  // 4️⃣ Listener dropdown peralatan
  peralatanField.addEventListener("change", function () {
    fetchJumlahAlat(peralatanField.value);
  });

  // 5️⃣ Listener input jumlah_alat_normal
  normalField.addEventListener("input", hitungNilai);

  // 6️⃣ Inisialisasi awal kalau halaman buka dalam mode edit (bukan add)
  // kalau admin buka record existing, #id_peralatan sudah terisi
  if (peralatanField.value) {
    fetchJumlahAlat(peralatanField.value);
  } else {
    // kalau belum pilih apa-apa, buat box info biar formnya keliatan rapi
    ensureInfoBox();
  }
});
