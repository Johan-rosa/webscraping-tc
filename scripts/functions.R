
#' Descarga la tasa de cambio de Banreservas
#' @export
tasa_dolar_banreservas <- function(selenium_client) {
  logger::log_info("Downloading Tasas Banreservas")

  logger::log_info("Navigate to site")
  selenium_client$navigate('https://www.banreservas.com/')
  
  logger::log_info("Target tasa compra")
  tasa_compra <- selenium_client$findElement(
    using = "css selector", 
    "#site-nav-panel > ul:nth-child(1) > li:nth-child(2) > span"
  )
  
  logger::log_info("Target tasa venta")
  tasa_venta <- selenium_client$findElement(
    using = "css selector", 
    "#site-nav-panel > ul:nth-child(1) > li:nth-child(3) > span"
  )
  
  logger::log_info("Parse to numbers")
  compra <- tasa_compra$getElementText() %>%
    unlist() %>%
    readr::parse_number()
  
  venta <- tasa_venta$getElementText() %>%
    unlist() %>% 
    readr::parse_number()
  
  logger::log_info(glue::glue("Tasa venta: {venta}; Tasa compra: {compra}"))
  data <- data.frame(
    date = Sys.Date(),
    bank = "Banreservas",
    buy = compra,
    sell = venta
  )
  
  logger::log_success("Tasa banreservas")
  data
}

#' Descarga la tasa de cambio de Scotiabank
#' @export
tasa_dolar_scotiabank <- function() {
  logger::log_info("Downloading Tasas Scotiabank")

  url <- "https://do.scotiabank.com/banca-personal/tarifas/tasas-de-cambio.html"
  tasas <- rvest::read_html(url) %>%
    rvest::html_table(header = TRUE) %>%
    `[[`(., 1) %>%
    setNames(c("pais", "tipo", "compra", "venta")) %>%
    dplyr::filter(pais == "Estados Unidos") %>%
    dplyr::mutate(tipo = str_remove(tipo, "Dólar (USD) ")) %>%
    dplyr::mutate(bank = "Scotiabank", date = Sys.Date()) %>%
    dplyr::select(date, bank, tipo, buy = compra, sell = venta)
  
  logger::log_success("Tasas scotia - venta: {tasas$venta[1]}, compra: {tasas$compra[1]}")
  tasas
}

#' Descarga la tasa de cambio de Banco Popular
#' @export
tasa_dolar_popular <- function(selenium_client) {
  logger::log_info("Getting tasas Popular")
  
  logger::log_info("Naverga a la página")
  selenium_client$navigate("https://www.popularenlinea.com/personas/Paginas/Home.aspx")
  
  logger::log_info("Click al banner de la página web")
  tasas_banner <- selenium_client$findElement(
    using = "css selector", 
    "#s4-bodyContainer > section.footer_est_bpd.footer_est_personas > nav > ul > li:nth-child(3)"
  )
  tasas_banner$clickElement()
  Sys.sleep(1)
  
  logger::log_info("Copiando las tasas")
  tasa_compra <- selenium_client$findElement(
    using = "css selector",
    "#compra_peso_dolar_desktop")
  tasa_venta <- selenium_client$findElement(
    using = "css selector",
    "#venta_peso_dolar_desktop")
  
  compra <- as.numeric(tasa_compra$getElementAttribute("value"))
  venta <- as.numeric(tasa_venta$getElementAttribute("value"))
  
  logger::log_success(glue::glue("Tasas popular - venta: {venta}, compra: {compra}"))

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
  
  selenium_client$navigate("https://bhd.com.do/?v=1")
  Sys.sleep(2)

  tasas_banner <- selenium_client$findElement(
    using = "css selector", 
    "div.links > ul:nth-child(1) > li:nth-child(6) > div > button"
  )
  tasas_banner$clickElement()
  Sys.sleep(1)
  
  tasa_compra <- selenium_client$findElement(
    using = "css selector",
    ".rate_tble > table > tbody > tr:nth-child(1) > td:nth-child(2)"
  )

  tasa_venta <- selenium_client$findElement(
    using = "css selector",
    ".rate_tble > table > tbody > tr:nth-child(1) > td:nth-child(3)"
  )
  
  
  tasa_venta$getElementText()
  
  compra <- readr::parse_number(unlist(tasa_compra$getElementText()))
  venta <- readr::parse_number(unlist(tasa_venta$getElementText()))
  
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
  Sys.sleep(3)
  tasas_banner <- selenium_client$findElement(
    using = "xpath",
    "/html/body/div[3]/div/header/div[2]/div[1]/div/nav/div[2]/ul/li[4]/a"
  )
  tasas_banner$clickElement()
  
  Sys.sleep(2)
  
  tasas_euro <- selenium_client$findElement(
    using = "xpath",
    "/html/body/div[3]/div/div[2]/div/div/div[2]/div/ul[1]/li[2]"
  )
  tasas_euro$clickElement()
  
  tasas_dolar <- selenium_client$findElement(
    using = "xpath",
    "/html/body/div[3]/div/div[2]/div/div/div[2]/div/ul[1]/li[1]"
  )
  tasas_dolar$clickElement()
  
  Sys.sleep(1)
  
  tasa_compra <- selenium_client$findElement(
    using = "xpath",
    "/html/body/div[3]/div/div[2]/div/div/div[2]/div/ul[2]/li[1]/div/div[2]/div/div[1]/div/h2"
  )
  tasa_venta <- selenium_client$findElement(
    using = "xpath",
    "/html/body/div[3]/div/div[2]/div/div/div[2]/div/ul[2]/li[1]/div/div[2]/div/div[2]/div/h2"
  )
  
  compra <- readr::parse_number(unlist(tasa_compra$getElementText()))
  venta <- readr::parse_number(unlist(tasa_venta$getElementText()))
  
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

  compra <- readr::parse_number(unlist(tasa_compra$getElementText()))
  venta <- readr::parse_number(unlist(tasa_venta$getElementText()))

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

  page <- rvest::read_html("https://www.bdi.com.do/")

  tasa_compra <- page %>%
    rvest::html_element("#dnn_ctr421_ModuleContent > div > div > div > div:nth-child(2) > div:nth-child(1) > ul > li:nth-child(4)") %>%
    rvest::html_text()
  
  tasa_venta <- page %>%
    rvest::html_element("#dnn_ctr421_ModuleContent > div > div > div > div:nth-child(2) > div:nth-child(1) > ul > li.mc_xs_item") %>%
    rvest::html_text()

  compra <- readr::parse_number(tasa_compra)
  venta <- readr::parse_number(tasa_venta)

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

  compra <- readr::parse_number(unlist(tasa_compra$getElementText()))
  venta <- readr::parse_number(unlist(tasa_venta$getElementText()))
  
  data.frame(
    date = Sys.Date(),
    bank = "Vimenca",
    buy = compra,
    sell = venta
  )
}

