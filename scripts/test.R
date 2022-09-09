box::use(
  ./functions
)

rD <- RSelenium::rsDriver(
  browser = "chrome",
  chromever = "105.0.5195.52"
  )

client <- rD[["client"]]

client$setWindowSize(
  width = 1600, height = 800
)

tasas <- list(
  scotia = functions$tasa_dolar_scotiabank(),
  reservas = functions$tasa_dolar_banreservas(client),
  popular = functions$tasa_dolar_popular(client),
  bhd = functions$tasa_dolar_bhd(client),
  santa_cruz = functions$tasa_dolar_santa_cruz(client),
  caribe = functions$tasa_dolar_caribe(client),
  bdi = functions$tasa_dolar_bdi(),
  vimenca = functions$tasa_dolar_vimenca(client),
  blh = functions$tasa_dolar_blh(),
  promerica = functions$tasa_dolar_promerica(client),
  banesco = functions$tasa_dolar_banesco(client),
  lafise = functions$tasa_dolar_lafise(client),
  ademi = functions$tasa_dolar_ademi(client)
)

data <- dplyr::bind_rows(tasas)

saveRDS(data, paste0("data/daily/", Sys.Date(), ".rds"))
