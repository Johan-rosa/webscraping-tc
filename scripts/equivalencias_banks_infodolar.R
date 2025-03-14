library(here)
library(dplyr)
library(tidyr)
library(stringr)
  
#' @export
entidades_banks <- tibble::tribble(
        ~entidad,                 ~name, ~tipo_entidad,  ~subgrupo_entidad,
    "Scotiabank",          "Scotiabank",         "EIF",  "Banco Múltiple", 
   "Banreservas",         "Banreservas",         "EIF",  "Banco Múltiple",
 "Banco Popular",       "Banco Popular",         "EIF",  "Banco Múltiple",
           "BHD",           "Banco BHD",         "EIF",  "Banco Múltiple",
    "Santa Cruz",    "Banco Santa Cruz",         "EIF",  "Banco Múltiple",
  "Banco Caribe",        "Banco Caribe",         "EIF",  "Banco Múltiple",
           "BDI",                 "BDI",         "EIF",  "Banco Múltiple",
       "Vimenca",       "Banco Vimenca",         "EIF",  "Banco Múltiple",
           "BLH", "Banco López de Haro",         "EIF",  "Banco Múltiple",
     "Promerica",           "Promerica",         "EIF",  "Banco Múltiple",
       "Banesco",             "Banesco",         "EIF",  "Banco Múltiple",
        "Lafise",        "Banco Lafise",         "EIF",  "Banco Múltiple",
         "Ademi",         "Banco Ademi",         "EIF",  "Banco Múltiple",
         "Quezada",            "Quezada",         "AC",               "AC"
 )

#' @export
entidades_infodolar <- tibble::tribble(
                                         ~entidad,                          ~name, ~tipo_entidad,   ~subgrupo_entidad,
                                    "Banreservas",                  "Banreservas",         "EIF",    "Banco Múltiple",
                       "Scotiabank Cambio online",                   "Scotiabank",         "EIF",    "Banco Múltiple",
                                     "Scotiabank",      "Scotiabank - sucursales",         "EIF",    "Banco Múltiple",
                                  "Banco Popular",                "Banco Popular",         "EIF",    "Banco Múltiple",
                                   "Banco Caribe",                 "Banco Caribe",         "EIF",    "Banco Múltiple",
                                   "Banco Lafise",                 "Banco Lafise",         "EIF",    "Banco Múltiple",
                                        "Banesco",                      "Banesco",         "EIF",    "Banco Múltiple",
      "Asociación Peravia de Ahorros y Préstamos",           "Asociación Peravia",         "EIF",  "Asociación de AP",
        "Asociación Cibao de Ahorros y Préstamos",             "Asociación Cibao",         "EIF",  "Asociación de AP",
  "Asociación La Nacional de Ahorros y Préstamos",       "Asociación la Nacional",         "EIF",  "Asociación de AP",
      "Asociación Popular de Ahorros y Préstamos",           "Asociación Popular",         "EIF",  "Asociación de AP",
                                         "Alaver",                       "Alaver",         "EIF",  "Asociación de AP",
                                  "Motor Crédito",                "Motor Crédito",         "EIF",       "Banco de AC",
                                  "Bonanza Banco",                "Bonanza Banco",         "EIF",       "Banco de AC",
                   "Agente de Cambio La Nacional", "Agente de Cambio la Nacional",          "AC",                "AC",
                                "Panora Exchange",              "Panora Exchange",          "AC",                "AC",
                                        "Girosol",                      "Girosol",          "AC",                "AC",
                                        "Taveras",                      "Taveras",          "AC",                "AC",
                              "Cambio Extranjero",            "Cambio Extranjero",          "AC",                "AC",
                                             "RM",                           "RM",          "AC",                "AC",
                                        "Gamelin",                      "Gamelin",          "AC",                "AC",
                                     "Moneycorps",                   "Moneycorps",          "AC",                "AC",
                                          "Capla",                        "Capla",          "AC",                "AC",
                                            "SCT",                          "SCT",          "AC",                "AC"
  )
