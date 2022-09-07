
# Checkout chrome version
system2(
  command = "wmic",
  args = 'datafile where name="C:\\\\Program Files (x86)\\\\Google\\\\Chrome\\\\Application\\\\chrome.exe" get Version /value')

binman::list_versions(appname = "chromedriver")

# Set the correct chrome version based on previous result
rD <- RSelenium::rsDriver(
  browser = "chrome",
  chromever = "105.0.5195.52")

client <- rD[["client"]]

client$navigate("https://www.bhdleon.com.do/wps/portal/BHD/Inicio/")
client$maxWindowSize()


tasas_banner <- client$findElement(
  using = "css selector", 
  "#footer > section > div > ul > li:nth-child(5)"
)

tasas_banner$clickElement()

tasa_compra <- client$findElement(
  using = "css selector",
  "#TasasDeCambio > table > tbody > tr:nth-child(2) > td:nth-child(2)"
)
tasa_venta <- client$findElement(
  using = "css selector",
  "#TasasDeCambio > table > tbody > tr:nth-child(2) > td:nth-child(3)"
)

tasa_compra$getElementText()
tasa_venta$getElementText()
