library(dplyr)
library(stringr)
library(purrr)
library(rvest)
library(RSelenium)
library(readr)

source("scripts/functions.R")

rD <- RSelenium::rsDriver(
  browser = "chrome",
  chromever = "105.0.5195.52"
  )

client <- rD[["client"]]

client$setWindowSize(
  width = 1600, height = 800
)

tasas <- list(
  scotia = tasa_dolar_scotiabank(),
  reservas = tasa_dolar_banreservas(client),
  popular = tasa_dolar_popular(client),
  bhd = tasa_dolar_bhd(client),
  santa_cruz = tasa_dolar_santa_cruz(client),
  caribe = tasa_dolar_caribe(client),
  bdi = tasa_dolar_bdi(),
  vimenca = tasa_dolar_vimenca(client),
  blh = tasa_dolar_blh(),
  promerica = tasa_dolar_promerica(client),
  banesco = tasa_dolar_banesco(client),
  lafise = tasa_dolar_lafise(client),
  ademi = tasa_dolar_ademi(client)
)

data <- dplyr::bind_rows(tasas)

saveRDS(data, paste0("data/daily/", Sys.Date(), ".rds"))
