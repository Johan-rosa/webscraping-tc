
# Consultar la versión de Chrome instalada
system2(
  command = "wmic",
  args = 'datafile where name="C:\\\\Program Files (x86)\\\\Google\\\\Chrome\\\\Application\\\\chrome.exe" get Version /value')

# Consultar las versiones que soporta su instalación de Rselenium
binman::list_versions(appname = "chromedriver")

# Especificar la versión correcta de chrome basada en los resultados previos
rD <- RSelenium::rsDriver(
  browser = "chrome",
  chromever = "108.0.5359.22"
)
