library(dplyr)
library(stringr)
library(purrr)
library(rvest)
library(RSelenium)
library(readr)

source("scripts/functions.R", echo = FALSE, verbose = FALSE)

# Set up RSelenium
cat("Starting Selenium server...\n")

# In GitHub Actions, we need to run Chrome in headless mode
chrome_options <- list(
  chromeOptions = list(
    args = c('--headless', '--no-sandbox', '--disable-dev-shm-usage')
  )
)

# Start the Selenium server and browser
driver <- rsDriver(
  browser = "chrome",
  port = 4444L,
  chromever = NULL,  # Auto-detect Chrome version
  extraCapabilities = chrome_options
)

# Get the client object
client <- driver$client
client$setWindowSize(
  width = 1600, height = 800
)

tasas <- list(
  scotia = tasa_dolar_scotiabank(),
  reservas = tasa_dolar_banreservas(client),
  popular = tasa_dolar_popular(client),
  bhd = tasa_dolar_bhd(),
  santa_cruz = tasa_dolar_santa_cruz(),
  caribe = tasa_dolar_caribe(),
  bdi = tasa_dolar_bdi(),
  vimenca = tasa_dolar_vimenca(),
  blh = tasa_dolar_blh(),
  promerica = tasa_dolar_promerica(),
  banesco = tasa_dolar_banesco()
  #lafise = tasa_dolar_lafise(client),
  #ademi = tasa_dolar_ademi(client)
)

data <- dplyr::bind_rows(tasas)

saveRDS(data, paste0("data/daily/", Sys.Date(), ".rds"))
