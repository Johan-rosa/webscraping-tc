library(dplyr)
library(rvest)
library(purrr)
library(stringr)
library(janitor)
library(glue)
library(logger)
library(readr)
library(lubridate)

log_info("Get Table")
table <- read_html("https://www.infodolar.com.do/") |>
  html_elements(css = "table#Dolar") |> 
  html_table(trim = TRUE, header = TRUE)

log_info("Prepare table")
infodolar <- table[[1]] |>
  clean_names() |> 
  transmute(
    date = Sys.Date(),
    time = Sys.time(),
    entidad = str_squish(entidad),
    compra = str_extract(compra, "\\$\\d+(\\.\\d+)?") |> readr::parse_number(),
    venta = str_extract(venta, "\\$\\d+(\\.\\d+)?") |> readr::parse_number(),
  )

today <- Sys.time() |>
  with_tz(tzone = "America/Santo_Domingo") |>
  floor_date("day") |>
  as.Date()

csv_file <- glue("data/infodolar/csv/{today}.csv")
rds_file <- glue("data/infodolar/rds/{today}.rds")

log_info("Save files of the day: {csv_file} and {rds_file}")
write_csv(infodolar, csv_file, na = "")
saveRDS(infodolar, rds_file)

log_info("Prepare all data")
all <- list.files("data/infodolar/rds", full.names = TRUE, pattern = "\\d{4}") |>
  map(readRDS) |>
  list_rbind()

log_info("Save all data")
write_csv(all, "data/infodolar/_historico_infodolar.csv", na = "")
saveRDS(all, "data/infodolar/_historico_infodolar.rds")
