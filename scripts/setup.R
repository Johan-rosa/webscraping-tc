
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
client$maxWindowSize()

client$navigate("https://www.bancovimenca.com/")

tasas_banner <- client$findElement(
  using = "xpath",
  "/html/body/header/div[1]/div/div[1]/div/div[1]/div[4]/a"
)

tasas_banner$clickElement()

tasa_compra <- client$findElement(
  using = "css selector",
  "#exangeRates > li:nth-child(1) > div > div > div:nth-child(2) > article"
)
tasa_venta <- client$findElement(
  using = "css selector",
  "#exangeRates > li:nth-child(1) > div > div > div:nth-child(3) > article"
)

readr::parse_number(unlist(tasa_compra$getElementText()))
readr::parse_number(unlist(tasa_venta$getElementText()))
