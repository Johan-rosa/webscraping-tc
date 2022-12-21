
# Checks chrome version
system2(
  command = "wmic",
  args = 'datafile where name="C:\\\\Program Files (x86)\\\\Google\\\\Chrome\\\\Application\\\\chrome.exe" get Version /value')

# Checks available to use
binman::list_versions(appname = "chromedriver")

# Set the correct chrome version based on previous result
rD <- RSelenium::rsDriver(
  browser = "chrome",
  chromever = "108.0.5359.22"
)
