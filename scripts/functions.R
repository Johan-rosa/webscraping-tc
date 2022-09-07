# Dependecies -------------------------------------------------------------
box::use(rvest[read_html, html_text, html_element])
box::use(stringr[str_extract])
box::use(readr[parse_number])

#' Descarga la tasa de cambio de Banreservas
#' @export
tasa_dolar_banreservas <- function() {
  url <- "https://www.banreservas.com/calculadoras/pages/divisas.aspx"
  page <- read_html(url)
  
  buy <- page |>
    html_element('#edit-buy-wrapper .form-item-wrapper .form-label-text') |>
    html_text() |>
    str_extract("RD.+$")
  
  sell <- page |>
    html_element('#edit-sell-wrapper .form-item-wrapper .form-label-text') |>
    html_text() |>
    str_extract("RD.+$")
  
  data.frame(
    date = Sys.Date(),
    bank = 'Banresevas',
    buy = parse_number(buy),
    sell = parse_number(sell)
  )
}

#' Descarga la tasa de cambio de Scotiabank
#' @export
tasa_dolar_scotia <- function() {
  url <- "https://do.scotiabank.com/banca-personal/tarifas/tasas-de-cambio.html"
  
  read_html(url) %>%
    html_table(header = TRUE) %>%
    `[[`(., 1) %>% 
    setNames(c("pais", "tipo", "compra", "venta")) %>%
    filter(pais == "Estados Unidos") %>%
    mutate(tipo = str_remove(tipo, "Dólar (USD) ")) %>%
    mutate(bank = "Scotiabank", date = Sys.Date()) %>%
    select(date, bank, tipo, buy = compra, sell = venta)
}
