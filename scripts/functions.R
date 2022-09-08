# Dependecies -------------------------------------------------------------
box::use(
  rvest[read_html, html_text, html_element, html_table],
  stringr[str_extract, str_remove],
  readr[parse_number],
  dplyr[...],
  stats[setNames]
)

#' Descarga la tasa de cambio de Banreservas
#' @export
tasa_dolar_banreservas <- function(selenium_client) {
  selenium_client$navigate('https://www.banreservas.com/')
  
  tasa_compra <- selenium_client$findElement(
    using = "css selector", 
    "#site-nav-panel > ul:nth-child(1) > li:nth-child(2) > span"
  )
  
  tasa_venta <- selenium_client$findElement(
    using = "css selector", 
    "#site-nav-panel > ul:nth-child(1) > li:nth-child(3) > span"
  )
  
  compra <- tasa_compra$getElementText() %>%
    unlist() %>% 
    parse_number()
  
  venta <- tasa_venta$getElementText() %>%
    unlist() %>% 
    parse_number()
  
  data.frame(
    date = Sys.Date(),
    bank = "Banreservas",
    buy = compra,
    sell = venta
  )
}

#' Descarga la tasa de cambio de Scotiabank
#' @export
tasa_dolar_scotiabank <- function() {
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

#' Descarga la tasa de cambio de Banco Popular
#' @export
tasa_dolar_popular <- function(selenium_client) {
  
  selenium_client$navigate("https://www.popularenlinea.com/personas/Paginas/Home.aspx")
  
  tasas_banner <- selenium_client$findElement(
    using = "css selector", 
    "#s4-bodyContainer > section.footer_est_bpd.footer_est_personas > nav > ul > li:nth-child(3)"
  )
  tasas_banner$clickElement()
  Sys.sleep(1)
  
  tasa_compra <- selenium_client$findElement(
    using = "css selector",
    "#compra_peso_dolar_desktop")
  tasa_venta <- selenium_client$findElement(
    using = "css selector",
    "#venta_peso_dolar_desktop")
  
  compra <- as.numeric(tasa_compra$getElementAttribute("value"))
  venta <- as.numeric(tasa_venta$getElementAttribute("value"))
  
  data.frame(
    date = Sys.Date(),
    bank = "Banco Popular",
    buy = compra,
    sell = venta
  )
}

#' Descarga la tasa de cambio de Banco BHD
#' @export
tasa_dolar_bhd <- function(selenium_client) {
  
  selenium_client$navigate("https://www.bhdleon.com.do/wps/portal/BHD/Inicio/")
  
  tasas_banner <- selenium_client$findElement(
    using = "css selector", 
    "#footer > section > div > ul > li:nth-child(5)"
  )
  tasas_banner$clickElement()
  Sys.sleep(1)
  
  tasa_compra <- selenium_client$findElement(
    using = "css selector",
    "#TasasDeCambio > table > tbody > tr:nth-child(2) > td:nth-child(2)"
  )
  tasa_venta <- selenium_client$findElement(
    using = "css selector",
    "#TasasDeCambio > table > tbody > tr:nth-child(2) > td:nth-child(3)"
  )
  
  
  tasa_venta$getElementText()
  
  compra <- parse_number(unlist(tasa_compra$getElementText()))
  venta <- parse_number(unlist(tasa_venta$getElementText()))
  
  data.frame(
    date = Sys.Date(),
    bank = "BHD",
    buy = compra,
    sell = venta
  )
}

#' Descarga la tasa de cambio de Santa Cruz
#' @export
tasa_dolar_santa_cruz <- function(selenium_client) {
  
  selenium_client$navigate("https://bsc.com.do/home")
  
  tasas_banner <- selenium_client$findElement(
    using = "xpath",
    "/html/body/div[3]/div/header/div[2]/div[1]/div/nav/div[2]/ul/li[4]/a"
  )
  tasas_banner$clickElement()
  Sys.sleep(3)
  
  tasa_compra <- selenium_client$findElement(
    using = "xpath",
    "/html/body/div[3]/div/div[2]/div/div/div[2]/div/ul[2]/li[1]/div/div[2]/div/div[1]/div/h2"
  )
  tasa_venta <- selenium_client$findElement(
    using = "xpath",
    "/html/body/div[3]/div/div[2]/div/div/div[2]/div/ul[2]/li[1]/div/div[2]/div/div[2]/div/h2"
  )
  
  tasa_venta$getElementText()
  
  compra <- parse_number(unlist(tasa_compra$getElementText()))
  venta <- parse_number(unlist(tasa_venta$getElementText()))
  
  data.frame(
    date = Sys.Date(),
    bank = "Santa Cruz",
    buy = compra,
    sell = venta
  )
}

#' Descarga la tasa de cambio de Banco Caribe
#' @export
tasa_dolar_caribe <- function(selenium_client) {

  selenium_client$navigate("https://www.bancocaribe.com.do/")

  tasas_banner <- selenium_client$findElement(
    using = "css selector",
    "#exchange-rates-button"
  )
  tasas_banner$clickElement()
  
  Sys.sleep(1)

  tasa_compra <- selenium_client$findElement(
    using = "css selector",
    "#us_buy_res"
  )
  tasa_venta <- selenium_client$findElement(
    using = "css selector",
    "#us_sell_res"
  )

  tasa_venta$getElementText()

  compra <- parse_number(unlist(tasa_compra$getElementText()))
  venta <- parse_number(unlist(tasa_venta$getElementText()))

  data.frame(
    date = Sys.Date(),
    bank = "Banco Caribe",
    buy = compra,
    sell = venta
  )
}

#' Descarga la tasa de cambio de Banco BDI
#' @export
tasa_dolar_bdi <- function() {

  page <- read_html("https://www.bdi.com.do/")

  tasa_compra <- page |>
    html_element("#dnn_ctr421_ModuleContent > div > div > div > div:nth-child(2) > div:nth-child(1) > ul > li:nth-child(4)") |>
    html_text()
  
  tasa_venta <- page |>
    html_element("#dnn_ctr421_ModuleContent > div > div > div > div:nth-child(2) > div:nth-child(1) > ul > li.mc_xs_item") |>
    html_text()

  compra <- parse_number(tasa_compra)
  venta <- parse_number(tasa_venta)

  data.frame(
    date = Sys.Date(),
    bank = "BDI",
    buy = compra,
    sell = venta
  )
}

#' Descarga la tasa de cambio de Vimenca
#' @export
tasa_dolar_vimenca <- function(selenium_client) {

  selenium_client$navigate("https://www.bancovimenca.com/")
  
  Sys.sleep(1)
  
  tasa_compra <- selenium_client$findElement(
    using = "css selector",
    "#exangeRates > li:nth-child(1) > div > div > div:nth-child(2) > article"
  )
  tasa_venta <- selenium_client$findElement(
    using = "css selector",
    "#exangeRates > li:nth-child(1) > div > div > div:nth-child(3) > article"
  )

  compra <- parse_number(unlist(tasa_compra$getElementText()))
  venta <- parse_number(unlist(tasa_venta$getElementText()))
  
  data.frame(
    date = Sys.Date(),
    bank = "Vimenca",
    buy = compra,
    sell = venta
  )
}

