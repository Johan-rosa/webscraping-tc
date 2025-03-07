library(here)
library(dplyr)
library(tidyr)
library(stringr)
  
#' @export
entidades_banks <- tibble::tribble(
        ~entidad,                 ~name, ~tipo_entidad,
    "Scotiabank",          "Scotiabank", "EIF", 
   "Banreservas",         "Banreservas", "EIF",
 "Banco Popular",       "Banco Popular", "EIF",
           "BHD",           "Banco BHD", "EIF",
    "Santa Cruz",    "Banco Santa Cruz", "EIF",
  "Banco Caribe",        "Banco Caribe", "EIF",
           "BDI",                 "BDI", "EIF",
       "Vimenca",       "Banco Vimenca", "EIF",
           "BLH", "Banco López de Haro", "EIF",
     "Promerica",           "Promerica", "EIF",
       "Banesco",             "Banesco", "EIF",
        "Lafise",        "Banco Lafise", "EIF",
         "Ademi",         "Banco Ademi", "EIF"
 )

#' @export
entidades_infodolar <- tibble::tribble(
                                         ~entidad,                          ~name, ~tipo_entidad,
                                    "Banreservas",                  "Banreservas", "EIF",
                       "Scotiabank Cambio online",                   "Scotiabank", "EIF",
                                     "Scotiabank",      "Scotiabank - sucursales", "EIF",
                                  "Banco Popular",                "Banco Popular", "EIF",
                                   "Banco Caribe",                 "Banco Caribe", "EIF",
      "Asociación Peravia de Ahorros y Préstamos",           "Asociación Peravia", "EIF",
        "Asociación Cibao de Ahorros y Préstamos",             "Asociación Cibao", "EIF",
  "Asociación La Nacional de Ahorros y Préstamos",       "Asociación la Nacional", "EIF",
      "Asociación Popular de Ahorros y Préstamos",           "Asociación Popular", "EIF",
                                   "Banco Lafise",                 "Banco Lafise", "EIF",
                                        "Banesco",                      "Banesco", "EIF",
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
