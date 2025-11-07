document.addEventListener("DOMContentLoaded", () => {
  if (window.dashboardInitialized) return;
  window.dashboardInitialized = true;

  console.log("📊 Dashboard JS loaded (Enhanced Info Mode)");

  // === Utility: load JSON from template ===
  function getData(id) {
    try {
      return JSON.parse(document.getElementById(id).textContent);
    } catch (err) {
      console.error("❌ Gagal parse JSON untuk", id, err);
      return [];
    }
  }

  const unitStats = getData("unitStatsData");
  const kategoriData = getData("kategoriData");
  const trenData = getData("trenData");

  console.log("✅ Data loaded:", { unitStats, kategoriData, trenData });

  // === Helper ===
  function safeCreateChart(id, config) {
    const ctx = document.getElementById(id);
    if (!ctx) return;
    const existing = Chart.getChart(id);
    if (existing) existing.destroy();
    new Chart(ctx, config);
  }

  // === CHART 1: Rata-rata per unit (Dynamic Color) ===
  const unitLabels = unitStats.map(u => u.nama_unit);
  const unitValues = unitStats.map(u => u.rata_nilai);
  const barColors = unitValues.map(val => {
    if (val >= 85) return "#22c55e";
    if (val >= 70) return "#facc15";
    if (val >= 50) return "#fb923c";
    return "#ef4444";
  });

  safeCreateChart("unitChart", {
    type: "bar",
    data: {
      labels: unitLabels,
      datasets: [
        {
          label: "Rata-rata Kesiapan (%)",
          data: unitValues,
          backgroundColor: barColors,
          borderRadius: 6,
        },
      ],
    },
    options: {
      responsive: true,
      plugins: {
        legend: { display: false },
        tooltip: {
          callbacks: {
            label: (ctx) => ` ${ctx.raw.toFixed(2)}% Kesiapan`,
          },
        },
        title: {
          display: true,
          text: "Rata-rata Kesiapan per Unit",
          font: { size: 16, weight: "bold" },
        },
      },
      scales: {
        y: {
          beginAtZero: true,
          ticks: { callback: v => v + "%" },
        },
      },
    },
  });

  // === CHART 2: Distribusi Kategori (Donut + Persentase Tengah) ===
  const kategoriLabels = kategoriData.map(k => k.kategori_kesiapan);
  const kategoriValues = kategoriData.map(k => k.jumlah);
  const kategoriColors = ["#22c55e", "#facc15", "#fb923c", "#ef4444"];
  const total = kategoriValues.reduce((a, b) => a + b, 0);
  const totalText = total ? `${total} Total` : "0";

  safeCreateChart("kategoriChart", {
    type: "doughnut",
    data: {
      labels: kategoriLabels,
      datasets: [
        {
          data: kategoriValues,
          backgroundColor: kategoriColors,
          borderWidth: 1,
        },
      ],
    },
    options: {
      responsive: true,
      cutout: "70%",
      plugins: {
        legend: { position: "right" },
        tooltip: {
          callbacks: {
            label: (ctx) =>
              `${ctx.label}: ${ctx.raw} (${(
                (ctx.raw / total) *
                100
              ).toFixed(1)}%)`,
          },
        },
      },
    },
    plugins: [
      {
        id: "centerText",
        beforeDraw(chart) {
          const { ctx, chartArea } = chart;
          const centerX = (chartArea.left + chartArea.right) / 2;
          const centerY = (chartArea.top + chartArea.bottom) / 2;
          ctx.save();
          ctx.fillStyle = "#111827";
          ctx.font = "bold 16px Segoe UI";
          ctx.textAlign = "center";
          ctx.fillText(totalText, centerX, centerY);
        },
      },
    ],
  });

  // === CHART 3: Tren Kesiapan (Line + Delta) ===
  const trenLabels = trenData.map(t =>
    new Date(t.tanggal).toLocaleDateString("id-ID", { weekday: "short", day: "2-digit" })
  );
  const trenValues = trenData.map(t => t.avg_nilai);

  safeCreateChart("trenChart", {
    type: "line",
    data: {
      labels: trenLabels,
      datasets: [
        {
          label: "Rata-rata Harian (%)",
          data: trenValues,
          borderColor: "#2563eb",
          backgroundColor: "rgba(37,99,235,0.2)",
          fill: true,
          tension: 0.25,
          pointRadius: 4,
          pointBackgroundColor: "#2563eb",
        },
      ],
    },
    options: {
      responsive: true,
      plugins: {
        legend: { display: true },
        tooltip: {
          callbacks: {
            label: (ctx) => {
              const idx = ctx.dataIndex;
              const prev = idx > 0 ? trenValues[idx - 1] : ctx.raw;
              const delta = (ctx.raw - prev).toFixed(2);
              const sign = delta >= 0 ? "📈 +" : "📉 ";
              return ` ${ctx.raw.toFixed(2)}% (${sign}${Math.abs(delta)}%)`;
            },
          },
        },
        title: {
          display: true,
          text: "Tren Kesiapan (7 Hari Terakhir)",
          font: { size: 16, weight: "bold" },
        },
      },
      scales: {
        y: {
          beginAtZero: true,
          ticks: { callback: v => v + "%" },
        },
      },
    },
  });
});
