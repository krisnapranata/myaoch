// document.addEventListener("DOMContentLoaded", () => {
  window.addEventListener("load", () => {
  console.log("📊 MyAoCH Dashboard v3.5 Loaded (AI Predictive)");

  const parseJSON = (id) =>
    JSON.parse(document.getElementById(id)?.textContent || "[]");

  const unitStats = parseJSON("unitStatsData");
  const kategoriData = parseJSON("kategoriData");
  const trenData = parseJSON("trenData");
  const heatmapData = parseJSON("heatmapData");

  const ctx = (id) => document.getElementById(id)?.getContext("2d");
  const safeChart = (id, cfg) => {
    const chart = Chart.getChart(id);
    if (chart) chart.destroy();
    return new Chart(ctx(id), cfg);
  };

  // 🌐 Global Chart.js Responsive Settings
  // Chart.defaults.responsive = true;
  // Chart.defaults.maintainAspectRatio = false;
  // Chart.defaults.resizeDelay = 0; // supaya chart resize cepat di mobile

  // 🧩 Global Chart.js Fix agar tidak membengkak
  Chart.defaults.responsive = true;
  Chart.defaults.maintainAspectRatio = true;
  Chart.defaults.aspectRatio = 1.6; // rasio default: lebar > tinggi
  Chart.defaults.resizeDelay = 0;

  // // 1️⃣ Bar Chart (Unit)
  // safeChart("unitChart", {
  //   type: "bar",
  //   data: {
  //     labels: unitStats.map((u) => u.nama_unit),
  //     datasets: [
  //       {
  //         label: "Kesiapan (%)",
  //         data: unitStats.map((u) => u.rata_nilai),
  //         backgroundColor: unitStats.map((v) =>
  //           v.rata_nilai >=  80
  //             ? "#16a34a"
  //             : v.rata_nilai >= 60
  //             ? "#facc15"
  //             : v.rata_nilai >= 40
  //             ? "#fb923c"
  //             : "#dc2626"
  //         ),
  //       },
  //     ],
  //   },
  //   options: {
  //     plugins: {
  //       title: { display: true, text: "Rata-rata Kesiapan per Unit" },
  //     },
  //     scales: { y: { beginAtZero: true, max: 100 } },
  //   },
  // });

  // 1️⃣ Bar Chart (Unit) — tampilkan angka persentase di atas batang
  safeChart("unitChart", {
  type: "bar",
  data: {
    labels: unitStats.map((u) => u.nama_unit),
    datasets: [
      {
        label: "Kesiapan (%)",
        data: unitStats.map((u) => u.rata_nilai),
        backgroundColor: unitStats.map((v) =>
          v.rata_nilai >= 80
            ? "#16a34a"
            : v.rata_nilai >= 60
            ? "#facc15"
            : v.rata_nilai >= 40
            ? "#fb923c"
            : "#dc2626"
        ),
      },
    ],
  },
  options: {
    responsive: true,
    maintainAspectRatio: true,
    plugins: {
      title: {
        display: true,
        text: "Rata-rata Kesiapan per Unit",
        font: { size: 14 },
      },
      tooltip: { enabled: true },

      // ✅ Angka turun, tidak menempel dengan judul
      datalabels: {
        display: true,
        color: "#111827",
        anchor: "end",
        align: "top",
        offset: 2,     // ✅ angka turun sedikit
        font: { weight: "bold", size: 10 },
        formatter: (value) => Math.round(value) + "%",
      },
    },

    // ✅ Bar dan angka turun dengan memperluas Y axis
    scales: {
      y: {
        beginAtZero: true,
        suggestedMax: 120,   // ✅ Tambah ruang 20% di atas
      },
    },
  },
  plugins: [ChartDataLabels],
});

  // 3️⃣ Tren Line Chart
  console.log("🔍 Tren Data dari Django:", trenData);
  const trenLabels = trenData.map((t) =>
    new Date(t.tgl_agg).toLocaleDateString("id-ID", {
      weekday: "short",
      day: "2-digit",
      month: "short",
    })
  );
  const trenValues = trenData.map((t) => parseFloat(t.avg_nilai));

  safeChart("trenChart", {
    type: "line",
    data: {
      labels: trenLabels,
      datasets: [
        {
          label: "Rata-rata Harian",
          data: trenValues,
          borderColor: "#2563eb",
          backgroundColor: "rgba(37,99,235,0.25)",
          fill: true,
          tension: 0.25,
          pointRadius: 4,
          pointBackgroundColor: "#2563eb",
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        title: {
          display: true,
          text: "Tren Kesiapan Operasional (7 Hari Terakhir)",
        },
        tooltip: {
          callbacks: {
            label: (ctx) => {
              const prev = trenValues[ctx.dataIndex - 1] ?? ctx.raw;
              const delta = (ctx.raw - prev).toFixed(2);
              const trend = delta >= 0 ? "📈 Naik" : "📉 Turun";
              return `${ctx.raw.toFixed(2)}% (${trend} ${Math.abs(delta)}%)`;
            },
          },
        },
        // 🎯 Tambahkan angka di atas titik (DataLabels plugin)
        datalabels: {
          display: true,
          align: "top",
          anchor: "end",
          offset: 6, // jarak sedikit di atas titik
          color: "#111827", // abu gelap
          font: {
            weight: "bold",
            size: 11,
          },
          formatter: (val) => val.toFixed(1) + "%",
        },
      },
      scales: {
        y: { beginAtZero: true, max: 100 },
      },
    },
    plugins: [ChartDataLabels], // aktifkan plugin di sini
  });

  // 🤖 3.1 Analisis Tren + Prediksi AI (Realtime, tidak membuat box baru)
  if (trenValues.length >= 2) {
    const firstVal = trenValues[0];
    const lastVal = trenValues[trenValues.length - 1];
    const deltaTotal = (lastVal - firstVal).toFixed(2);
    const trend = deltaTotal >= 0 ? "naik" : "turun";

    // 🔹 Regresi linear sederhana
    const n = trenValues.length;
    const x = Array.from({ length: n }, (_, i) => i + 1);
    const meanX = x.reduce((a, b) => a + b, 0) / n;
    const meanY = trenValues.reduce((a, b) => a + b, 0) / n;
    const num = x.map((xi, i) => (xi - meanX) * (trenValues[i] - meanY)).reduce((a, b) => a + b, 0);
    const den = x.map((xi) => Math.pow(xi - meanX, 2)).reduce((a, b) => a + b, 0);
    const slope = num / den;
    const nextPred = meanY + slope * (n + 1 - meanX);
    const deltaPred = (nextPred - lastVal).toFixed(2);

    // 🧠 Teks insight
    const insightText = `
      <strong>Analisis Tren:</strong> Kesiapan <b>${trend}</b> sebesar <b>${Math.abs(deltaTotal)}%</b> selama 7 hari terakhir.<br>
      <strong>Prediksi Otomatis:</strong> Berdasarkan tren linear, kesiapan besok diperkirakan 
      <b>${deltaPred >= 0 ? "naik" : "turun"}</b> ke <b>${nextPred.toFixed(2)}%</b> 
      (${deltaPred >= 0 ? "📈" : "📉"} ${Math.abs(deltaPred)}%).
    `;

    // 🔄 Update box yang sudah ada
    const insightBox = document.getElementById("aiInsightPred");
    if (insightBox) {
      insightBox.querySelector("p").innerHTML = insightText;
    }
  }

  // =============================================
  // ✅ Chart Konsumsi Energi 7 Hari
  // =============================================
  // === ✅ Konsumsi Energi 7 Hari (Bar + Line Combo Chart) ===
  (function () {
    console.log("✅ Energy 7-day charts loading...");

    const el = document.getElementById("energyData");
    if (!el) return;

    let data = JSON.parse(el.textContent || "[]");
    if (!data.length) return;

    const labels = data.map(d => d.tanggal);
    const energi = data.map(d => d.total_pemakaian);
    const biaya = data.map(d => d.total_biaya);

    // ================================
    // ✅ Chart 1 — Energi (kWh)
    // ================================
    const ctx1 = document.getElementById("energy7_kwh").getContext("2d");
    if (Chart.getChart("energy7_kwh")) Chart.getChart("energy7_kwh").destroy();

    new Chart(ctx1, {
        type: "bar",
        data: {
            labels: labels,
            datasets: [{
                label: "Total Energi (kWh)",
                data: energi,
                backgroundColor: "#3b82f6",
            }]
        },
        options: {
            indexAxis: "y", // ✅ horizontal bar
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                datalabels: {
                    color: "white",
                    anchor: "center",
                    align: "center",
                    formatter: v => v.toLocaleString("id-ID") + " kWh"
                }
            },
            scales: {
                x: {
                    beginAtZero: true
                }
            }
        },
        plugins: [ChartDataLabels]
    });

    // ================================
    // ✅ Chart 2 — Biaya (Rp)
    // ================================
    const ctx2 = document.getElementById("energy7_cost").getContext("2d");
    if (Chart.getChart("energy7_cost")) Chart.getChart("energy7_cost").destroy();

    new Chart(ctx2, {
        type: "bar",
        data: {
            labels: labels,
            datasets: [{
                label: "Total Biaya (Rp)",
                data: biaya,
                backgroundColor: "#10b981",
            }]
        },
        options: {
            indexAxis: "y", // ✅ horizontal bar
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                datalabels: {
                    color: "white",
                    anchor: "center",
                    align: "center",
                    formatter: v => "Rp " + v.toLocaleString("id-ID")
                }
            },
            scales: {
                x: {
                    beginAtZero: true,
                    ticks: {
                        callback: v => "Rp " + v.toLocaleString("id-ID")
                    }
                }
            }
        },
        plugins: [ChartDataLabels]
    });

})();
//   (function () {
//     console.log("✅ Energy chart load attempt...");

//     const el = document.getElementById("energyData");
//     if (!el) return console.warn("⚠️ energyData tidak ditemukan.");

//     let data = [];
//     try {
//         data = JSON.parse(el.textContent);
//     } catch (err) {
//         console.error("❌ Gagal parse energyData:", err);
//         return;
//     }

//     if (!data.length) return console.warn("⚠️ energyData kosong.");

//     const labels  = data.map(d => d.tanggal);
//     const energi  = data.map(d => d.total_pemakaian);
//     const biaya   = data.map(d => d.total_biaya);

//     const canvas = document.getElementById("energyChart7");
//     if (!canvas) return console.warn("⚠️ Canvas energyChart7 tidak ditemukan.");

//     const ctx = canvas.getContext("2d");
//     const old = Chart.getChart("energyChart7");
//     if (old) old.destroy();

//     new Chart(ctx, {
//         type: "bar",

//         // ✅ UBAH ARAH CHART JADI HORIZONTAL
//         options: {
//             indexAxis: "y",
//             responsive: true,
//             maintainAspectRatio: false,

//             plugins: {
//                 title: {
//                     display: true,
//                     text: "Konsumsi Energi — 7 Hari Terakhir"
//                 },
//                 tooltip: {
//                     callbacks: {
//                         label: function (ctx) {
//                             const lbl = ctx.dataset.label + ": ";
//                             const val = ctx.raw;

//                             if (ctx.dataset.label.includes("Rp"))
//                                 return lbl + "Rp " + val.toLocaleString("id-ID");

//                             if (ctx.dataset.label.includes("kWh"))
//                                 return lbl + val.toLocaleString("id-ID") + " kWh";

//                             return lbl + val;
//                         }
//                     }
//                 }
//             },

//             interaction: { mode: "index", intersect: false },

//             scales: {
//                 xBiaya: {
//                     position: "bottom",
//                     title: { display: true, text: "Rupiah" },
//                     ticks: {
//                         callback: v => "Rp " + v.toLocaleString("id-ID")
//                     }
//                 },
//                 xEnergi: {
//                     position: "top",
//                     grid: { drawOnChartArea: false },
//                     title: { display: true, text: "kWh" },
//                     ticks: {
//                         callback: v => v.toLocaleString("id-ID") + " kWh"
//                     }
//                 }
//             }
//         },

//         data: {
//             labels: labels,
//             datasets: [
//                 {
//                     label: "Total Biaya (Rp)",
//                     data: biaya,
//                     backgroundColor: "#10b981",
//                     xAxisID: "xBiaya",
//                     order: 1
//                 },
//                 {
//                     label: "Total Energi (kWh)",
//                     data: energi,
//                     backgroundColor: "#3b82f6",
//                     xAxisID: "xEnergi",
//                     order: 2
//                 }
//             ]
//         }
//     });

//     console.log("✅ Energy chart horizontal berhasil dirender!");
// })();



  // 4️⃣ Top & Bottom Unit Hari Ini
  // const sortedUnits = [...unitStats].sort((a, b) => b.rata_nilai - a.rata_nilai);
  // const top5 = sortedUnits.slice(0, 5);
  // const bottom5 = sortedUnits.slice(-5).reverse();

  // safeChart("heatmapChart", {
  //   type: "bar",
  //   data: {
  //     labels: top5.map(u => u.nama_unit),
  //     datasets: [{
  //       label: "Top 5 Kesiapan Hari Ini",
  //       data: top5.map(u => u.rata_nilai),
  //       backgroundColor: "#16a34a"
  //     }]
  //   },
  //   options: {
  //     plugins: {
  //       title: {
  //         display: true,
  //         text: "🏆 Top 5 Unit dengan Kesiapan Tertinggi Hari Ini"
  //       }
  //     },
  //     scales: { y: { beginAtZero: true, max: 100 } }
  //   }
  // });

  
  // // === 4️⃣ Prediksi Risiko Operasional ===
  // const ctxForecast = document.getElementById("heatmapChart"); // gunakan chart4 yang sudah ada

  // if (Chart.getChart("heatmapChart")) Chart.getChart("heatmapChart").destroy();

  // // Siapkan data
  // //const forecastData = data.forecast_risk;
  // const forecastEl = document.getElementById("forecastData");
  // const forecastData = JSON.parse(forecastEl?.textContent || "[]");
  // const units = [...new Set(forecastData.map(d => d.nama_unit))];
  // const colorScale = val => {
  //   // Risiko 0-100 => hijau ke merah
  //   const r = Math.min(255, Math.round((val / 100) * 255));
  //   const g = Math.min(255, Math.round(255 - (val / 100) * 255));
  //   return `rgba(${r},${g},0,0.8)`;
  // };

  // // Ubah data jadi titik-titik untuk Chart.js
  // const chartPoints = forecastData.map(d => ({
  //   x: d.jam_ke,
  //   y: units.indexOf(d.nama_unit),
  //   r: 10, // ukuran bubble
  //   backgroundColor: colorScale(d.prediksi_risiko),
  //   pred_risk: d.prediksi_risiko,
  //   unit: d.nama_unit
  // }));

  // === 4️⃣ Prediksi Risiko Operasional (AI Heatmap + Trendline) ===
  // const ctxForecast = document.getElementById("heatmapChart");
  // if (!ctxForecast) {
  //   console.warn("⚠️ Tidak ada canvas heatmapChart di halaman!");
  // } else {
  //   // Hapus chart lama
  //   const oldChart = Chart.getChart("heatmapChart");
  //   if (oldChart) oldChart.destroy();

  //   // Ambil data dari JSON Django
  //   const forecastEl = document.getElementById("forecastData");
  //   const forecastData = JSON.parse(forecastEl?.textContent || "[]");
  //   if (!forecastData.length) {
  //     console.warn("⚠️ Data forecast_risk_real kosong!");
  //   }

  //   // Ambil daftar unit unik
  //   const units = [...new Set(forecastData.map((d) => d.nama_unit))];

  //   // Warna risiko: hijau → kuning → merah
  //   const colorScale = (val) => {
  //     const hue = (100 - val) * 1.2; // 0 merah, 120 hijau
  //     return `hsl(${hue}, 80%, 50%)`;
  //   };

  //   // Buat titik bubble untuk chart
  //   const chartPoints = forecastData.map((d) => ({
  //     x: d.jam_ke,
  //     y: units.indexOf(d.nama_unit),
  //     r: Math.max(6, d.prediksi_risiko / 10), // ukuran bubble proporsional risiko
  //     backgroundColor: colorScale(d.prediksi_risiko),
  //     pred_risk: d.prediksi_risiko,
  //     unit: d.nama_unit,
  //   }));

  //   // Hitung rata-rata risiko per jam (untuk trendline)
  //   const avgRiskPerHour = [];
  //   for (let jam = 0; jam <= 24; jam++) {
  //     const subset = forecastData.filter((d) => d.jam_ke === jam);
  //     if (subset.length) {
  //       const avg =
  //         subset.reduce((sum, d) => sum + d.prediksi_risiko, 0) / subset.length;
  //       avgRiskPerHour.push(avg.toFixed(2));
  //     } else {
  //       avgRiskPerHour.push(null);
  //     }
  //   }

  //   // Buat chart bubble + trendline
  //   const heatChart = new Chart(ctxForecast, {
  //     type: "bubble",
  //     data: {
  //       datasets: [
  //         {
  //           label: "Prediksi Risiko Operasional 24 Jam",
  //           data: chartPoints,
  //           backgroundColor: chartPoints.map((p) => p.backgroundColor),
  //           borderColor: "rgba(255,255,255,0.3)",
  //           borderWidth: 1,
  //           parsing: false,
  //         },
  //         {
  //           type: "line",
  //           label: "Tren Rata-rata Risiko",
  //           data: avgRiskPerHour,
  //           borderColor: "#2563eb",
  //           borderWidth: 2,
  //           fill: false,
  //           tension: 0.3,
  //           pointRadius: 0,
  //         },
  //       ],
  //     },
  //     options: {
  //       responsive: true,
  //       scales: {
  //         x: {
  //           title: { display: true, text: "Jam ke depan" },
  //           ticks: { stepSize: 2, max: 24 },
  //           grid: { color: "rgba(0,0,0,0.05)" },
  //         },
  //         y: {
  //           title: { display: true, text: "Unit" },
  //           ticks: {
  //             callback: (val) => units[val] || "",
  //             stepSize: 1,
  //           },
  //           min: -0.5,
  //           max: units.length - 0.5,
  //           grid: { color: "rgba(0,0,0,0.05)" },
  //         },
  //       },
  //       plugins: {
  //         title: {
  //           display: true,
  //           text: "🤖 Prediksi Risiko Operasional (AI Heatmap + Tren Rata-rata)",
  //           font: { size: 14 },
  //         },
  //         tooltip: {
  //           callbacks: {
  //             label: (ctx) =>
  //               `${ctx.raw.unit || "Unit tidak diketahui"} — Jam ke-${
  //                 ctx.raw.x
  //               }: ${ctx.raw.pred_risk?.toFixed(1)}% risiko`,
  //           },
  //         },
  //         legend: { position: "top" },
  //       },
  //     },
  //   });

  //   // === Tambah legenda warna manual (jika belum ada) ===
  //   if (!document.querySelector(".legend-risk")) {
  //     const legend = document.createElement("div");
  //     legend.className = "legend-risk";
  //     legend.innerHTML = `
  //       <div class="legend-item"><span style="background:#16a34a"></span> Rendah (0–30%)</div>
  //       <div class="legend-item"><span style="background:#facc15"></span> Sedang (31–60%)</div>
  //       <div class="legend-item"><span style="background:#dc2626"></span> Tinggi (61–100%)</div>
  //     `;
  //     ctxForecast.parentNode.appendChild(legend);
  //   }
  // }

  // === 4️⃣ Prediksi Readiness Besok per Unit (AI Forecast) ASLI===
  // window.renderForecastBarChart = function renderForecastBarChart(unitStats) {
  //   if (!unitStats || !unitStats.length) {
  //     console.warn("⚠️ Data unitStats kosong untuk prediksi readiness besok.");
  //     return;
  //   }

  //   // Prediksi sederhana pakai model linear (2 hari terakhir)
  //   const forecastData = unitStats.map((u) => {
  //     const nama = u.nama_unit;
  //     const nilai = parseFloat(u.rata_nilai);

  //     // Simulasi tren (karena kita belum punya tren per unit)
  //     // Kamu bisa ganti pakai data historis kalau tersedia
  //     // const delta = Math.random() * 10 - 5; // ±5% fluktuasi
  //     const direction = Math.random() > 0.5 ? 1 : -1;
  //     const magnitude = Math.random() * 5; // perubahan maksimal 5%
  //     const delta = direction * magnitude;
  //     const prediksi_besok = Math.max(0, Math.min(100, nilai + delta));

  //     return {
  //       nama_unit: nama,
  //       hari_ini: nilai,
  //       besok: prediksi_besok,
  //       arah: delta >= 0 ? "naik" : "turun",
  //       perubahan: delta.toFixed(1),
  //     };
  //   });

  //   const ctx = document.getElementById("forecastBarChart");
  //   if (!ctx) return;

  //   // Hapus chart lama jika ada
  //   const oldChart = Chart.getChart("forecastBarChart");
  //   if (oldChart) oldChart.destroy();

  //   const labels = forecastData.map((d) => d.nama_unit);
  //   const todayValues = forecastData.map((d) => d.hari_ini);
  //   const tomorrowValues = forecastData.map((d) => d.besok);
  //   const colors = forecastData.map((d) =>
  //     d.arah === "naik" ? "#16a34a" : "#dc2626"
  //   );

  //   // Chart double bar (Hari ini vs Besok)
  //   new Chart(ctx, {
  //     type: "bar",
  //     data: {
  //       labels: labels,
  //       datasets: [
  //         {
  //           label: "Hari Ini",
  //           data: todayValues,
  //           backgroundColor: "#93c5fd",
  //         },
  //         {
  //           label: "Prediksi Besok",
  //           data: tomorrowValues,
  //           backgroundColor: colors,
  //         },
  //       ],
  //     },
  //     options: {
  //       responsive: true,
  //       maintainAspectRatio: true,
  //       plugins: {
  //         title: {
  //           display: true,
  //           text: "📈 Prediksi Readiness Besok per Unit",
  //         },
  //         tooltip: {
  //           callbacks: {
  //             label: (ctx) => {
  //               const d = forecastData[ctx.dataIndex];
  //               return ctx.dataset.label === "Hari Ini"
  //                 ? `${ctx.dataset.label}: ${d.hari_ini.toFixed(1)}%`
  //                 : `${ctx.dataset.label}: ${d.besok.toFixed(1)}% (${
  //                     d.arah === "naik" ? "📈" : "📉"
  //                   } ${Math.abs(d.perubahan)}%)`;
  //             },
  //           },
  //         },
  //         legend: {
  //           position: "bottom",
  //         },
  //       },
  //       scales: {
  //         y: {
  //           beginAtZero: true,
  //           max: 100,
  //           title: { display: true, text: "Persentase Readiness (%)" },
  //         },
  //       },
  //     },
  //   });
  // }

  // // ===================================================
  // // 🤖 AI FORECAST v2.0 — Hybrid Model (Trend + Stability)
  // // ===================================================
  // window.renderForecastBarChart = async function renderForecastBarChart(unitStats) {
  //   if (!unitStats || !unitStats.length) {
  //     console.warn("⚠️ Data unitStats kosong untuk prediksi readiness besok.");
  //     return;
  //   }

  //   // 🧩 Fungsi bantu: moving average (rata-rata n data terakhir)
  //   function movingAverage(arr, n = 3) {
  //     if (!Array.isArray(arr) || arr.length === 0) return 0;
  //     const recent = arr.slice(-n);
  //     return recent.reduce((a, b) => a + b, 0) / recent.length;
  //   }

  //   // 🧩 Fungsi bantu: linear regression sederhana (AI Tren)
  //   function linearRegressionPredict(history) {
  //     if (!Array.isArray(history) || history.length < 2) return history.at(-1) || 0;
  //     const n = history.length;
  //     const x = Array.from({ length: n }, (_, i) => i + 1);
  //     const y = history.map(parseFloat);

  //     const meanX = x.reduce((a, b) => a + b) / n;
  //     const meanY = y.reduce((a, b) => a + b) / n;
  //     const numerator = x.reduce((a, xi, i) => a + (xi - meanX) * (y[i] - meanY), 0);
  //     const denominator = x.reduce((a, xi) => a + Math.pow(xi - meanX, 2), 0);
  //     const slope = denominator !== 0 ? numerator / denominator : 0;
  //     const intercept = meanY - slope * meanX;
  //     const next = intercept + slope * (n + 1);
  //     return Math.max(0, Math.min(100, next)); // clamp 0–100
  //   }

  //   // 🧩 Hybrid Forecast
  //   const forecastData = unitStats.map((u) => {
  //     const nama = u.nama_unit;

  //     // Data historis readiness per unit (nanti bisa dari backend API)
  //     const history = Array.isArray(u.history)
  //       ? u.history
  //       : [
  //           u.rata_nilai - 4 + Math.random() * 2,
  //           u.rata_nilai - 2 + Math.random() * 2,
  //           u.rata_nilai - 1 + Math.random() * 1,
  //           u.rata_nilai,
  //         ];

  //     const nilai_hari_ini = parseFloat(history.at(-1));
  //     const pred_linear = linearRegressionPredict(history);
  //     const pred_moving = movingAverage(history, 3);

  //     // 🧮 Kombinasi AI hybrid (70% tren + 30% stabilitas)
  //     const prediksi_besok = (pred_linear * 0.7 + pred_moving * 0.3).toFixed(1);

  //     return {
  //       nama_unit: nama,
  //       hari_ini: nilai_hari_ini,
  //       besok: parseFloat(prediksi_besok),
  //       arah: pred_linear >= nilai_hari_ini ? "naik" : "turun",
  //       perubahan: (prediksi_besok - nilai_hari_ini).toFixed(1),
  //     };
  //   });

  //   const ctx = document.getElementById("forecastBarChart");
  //   if (!ctx) return;

  //   // 🔁 Hapus chart lama
  //   const oldChart = Chart.getChart("forecastBarChart");
  //   if (oldChart) oldChart.destroy();

  //   const labels = forecastData.map((d) => d.nama_unit);
  //   const todayValues = forecastData.map((d) => d.hari_ini);
  //   const tomorrowValues = forecastData.map((d) => d.besok);
  //   const colors = forecastData.map((d) =>
  //     d.arah === "naik" ? "#16a34a" : "#dc2626"
  //   );

  //   // 📊 Buat Chart Baru
  //   new Chart(ctx, {
  //     type: "bar",
  //     data: {
  //       labels,
  //       datasets: [
  //         {
  //           label: "Hari Ini",
  //           data: todayValues,
  //           backgroundColor: "#93c5fd",
  //         },
  //         {
  //           label: "Prediksi Besok (AI Hybrid)",
  //           data: tomorrowValues,
  //           backgroundColor: colors,
  //         },
  //       ],
  //     },
  //     options: {
  //       responsive: true,
  //       maintainAspectRatio: true,
  //       plugins: {
  //         title: {
  //           display: true,
  //           text: "🤖 AI Forecast v2.0 — Prediksi Readiness Besok (Hybrid Model)",
  //         },
  //         legend: { position: "bottom" },
  //         tooltip: {
  //           callbacks: {
  //             label: (ctx) => {
  //               const d = forecastData[ctx.dataIndex];
  //               return ctx.dataset.label === "Hari Ini"
  //                 ? `Hari Ini: ${d.hari_ini.toFixed(1)}%`
  //                 : `Prediksi Besok: ${d.besok.toFixed(1)}% (${
  //                     d.arah === "naik" ? "📈" : "📉"
  //                   } ${Math.abs(d.perubahan)}%)`;
  //             },
  //           },
  //         },
  //       },
  //       scales: {
  //         y: {
  //           beginAtZero: true,
  //           max: 100,
  //           title: { display: true, text: "Persentase Readiness (%)" },
  //         },
  //       },
  //     },
  //   });
  // };


  // konsumsi energi hari ini
  window.renderEnergyTodayChart = function (energyData) {
    if (!energyData || !energyData.length) return;

    const today = energyData[energyData.length - 1];
    const yesterday = energyData.length > 1 ? energyData[energyData.length - 2] : today;

    const energi = today.total_pemakaian || 0;
    const biayaToday = today.total_biaya || 0;
    const biayaYesterday = yesterday.total_biaya || 0;

    const selisih = biayaToday - biayaYesterday;
    const deviasi = biayaYesterday > 0 ? (selisih / biayaYesterday) * 100 : 0;

    // ===========================
    // RESPONSIVE FONT
    // ===========================
    const FONT_SIZE = window.innerWidth < 600 ? 10 : 13;

    Chart.defaults.font.size = FONT_SIZE;

    // Update BOX UI
    document.getElementById("costToday").textContent = "Rp " + biayaToday.toLocaleString("id-ID");
    document.getElementById("costYesterday").textContent = "Rp " + biayaYesterday.toLocaleString("id-ID");
    document.getElementById("selisihValue").textContent = "Rp " + selisih.toLocaleString("id-ID");
    document.getElementById("deviasiValue").textContent = deviasi.toFixed(2) + "%";

    const explain = document.getElementById("explainBox");
    const s = Math.abs(selisih).toLocaleString("id-ID");

    if (selisih < 0) {
        explain.innerHTML = `
            🧵 Hari ini terjadi <b class="text-red">penurunan biaya</b> sebesar 
            <b class="text-red">Rp ${s}</b> dibandingkan kemarin.<br>
            Deviasi <b class="text-red">${deviasi.toFixed(2)}%</b>.
        `;
    } else if (selisih > 0) {
        explain.innerHTML = `
            📈 Hari ini terjadi <b class="text-green">kenaikan biaya</b> sebesar 
            <b class="text-green">Rp ${s}</b> dibandingkan kemarin.<br>
            Deviasi <b class="text-green">${deviasi.toFixed(2)}%</b>.
        `;
    } else {
        explain.innerHTML = `✅ Biaya energi hari ini sama seperti kemarin.`;
    }

    // RENDER CHART
    const ctx = document.getElementById("energyBarChart");
    if (!ctx) return;

    const existing = Chart.getChart("energyBarChart");
    if (existing) existing.destroy();

    new Chart(ctx, {
        type: "bar",
        data: {
            labels: ["Hari Ini"],
            datasets: [
                {
                    label: "Total Energi (kWh)",
                    data: [energi],
                    backgroundColor: "#3b82f6",
                    yAxisID: "yEnergi"
                },
                {
                    label: "Total Biaya (Rp)",
                    data: [biayaToday],
                    backgroundColor: "#10b981",
                    yAxisID: "yBiaya"
                }
            ]
        },
        plugins: [ChartDataLabels],
        options: {
            responsive: true,
            maintainAspectRatio: false,  // ✅ agar mobile rapi
            plugins: {
                legend: { position: "bottom" },
                datalabels: {
                    anchor: "center",
                    align: "center",
                    color: "white",
                    font: { weight: "bold", size: window.innerWidth < 600 ? 8 : 12 },
                    formatter: (value, ctx) => {
                        if (ctx.dataset.label.includes("Energi"))
                            return value.toLocaleString("id-ID") + " kWh";
                        return "Rp " + value.toLocaleString("id-ID");
                    }
                }
            },
            //layout: {
            //    padding: { right: 30 }   // ⭐ menampilkan angka Rupiah di mobile
            //},
            scales: {
                yEnergi: {
                    position: "left",
                    title: { display: true, text: "kWh" },
                    ticks: {
                        callback: v => v.toLocaleString("id-ID")
                    }
                },
                yBiaya: {
                    //display: window.innerWidth > 600,   // ✅ hilangkan axis kanan di HP
                    position: "right",
                    //offset: true,         // ✅ PAKSA tampil di layar kecil
                    grid: { drawOnChartArea: false },
                    ticks: {
                        callback: v => "Rp " + v.toLocaleString("id-ID")
                    },
                    title: { display: true, //text: "Rupiah" 
                      }
                }
            }
        }
    });
};

  // === 4️⃣ Prediksi Readiness Besok per Unit (AI Forecast v3.6 Linear) ===
  // window.renderForecastBarChart = function renderForecastBarChart(unitStats, trenData = []) {
  //   if (!unitStats || !unitStats.length) {
  //     console.warn("⚠️ Data unitStats kosong untuk prediksi readiness besok.");
  //     return;
  //   }

  //   // 🔹 Map tren_data per unit (jika tersedia)
  //   const trenMap = {};
  //   if (trenData && trenData.length) {
  //     trenData.forEach((t) => {
  //       if (!trenMap[t.nama_unit]) trenMap[t.nama_unit] = [];
  //       trenMap[t.nama_unit].push(parseFloat(t.avg_nilai));
  //     });
  //   }

  //   // 🔹 Hitung prediksi linear untuk setiap unit
  //   const forecastData = unitStats.map((u) => {
  //     const nama = u.nama_unit;
  //     const nilai = parseFloat(u.rata_nilai);

  //     const history = trenMap[nama] || [];
  //     let slope = 0;

  //     if (history.length >= 2) {
  //       const n = history.length;
  //       const x = Array.from({ length: n }, (_, i) => i + 1);
  //       const meanX = x.reduce((a, b) => a + b, 0) / n;
  //       const meanY = history.reduce((a, b) => a + b, 0) / n;
  //       const num = x.map((xi, i) => (xi - meanX) * (history[i] - meanY)).reduce((a, b) => a + b, 0);
  //       const den = x.map((xi) => Math.pow(xi - meanX, 2)).reduce((a, b) => a + b, 0);
  //       slope = num / den; // tren per hari
  //     }

  //     const prediksi_besok = Math.max(0, Math.min(100, nilai + slope));
  //     const arah = slope >= 0 ? "naik" : "turun";
  //     const perubahan = slope.toFixed(2);

  //     return {
  //       nama_unit: nama,
  //       hari_ini: nilai,
  //       besok: prediksi_besok,
  //       arah,
  //       perubahan,
  //     };
  //   });

  //   // 🎨 Render ke chart
  //   const ctx = document.getElementById("forecastBarChart");
  //   if (!ctx) return;

  //   const oldChart = Chart.getChart("forecastBarChart");
  //   if (oldChart) oldChart.destroy();

  //   const labels = forecastData.map((d) => d.nama_unit);
  //   const todayValues = forecastData.map((d) => d.hari_ini);
  //   const tomorrowValues = forecastData.map((d) => d.besok);
  //   const colors = forecastData.map((d) =>
  //     d.arah === "naik" ? "#16a34a" : "#dc2626"
  //   );

  //   new Chart(ctx, {
  //     type: "bar",
  //     data: {
  //       labels: labels,
  //       datasets: [
  //         {
  //           label: "Hari Ini",
  //           data: todayValues,
  //           backgroundColor: "#93c5fd",
  //         },
  //         {
  //           label: "Prediksi Besok",
  //           data: tomorrowValues,
  //           backgroundColor: colors,
  //         },
  //       ],
  //     },
  //     options: {
  //       responsive: true,
  //       maintainAspectRatio: true,
  //       plugins: {
  //         title: {
  //           display: true,
  //           text: "🤖 Prediksi Readiness Besok per Unit (AI Linear Forecast)",
  //           font: { size: 14 },
  //         },
  //         tooltip: {
  //           callbacks: {
  //             label: (ctx) => {
  //               const d = forecastData[ctx.dataIndex];
  //               return ctx.dataset.label === "Hari Ini"
  //                 ? `${ctx.dataset.label}: ${d.hari_ini.toFixed(1)}%`
  //                 : `${ctx.dataset.label}: ${d.besok.toFixed(1)}% (${d.arah === "naik" ? "📈" : "📉"} ${Math.abs(d.perubahan)}%)`;
  //             },
  //           },
  //         },
  //         legend: { position: "bottom" },
  //       },
  //       scales: {
  //         y: {
  //           beginAtZero: true,
  //           max: 100,
  //           title: { display: true, text: "Persentase Readiness (%)" },
  //         },
  //       },
  //     },
  //   });
  // };

  // new Chart(ctxForecast, {
  //   type: "bubble",
  //   data: {
  //     datasets: [{
  //       label: "Prediksi Risiko Operasional 24 Jam",
  //       data: chartPoints,
  //       parsing: false,
  //       backgroundColor: chartPoints.map(p => colorScale(p.pred_risk)),
  //     }]
  //   },
  //   options: {
  //     responsive: true,
  //     scales: {
  //       x: {
  //         title: { display: true, text: "Jam ke depan" },
  //         ticks: { stepSize: 2, max: 24 }
  //       },
  //       y: {
  //         title: { display: true, text: "Unit" },
  //         ticks: {
  //           callback: val => units[val] || "",
  //           stepSize: 1
  //         },
  //         min: -0.5,
  //         max: units.length - 0.5
  //       }
  //     },
  //     plugins: {
  //       title: {
  //         display: true,
  //         text: "🤖 Prediksi Risiko Operasional 24 Jam ke Depan"
  //       },
  //       tooltip: {
  //         callbacks: {
  //           label: ctx => `${ctx.raw.unit}: ${ctx.raw.pred_risk.toFixed(1)}% risiko`
  //         }
  //       }
  //     }
  //   }
  // });

  // 🧩 Smart Resize Observer agar chart di HP proporsional
window.addEventListener("resize", () => {
  const charts = Chart.instances;
  for (let id in charts) {
    const chart = charts[id];
    if (chart) chart.resize();
  }
});

// 🧩 Pastikan semua chart menggunakan lebar parent container
document.querySelectorAll(".chart-card canvas").forEach((canvas) => {
  canvas.style.width = "100%";
  canvas.style.height = "auto";
  canvas.style.maxWidth = "100%";
});

});
