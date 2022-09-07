box::use(
  ./functions
)

rD <- RSelenium::rsDriver(
  browser = "chrome",
  chromever = "105.0.5195.52")

client <- rD[["client"]]

functions$tasa_dolar_scotiabank()
functions$tasa_dolar_banreservas(client)
functions$tasa_dolar_popular(client)
functions$tasa_dolar_bhd(client)
