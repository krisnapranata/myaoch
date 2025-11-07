(function () {

  // =======================================
  // ✅ Tambahan: Tunggu sampai ENERGY_SETTING siap
  // =======================================
  async function waitForEnergySetting() {
    return new Promise(resolve => {
      const interval = setInterval(() => {

        const existGlobal = (typeof window.ENERGY_SETTING !== "undefined");
        const existNode   = document.getElementById("energy-config");

        if (existGlobal || existNode) {
          clearInterval(interval);
          resolve(true);
        }

      }, 100); // cek setiap 0.1 detik
    });
  }

  // =======================================
  // ✅ Tambahan: Cek apakah ADD form
  // =======================================
  function isAddForm() {
    return window.location.pathname.includes("/add/");
  }

  // =======================================
  // ✅ Tambahan: Ambil biaya kemarin via API saat ADD
  // =======================================
  async function getBiayaKemarinByTanggal() {
    const tgl = document.getElementById("id_tanggal")?.value;
    if (!tgl) return 0;

    try {
      const res = await fetch(`/api/get-biaya-kemarin/?tanggal=${tgl}`);
      const text = await res.text();

      // kalau HTML → abort
      if (text.trim().startsWith("<")) {
        console.warn("API mengembalikan HTML, bukan JSON:", text.slice(0,80));
        return 0;
      }

      const data = JSON.parse(text);
      return data.biaya_kemarin || 0;

    } catch (err) {
      console.error("Gagal mengambil biaya kemarin:", err);
      return 0;
    }
  }

  // =======================================
  // ✅ Kode Asli Kamu (tidak diubah, hanya dipakai)
  // =======================================
  function getConfig() {

    // 1) coba global variable
    if (window.ENERGY_SETTING &&
        typeof window.ENERGY_SETTING.faktor !== "undefined") {
      return window.ENERGY_SETTING;
    }

    // 2) fallback node
    const node = document.getElementById("energy-config");
    if (!node) return null;

    return {
      faktor: parseFloat(node.dataset.faktor) || 0,
      harga_lwbp: parseFloat(node.dataset.hargaLwbp) || 0,
      harga_wbp: parseFloat(node.dataset.hargaWbp) || 0,
      total_biaya_kemarin: parseFloat(node.dataset.totalBiayaKemarin) || 0
    };
  }

  function setVal(id, value) {
    const el = document.getElementById(id);
    if (!el) return;
    if ("value" in el) el.value = value;
    else el.textContent = value;
  }

  // =======================================
  // ✅ Perhitungan utama (patch: async + tunggu config)
  // =======================================
  async function hitung() {

    // ✅ Tambahan Super Penting: tunggu ENERGY_SETTING tersedia
    await waitForEnergySetting();

    const cfg = getConfig();
    if (!cfg) return;

    // Ambil input
    const awalLWBP  = parseFloat(document.getElementById("id_stand_awal_lwbp")?.value)  || 0;
    const akhirLWBP = parseFloat(document.getElementById("id_stand_akhir_lwbp")?.value) || 0;
    const awalWBP   = parseFloat(document.getElementById("id_stand_awal_wbp")?.value)   || 0;
    const akhirWBP  = parseFloat(document.getElementById("id_stand_akhir_wbp")?.value)  || 0;

    // Hitung energi
    const pemakaianLWBP = (akhirLWBP - awalLWBP) * cfg.faktor;
    const pemakaianWBP  = (akhirWBP - awalWBP) * cfg.faktor;
    const totalEnergi   = pemakaianLWBP + pemakaianWBP;

    // Hitung biaya
    const biayaLWBP = pemakaianLWBP * cfg.harga_lwbp;
    const biayaWBP  = pemakaianWBP  * cfg.harga_wbp;
    const totalBiaya = biayaLWBP + biayaWBP;

    // Tampilkan energi
    setVal("id_pemakaian_lwbp", pemakaianLWBP.toFixed(2));
    setVal("id_pemakaian_wbp", pemakaianWBP.toFixed(2));
    setVal("id_total_pemakaian_energi", totalEnergi.toFixed(2));

    // Tampilkan biaya
    setVal("id_biaya_lwbp", biayaLWBP.toFixed(2));
    setVal("id_biaya_wbp", biayaWBP.toFixed(2));
    setVal("id_total_biaya", totalBiaya.toFixed(2));

    // =======================================
    // ✅ Selisih & Deviasi (patch ADD mode)
    // =======================================
    let totalKemarin = cfg.total_biaya_kemarin || 0;

    if (isAddForm()) {
      totalKemarin = await getBiayaKemarinByTanggal();
    }

    const selisih = totalBiaya - totalKemarin;
    const deviasi = totalKemarin > 0 ? (selisih / totalKemarin) * 100 : 0;

    setVal("id_selisih_pemakaian_biaya", selisih.toFixed(2));
    setVal("id_deviasi_pemakaian_persen", deviasi.toFixed(2));
  }

  // =======================================
  // ✅ Trigger realtime
  // =======================================
  document.addEventListener("DOMContentLoaded", hitung);
  document.addEventListener("input", function (e) {
    if (e.target.closest("form")) hitung();
  });

})();
