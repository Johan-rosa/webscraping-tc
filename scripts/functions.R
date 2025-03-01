chromote_driver <- function() {
  browser <- chromote::ChromoteSession$new()
  browser$Network$setUserAgentOverride(
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36")
  browser
}

#' Descarga la tasa de cambio de Banreservas
#' @export
tasa_dolar_banreservas <- function(selenium_client) {
  logger::log_info("Downloading Tasas Banreservas -------------")

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
  logger::log_info("Downloading Tasas Scotiabank -------------")

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
  logger::log_info("Downloading tasas Popular -------------")
  
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
  logger::log_info("Download tasas Banco BHD -------------")
  logger::log_info("Open cromote session with user agent")
  
  browser <- chromote_driver()
  logger::log_info("Navigate to site")
  browser$Page$navigate("https://bhd.com.do/")
  Sys.sleep(3)
  
  logger::log_info("Defining JS steps")
  click_tasas_btn <- 'document.querySelector("app-footer > footer > div > div > div.links > ul:nth-child(1) > li:nth-child(6) > div > button").click()'
  get_tasa_compra <- "document.querySelector('app-cambio_rate_popup > div > div > div.rate_tble > table > tbody > tr:nth-child(1) > td:nth-child(2)').innerText"
  get_tasa_venta <- "document.querySelector('app-cambio_rate_popup > div > div > div.rate_tble > table > tbody > tr:nth-child(1) > td:nth-child(3)').innerText"
  
  logger::log_info("Click tasas button")
  browser$Runtime$evaluate(click_tasas_btn)
  Sys.sleep(2)
  
  logger::log_info("Getting tasas")
  compra_node <- browser$Runtime$evaluate(get_tasa_compra)
  venta_node <- browser$Runtime$evaluate(get_tasa_venta)
  
  logger::log_info("Parsing results")
  compra <- readr::parse_number(compra_node$result$value)
  venta <- readr::parse_number(venta_node$result$value)
  
  logger::log_success(glue::glue("Tasas BHD - venta: {venta}, compra: {compra}"))
  browser$close()
  
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
  logger::log_info("Download tasas Banco Santa Cruz -------------")
  logger::log_info("Open cromote session with user agent")
  
  browser <- chromote_driver()

  logger::log_info("Navigate to website")
  browser$Page$navigate("https://bsc.com.do/")
  Sys.sleep(3)
  
  logger::log_info("Defining JS steps")
  click_tasas_btn <- 'document.querySelectorAll(".v-toolbar__content > button")[1].click();'
  get_tasa_compra <- 'document.querySelectorAll("strong[data-v-0c31f9a7]")[0].innerHTML'
  get_tasa_venta <- 'document.querySelectorAll("strong[data-v-0c31f9a7]")[1].innerHTML'
  
  logger::log_info("Click tasas button")
  browser$Runtime$evaluate(click_tasas_btn)
  Sys.sleep(3)
  
  logger::log_info("Getting tasas")
  compra_node <- browser$Runtime$evaluate(get_tasa_compra)
  venta_node <- browser$Runtime$evaluate(get_tasa_venta)
  
  logger::log_info("Parsing results")
  compra <- readr::parse_number(stringr::str_extract(compra_node$result$value, "RD.+$"))
  venta <- readr::parse_number(stringr::str_extract(venta_node$result$value, "RD.+$"))
  
  logger::log_success(glue::glue("Tasas Santa Cruz - venta: {venta}, compra: {compra}"))
  browser$close()
  data.frame(
    date = Sys.Date(),
    bank = "Santa Cruz",
    buy = compra,
    sell = venta
  )
}

#' Descarga la tasa de cambio de Banco Caribe
#' @export
tasa_dolar_caribe <- function() {
  logger::log_info("Download tasas Banco Caribe -------------")
  browser <- chromote_driver()

  logger::log_info("Navigate to website")
  browser$Page$navigate("https://www.bancocaribe.com.do/")
  browser$Page$loadEventFired()
  
  
  logger::log_info("Click exchange rates button")
  browser$Runtime$evaluate(
    expression = "
    document.getElementById('exchange-rates-button').click()
  "
  )
  
  logger::log_info("Getting tasa compra")
  compra_raw <- browser$Runtime$evaluate(
    expression = "
    const compra = document.getElementById('us_buy_res')
    compra.innerText
  "
  )
  
  logger::log_info("Getting tasa venta")
  venta_raw <- browser$Runtime$evaluate(
    expression = "
    const venta = document.getElementById('us_sell_res')
    venta.innerText
  "
  )
  
  compra <- venta_raw$result$value |> readr::parse_number()
  venta <- venta_raw$result$value |> readr::parse_number()
  
  logger::log_success(glue::glue("Tasas Banco Caribe - compra: {compra}, venta: {venta}"))
  
  browser$close()

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
  BANCO <- "BDI"
  URL <- "https://www.bdi.com.do/"


  logger::log_info(glue::glue("Download tasas {BANCO} -------------"))
  logger::log_info("Open cromote session with user agent")
  
  browser <- chromote_driver()
  logger::log_info("Navigate to site")
  browser$Page$navigate(URL)
  Sys.sleep(3)
  
  logger::log_info("Defining JS steps")
  click_tasas_btn <- "document.getElementById('abrir_tasa').click()"
  get_tasa_compra <- "document.getElementById('rd-compra').value"
  get_tasa_venta <- "document.getElementById('rd-venta').value"
  
  logger::log_info("Click tasas button")
  browser$Runtime$evaluate(click_tasas_btn)
  Sys.sleep(2)
  
  logger::log_info("Getting tasas")
  compra_node <- browser$Runtime$evaluate(get_tasa_compra)
  venta_node <- browser$Runtime$evaluate(get_tasa_venta)
  
  logger::log_info("Parsing results")
  compra <- readr::parse_number(compra_node$result$value)
  venta <- readr::parse_number(venta_node$result$value)
  
  logger::log_success(glue::glue("Tasas {BANCO} - venta: {venta}, compra: {compra}"))
  browser$close()

  data.frame(
    date = Sys.Date(),
    bank = "BDI",
    buy = compra,
    sell = venta
  )
}

#' Descarga la tasa de cambio de Vimenca
#' @export
tasa_dolar_vimenca <- function() {
  URL <- "https://www.bancovimenca.com/"
  BANCO <- "Vimenca"
  
  
  logger::log_info(glue::glue("Download tasas {BANCO} -------------"))
  logger::log_info("Open cromote session with user agent")
  
  html <- rvest::read_html_live("https://www.bancovimenca.com/") 
  Sys.sleep(3)
  
  logger::log_info("Getting tasas")
  venta_node <- html |>
    rvest::html_element(".item.saleValue") |>
    rvest::html_text() 
  
  compra_node <- html |>
    rvest::html_element(".item.purchaseValue") |>
    rvest::html_text()
  
  logger::log_info("Parsing results")
  compra <- readr::parse_number(compra_node)
  venta <- readr::parse_number(venta_node)
  
  logger::log_success(glue::glue("Tasas {BANCO} - venta: {venta}, compra: {compra}"))
  html$session$close()
  
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
  URL <- "https://www.blh.com.do/"
  BANCO <- "BLH"
  
  
  logger::log_info(glue::glue("Download tasas {BANCO} -------------"))
  
  logger::log_info("Reading static html content")
  page <- rvest::read_html(URL)
  
  logger::log_info("Getting tasas")
  tasas <- page |>
    rvest::html_element(xpath = '//*[@id="fws_67c22cf55fcac"]/div[2]/div[1]/div/div/div/div[2]/p') |>
    rvest::html_text() |>
    stringr::str_match_all("[0-9]{2}\\.[0-9]{2}") |>
    unlist() |>
    as.numeric()
  
  logger::log_info("Parsing results")
  compra <- tasas[1]
  venta <- tasas[2]
  
  logger::log_success(glue::glue("Tasas {BANCO} - venta: {venta}, compra: {compra}"))
  data.frame(
    date = Sys.Date(),
    bank = "BLH",
    buy = compra,
    sell = venta
  )
}

#' Descarga la tasa de cambio de Promerica
#' @export
tasa_dolar_promerica <- function() {
  BANCO <- "Promerica"
  URL <- "https://www.promerica.com.do/"
  
  logger::log_info("Reading live html content")
  html <- rvest::read_html_live(URL)
  Sys.sleep(3)
  
  logger::log_info("Getting tasas")
  tasas <- rvest::html_element(html, "#tipoCambioHome div .cambio") |>
    rvest::html_text() |>
    stringr::str_split("\\|") |>
    unlist() |>
    readr::parse_number()

  logger::log_info("Parsing results")
  compra <- tasas[1]
  venta <- tasas[2]
  
  logger::log_success(glue::glue("Tasas {BANCO} - venta: {venta}, compra: {compra}"))
  html$session$close()
  
  data.frame(
    date = Sys.Date(),
    bank = BANCO,
    buy = compra,
    sell = venta
  )
}

#' Descarga la tasa de cambio de Banesco
#' @export
tasa_dolar_banesco <- function() {
  BANCO <- "Banesco"
  URL <- "https://www.banesco.com.do/"
  
  html <- rvest::read_html_live(URL)
  Sys.sleep(3)
  
  logger::log_info("Getting tasas")
  venta_node <- html$session$Runtime$evaluate("document.querySelectorAll('.calculator__sell-input input')[1].value")
  compra_node <- html$session$Runtime$evaluate("document.querySelectorAll('.calculator__buy-input input')[1].value")
  
  logger::log_info("Parsing results")
  compra <- readr::parse_number(compra_node$result$value)
  venta <- readr::parse_number(venta_node$result$value)
  
  logger::log_success(glue::glue("Tasas {BANCO} - venta: {venta}, compra: {compra}"))
  html$session$close()
  
  data.frame(
    date = Sys.Date(),
    bank = BANCO,
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