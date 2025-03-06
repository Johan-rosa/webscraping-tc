library(dplyr)
library(tidyr)
library(stringr)

historico_bank <- readRDS(here("data/from_banks/_historico_from_banks.rds"))
historico_infodolar <- readRDS(here("data/infodolar/_historico_infodolar.rds"))

entidades_infodolar <- distinct(historico_infodolar, entidad)

c(
  "Scotiabank",
  "Banreservas",
  "Banco Popular",
  "BHD",
  "Santa Cruz", 
  "Banco Caribe",
  "BDI",
  "Vimenca",
  "BLH",
  "Promerica",
  "Banesco", 
  "Lafise",
  "Ademi"
)


entidades <- c(
    "Banreservas", 
    "Scotiabank Cambio online", 
    "Scotiabank",
    "Banco Popular",
    "Banco Caribe",
    "Asociación Peravia de Ahorros y Préstamos",
    "Asociación Cibao de Ahorros y Préstamos",
    "Asociación La Nacional de Ahorros y Préstamos", 
    "Asociación Popular de Ahorros y Préstamos", 
    "Banco Lafise",
    "Banesco",

    "Agente de Cambio La Nacional",
    "Panora Exchange",
    "Motor Crédito",
    "Girosol",
    "Taveras",
    "Alaver",
    "Cambio Extranjero",
    "RM",
    "Gamelin",
    "Bonanza Banco",
    "Moneycorps", 
    "Capla",
    "SCT"
)

entidades_infodolar |>
  mutate(
    case_when(
      type = str_detect(entidad, "[Cc]ambio") ~ "AC",
      TRUE ~ NA
    )
  ) |> View()


equivalencias_infodolar <- tibble::tribble(
                                         ~entidad,                          ~name, ~tipo,
                                    "Banreservas",                  "Banreservas", "EIF",
                       "Scotiabank Cambio online",                   "Scotiabank", "EIF",
                                     "Scotiabank",      "Scotiabank - sucursales", "EIF",
                                  "Banco Popular",                "Banco popular", "EIF",
                                   "Banco Caribe",                 "Banco caribe", "EIF",
      "Asociación Peravia de Ahorros y Préstamos",           "Asociación Peravia", "EIF",
        "Asociación Cibao de Ahorros y Préstamos",             "Asociación Cibao", "EIF",
  "Asociación La Nacional de Ahorros y Préstamos",       "Asociación la Nacional", "EIF",
      "Asociación Popular de Ahorros y Préstamos",           "Asociación Popular", "EIF",
                                   "Banco Lafise",                 "Banco Lafise", "EIF",
                                        "Banesco",       "Asociación la Nacional", "EIF",
                   "Agente de Cambio La Nacional", "Agente de Cambio la Nacional",  "AC",
                                "Panora Exchange",              "Panora Exchange",  "AC",
                                  "Motor Crédito",                "Motor Crédito", "EIF",
                                        "Girosol",                      "Girosol",  "AC",
                                        "Taveras",                      "Taveras",  "AC",
                                         "Alaver",                       "Alaver", "EIF",
                              "Cambio Extranjero",            "Cambio Extranjero",  "AC",
                                             "RM",                           "RM",  "AC",
                                        "Gamelin",                      "Gamelin",  "AC",
                                  "Bonanza Banco",                "Bonanza Banco",  "AC",
                                     "Moneycorps",                   "Moneycorps",  "AC",
                                          "Capla",                        "Capla",  "AC",
                                            "SCT",                          "SCT",  "AC"
  )