#' Descarga la tasa de cambio de Banco López de Haro
#' @export
tasa_dolar_blh <- function() {
  
  page <- rvest::read_html("https://www.blh.com.do/")

  tasas <- page %>%
    rvest::html_element(xpath = '//*[@id="fws_64b15de87d4bb"]/div[2]/div[1]/div/div/div/div[2]/p') %>%
    rvest::html_text() %>%
    stringr::str_match_all("[0-9]{2}\\.[0-9]{2}") %>%
    unlist() %>%
    as.numeric()
  
  compra <- tasas[1]
  venta <- tasas[2]
  
  data.frame(
    date = Sys.Date(),
    bank = "BLH",
    buy = compra,
    sell = venta
  )
}

#' Descarga la tasa de cambio de Promerica
#' @export
tasa_dolar_promerica <- function(selenium_client) {
  
  selenium_client$navigate("https://www.promerica.com.do/")
  Sys.sleep(1)
  
  tasas <- selenium_client$findElement(
    using = "xpath",
    "/html/body/div/div[1]/section[1]/div[2]/p"
  )
  
  tasas <- tasas$getElementText() %>%
    unlist() %>%
    stringr::str_match_all("[0-9]{2}\\.[0-9]{2}") %>%
    unlist() %>%
    as.numeric()
  
  compra <- tasas[1]
  venta <- tasas[2]
  
  data.frame(
    date = Sys.Date(),
    bank = "Promerica",
    buy = compra,
    sell = venta
  )
}

#' Descarga la tasa de cambio de Banesco
#' @export
tasa_dolar_banesco <- function(selenium_client) {
  
  selenium_client$navigate("https://www.banesco.com.do/")
  Sys.sleep(1)
  
  tasas <- selenium_client$findElement(
    using = "xpath",
    "/html/body/div[1]/div[3]/div/div/div/div/p[2]"
  )
  
  tasas <- tasas$getElementText() %>%
    unlist() %>%
    stringr::str_match_all("[0-9]{2}\\.[0-9]{2}") %>%
    unlist() %>%
    as.numeric()
  
  compra <- tasas[1]
  venta <- tasas[2]
  
  data.frame(
    date = Sys.Date(),
    bank = "Banesco",
    buy = compra,
    sell = venta
  )
}

#' Descarga la tasa de cambio de lafise
#' @export
tasa_dolar_lafise <- function(selenium_client) {
  
  selenium_client$navigate("https://www.lafise.com/blrd")
  Sys.sleep(1)
  
  tasa_compra <- selenium_client$findElement(
    using = "xpath",
    "/html/body/form/section[4]/div/div/div[2]/div/div/div[2]/div/div/div/div/div/div[1]/div/div[4]"
  )
  tasa_venta <- selenium_client$findElement(
    using = "xpath",
    "/html/body/form/section[4]/div/div/div[2]/div/div/div[2]/div/div/div/div/div/div[1]/div/div[5]"
  )
  
  compra <- readr::parse_number(unlist(tasa_compra$getElementText()))
  venta <- readr::parse_number(unlist(tasa_venta$getElementText()))
  
  data.frame(
    date = Sys.Date(),
    bank = "Lafise",
    buy = compra,
    sell = venta
  )
}

#' Descarga la tasa de cambio de lafise
#' @export
tasa_dolar_ademi <- function(selenium_client) {

  selenium_client$navigate("https://bancoademi.com.do/")

  tasas_banner <- selenium_client$findElement(
    using = "xpath",
    "/html/body/section[1]/div/div/a[5]"
  )
  tasas_banner$clickElement()
  Sys.sleep(2)
  
  tasa_compra <- selenium_client$findElement(
    using = "xpath",
    "/html/body/div[1]/div/div/div[2]/fieldset/div[1]/div[4]/div/input"
  )
  tasa_venta <- selenium_client$findElement(
    using = "xpath",
    "/html/body/div[1]/div/div/div[2]/fieldset/div[2]/div[4]/div/input"
  )
  
  tasa_venta$getElementText()
  
  compra <- readr::parse_number(unlist(tasa_compra$getElementAttribute("placeholder")))
  venta <- readr::parse_number(unlist(tasa_venta$getElementAttribute("placeholder")))
  
  data.frame(
    date = Sys.Date(),
    bank = "Ademi",
    buy = compra,
    sell = venta
  )
}