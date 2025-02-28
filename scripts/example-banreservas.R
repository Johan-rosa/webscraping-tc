# Script to get exchange rates from Banreservas

# Load required packages
library(RSelenium)
library(dplyr)
library(readr)


#' Descarga la tasa de cambio de Banreservas
#' @export
tasa_dolar_banreservas <- function(selenium_client) {
  selenium_client$navigate('https://www.banreservas.com/')
  Sys.sleep(2)
  
  tasa_compra <- selenium_client$findElement(
    using = "css selector", 
    "#site-nav-panel > ul:nth-child(1) > li:nth-child(2) > span"
  )
  
  tasa_venta <- selenium_client$findElement(
    using = "css selector", 
    "#site-nav-panel > ul:nth-child(1) > li:nth-child(3) > span"
  )
  
  compra <- tasa_compra$getElementText() |>
    unlist() |>
    readr::parse_number()
  
  venta <- tasa_venta$getElementText() |>
    unlist() |> 
    readr::parse_number()
  
  data.frame(
    date = Sys.Date(),
    bank = "Banreservas",
    buy = compra,
    sell = venta
  )
}

# Main script execution
main <- function() {
  # Set up RSelenium
  cat("Starting Selenium server...\n")
  
  # In GitHub Actions, we need to run Chrome in headless mode
  chrome_options <- list(
    chromeOptions = list(
      args = c('--headless', '--no-sandbox', '--disable-dev-shm-usage')
    )
  )
  
  # Start the Selenium server and browser
  driver <- rsDriver(
    browser = "chrome",
    port = 4444L,
    chromever = NULL,  # Auto-detect Chrome version
    extraCapabilities = chrome_options
  )
  
  # Get the client object
  client <- driver$client
  
  tryCatch({
    cat("Fetching exchange rates from Banreservas...\n")
    # Call your function
    rates <- tasa_dolar_banreservas(client)
    
    # Print results
    print(rates)
    
    # Save results to CSV
    write_csv(rates, paste0("banreservas_rates_", Sys.Date(), ".csv"))
    cat("Exchange rates saved to CSV file.\n")
  }, 
  error = function(e) {
    cat("Error occurred: ", conditionMessage(e), "\n")
  },
  finally = {
    # Clean up
    cat("Closing Selenium session...\n")
    client$close()
    driver$server$stop()
  })
}

# Run the main function
main()
