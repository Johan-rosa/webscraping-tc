
# Packages ------------------------------------------------------------------------------------
library(dplyr)
library(tidyr)
library(highcharter)
library(here)
library(stringr)

options(box.path = here())

box::use(
  scripts/utils[crear_mes],
  scripts/equivalencias_banks_infodolar[
    entidades_banks, 
    entidades_infodolar
  ],
  scripts/tc_spot[get_tc_spot],
)


# Import data ---------------------------------------------------------------------------------

tc_spot <- get_tc_spot(frecuencia = "diaria")
historico_banks <- 
  readRDS(here("data/from_banks/_historico_from_banks.rds")) |> 
  filter(
    # Remover una de las tasas de scotia
    is.na(tipo) | str_detect(tipo, "Digitales")
  )

historico_infodolar <- readRDS(here("data/infodolar/_historico_infodolar.rds"))
