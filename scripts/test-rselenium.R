install.packages(
  c(
    "RSelenium",
    "glue",
    "logger"
  )
)

library(RSelenium)
library(logger)
library(glue)

log_info("Init driver")

rD <- RSelenium::rsDriver(
  browser = "firefox",
  port = 4444L
)

client <- rD[["client"]]

log_info("Navigate")
page <- "https://en.wikipedia.org/wiki/Hadley_Wickham"
client$navigate(page)

log_info("Get element")
title <- client$findElement(using = "css selector", ".mw-page-title-main")

log_success(title$getElementText() |> unlist())
