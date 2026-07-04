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
  
  /* 
  const chart = Highcharts.charts.filter(chart => chart.myChartId === 'modal-plot')
  const plotData = myData.filter(row => row.name == entidad)[0]
  chart[0].series[0].setData(plotData.data);
  */
  showModal();
}
