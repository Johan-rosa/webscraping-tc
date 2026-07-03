function showModal() {
  const modalEl = document.getElementById('shiny-modal');

  if (window.bootstrap && !window.bootstrap.Modal.VERSION.match(/^4\./)) {
    const modal = new bootstrap.Modal(modalEl);
    modal.show();
  } else {
    $('#shiny-modal').modal().focus();
  }
};
