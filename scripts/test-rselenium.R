install.packages(
  c(
    "RSelenium",
    "glue",
    "logger"
  )
)

library(RSelenium)
library(logger)

log_info("Init driver")

rD <- RSelenium::rsDriver(
  browser = "chrome",
  port = 4444L
)

client <- rD[["client"]]

log_info("Navigate")
page <- "https://en.wikipedia.org/wiki/Hadley_Wickham"
client$navigate(page)

log_info("Get element")
title <- remDr$findElement("css selector", ".mw-page-title-main")

log_success(title$getElementText())
