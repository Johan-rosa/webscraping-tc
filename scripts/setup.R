
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

client$navigate("https://bancoademi.com.do/")

tasas_banner <- client$findElement(
  using = "xpath",
  "/html/body/section[1]/div/div/a[5]"
)
tasas_banner$clickElement()

tasa_compra <- client$findElement(
  using = "xpath",
  "/html/body/div[1]/div/div/div[2]/fieldset/div[1]/div[4]/div/input"
)
tasa_venta <- client$findElement(
  using = "xpath",
  "/html/body/div[1]/div/div/div[2]/fieldset/div[2]/div[4]/div/input"
)

readr::parse_number(unlist(tasa_compra$getElementText()))
readr::parse_number(unlist(tasa_venta$getElementText()))
