library(dplyr)
library(stringr)
library(purrr)
library(rvest)
library(RSelenium)
library(readr)
library(glue)
library(logger)

source("scripts/functions.R", echo = FALSE, verbose = FALSE)

log_info("Starting Selenium server...\n")

# In GitHub Actions, we need to run Chrome in headless mode
chrome_options <- list(
  chromeOptions = list(
    args = c('--headless', '--no-sandbox', '--disable-dev-shm-usage')
  )
)

driver <- rsDriver(
  browser = "chrome",
  port = 4444L,
  chromever = NULL,
  extraCapabilities = chrome_options
)

client <- driver$client
client$setWindowSize(
  width = 1600, height = 800
)

functions_tasas <- list(
  scotia = tasa_dolar_scotiabank,
  reservas = tasa_dolar_banreservas,
  popular = \() tasa_dolar_popular(client),
  bhd = tasa_dolar_bhd,
  santa_cruz = tasa_dolar_santa_cruz,
  caribe = tasa_dolar_caribe,
  bdi = tasa_dolar_bdi,
  vimenca = tasa_dolar_vimenca,
  blh = tasa_dolar_blh,
  promerica = tasa_dolar_promerica,
  banesco = tasa_dolar_banesco,
  lafise = tasa_dolar_lafise,
  ademi = tasa_dolar_ademi
)

safe_functions_tasas <- map(functions_tasas, \(fn) safely(fn, data.frame()))

tasas_raw <- map(safe_functions_tasas, \(fn) fn())

tasas <- map(tasas_raw, "result") |> list_rbind()

errores <- keep(tasas_raw, \(raw_result) !is.null(raw_result$error))

if (length(errores) > 0) {
  fail_banks <- names(errores) |> paste(collapse = ", ")
  log_error("The fetch for {length(errores)} banks failed: {fail_banks}")

  iwalk(errores, \(results, bank) log_error("{bank}: {results$error}"))
}

log_success("{nrow(tasas)} rows succeeded")
print(tasas)

out_file <- paste0("data/daily/", Sys.Date(), ".rds")
log_info("Saving today's data into: {out_file}")
saveRDS(tasas, paste0("data/daily/", Sys.Date(), ".rds"))
