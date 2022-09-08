box::use(
  ./functions
)

rD <- RSelenium::rsDriver(
  browser = "chrome",
  chromever = "105.0.5195.52")

client <- rD[["client"]]

client$maxWindowSize()
# client$setWindowSize(
#   width = 1600, height = 800
# )

functions$tasa_dolar_scotiabank()
functions$tasa_dolar_banreservas(client)
functions$tasa_dolar_popular(client)
functions$tasa_dolar_bhd(client)
functions$tasa_dolar_santa_cruz(client)
functions$tasa_dolar_caribe(client)
functions$tasa_dolar_bdi()
functions$tasa_dolar_vimenca(client)
