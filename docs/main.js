// Global data
let rates = [];

// Load data
async function init() {
  try {
    const response = await fetch("assets/data/rates.json");

    if (!response.ok) {
      throw new Error(`Failed to load rates.json (${response.status})`);
    }

    rates = await response.json();

    console.log("Rates loaded:", rates);
  } catch (err) {
    console.error(err);
  }
}

// Start loading as soon as the script is evaluated
init();
  
function showModal() {
  const modalEl = document.getElementById('shiny-modal');

  if (window.bootstrap && !window.bootstrap.Modal.VERSION.match(/^4\./)) {
    const modal = new bootstrap.Modal(modalEl);
    modal.show();
  } else {
    $('#shiny-modal').modal().focus();
  }
};

function rowAction(info, cell, state) {
  const entidad = state.data[info.index].entidad;
  const modalTitle = document.getElementById('modal-title')
  modalTitle.innerText = entidad
  
  const chart = Highcharts.charts.filter(chart => chart.myChartId === 'modal-plot')[0];
  const plotData = rates.filter(row => row.name == entidad)[0];
  
  console.log(plotData)
  plotData.series.forEach((newSeries, i) => {
    const newData = newSeries.data.map(d => [Date.parse(d[0]), d[1]]);

    if (chart.series[i]) {
      chart.series[i].update({
        name: newSeries.name,
        data: newData
      }, false)
    } else {
      chart.addSeries(newSeries, false);
    }
  })
  
  chart.redraw();
  showModal();
}
