// Toggle mobile menu
const menuToggle = document.getElementById("menuToggle");
  const navbarMenu = document.getElementById("navbarMenu");
  menuToggle.addEventListener("click", () => {
    navbarMenu.classList.toggle("active");
    menuToggle.classList.toggle("open");
  });


function toggleProfile(){
alert('Profile menu — kamu bisa custom ini (dropdown)');
}


// Chart helper (example)
function renderTrendChart(canvasId, labels, values){
const ctx = document.getElementById(canvasId);
if(!ctx) return;


new Chart(ctx, {
type: 'line',
data: {
labels: labels,
datasets: [{
label: 'Kesiapan',
data: values,
fill: true,
tension: 0.4,
pointRadius: 4,
backgroundColor: 'rgba(13,71,161,0.06)',
borderColor: 'rgba(13,71,161,0.95)',
borderWidth: 2
}]
},
options: {
maintainAspectRatio: false,
scales: {
y: { beginAtZero: true }
},
plugins: { legend: { display: false } }
}
});
}


// Auto-init example (if data present in DOM)
document.addEventListener('DOMContentLoaded', ()=>{
const el = document.getElementById('trendChart');
if(el){
// If you render labels/values via template context as JSON, the next lines can be used.
try{
const labels = JSON.parse(el.dataset.labels || '[]');
const values = JSON.parse(el.dataset.values || '[]');
renderTrendChart('trendChart', labels, values);
}catch(e){/* ignore */}
}
});