library(dplyr)
library(rvest)
library(purrr)
library(stringr)
library(janitor)
library(glue)
library(logger)

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

csv_file <- glue::glue("data/infodolar/{Sys.Date()}.csv")
rds_file <- glue::glue("data/infodolar/rds/{Sys.Date()}.rds")

log_info("Save file of the day")
readr::write_csv(infodolar, csv_file, na = "")
saveRDS(infodolar, rds_file)

log_info("Prepare all data")
all <- list.files("data/infodolar/rds", full.names = TRUE, pattern = "\\d{4}") |>
  purrr::map(readRDS) |>
  purrr::list_rbind()

log_info("Save all data")
readr::write_csv(all, "data/infodolar/_historico_infodolar.csv", na = "")
saveRDS(all, "data/infodolar/rds/_historico_infodolar.rds")
