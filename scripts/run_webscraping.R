library(dplyr)
library(stringr)
library(purrr)
library(rvest)
library(readr)
library(glue)
library(logger)
library(lubridate)

log_info("Starting data from banks extraction...")

source("scripts/functions.R", echo = FALSE, verbose = FALSE)

functions_tasas <- list(
  scotia = tasa_dolar_scotiabank,
  reservas = tasa_dolar_banreservas,
  popular = tasa_dolar_popular,
  bhd = tasa_dolar_bhd,
  santa_cruz = tasa_dolar_santa_cruz,
  caribe = tasa_dolar_caribe,
  bdi = tasa_dolar_bdi,
  vimenca = tasa_dolar_vimenca,
  blh = tasa_dolar_blh,
  promerica = tasa_dolar_promerica,
  banesco = tasa_dolar_banesco,
  lafise = tasa_dolar_lafise,
  ademi = tasa_dolar_ademi,
  quezada = tasa_dolar_quezada
)

safe_functions_tasas <- map(functions_tasas, \(fn) safely(fn, data.frame()))

tasas_raw <- map(safe_functions_tasas, \(fn) fn())

tasas <- map(tasas_raw, "result") |> list_rbind()

errores <- keep(tasas_raw, \(raw_result) !is.null(raw_result$error))

if (length(errores) > 0) {
  fail_banks <- names(errores) |> paste(collapse = ", ")
  log_error("⚠️️ {length(errores)} banks failed. Successful: {nrow(tasas)} rows.")

  iwalk(errores, \(results, bank) log_error("{bank}: {results$error}"))
} else {
    log_success("✅ All banks fetched successfully.")
}

log_success("{nrow(distinct(tasas, bank))} rows succeeded")
print(tasas)

# Writing files -----------------------------------------------------------
today <- Sys.time() |>
  with_tz(tzone = "America/Santo_Domingo") |>
  floor_date("day") |>
  as.Date()

rds_file <- paste0("data/from_banks/rds/", today, ".rds")
csv_file <- paste0("data/from_banks/csv/", today, ".csv")

log_info("Saving today's data: {rds_file}")
saveRDS(tasas, rds_file)
log_success("Successfully saved RDS file.")

log_info("Saving today's data: {csv_file}")
write_csv(tasas, csv_file, na = "")
log_success("Successfully saved CSV file.")

log_info("🔄 Loading historical data from banks...")
historico_from_banks <- list.files("data/from_banks/rds/", full.names = TRUE) |>
  map(read_rds) |>
  list_rbind()

log_success("✅ Historical data loaded. Writing files...")
saveRDS(historico_from_banks, "data/from_banks/_historico_from_banks.rds")
write_csv(historico_from_banks, "data/from_banks/_historico_from_banks.csv", na = "")
log_success("📁 Historical data successfully updated.")

log_info("Data extraction script completed successfully.")
