box::use(
  stringr[str_detect],
  dplyr[filter, select, mutate, arrange, group_by, ungroup, rename, left_join],
)

#' Read and process exchange rate data
#'
#' This function loads historical exchange rate data from one of two sources 
#' ("banks" or "infodolar"), processes the data, and calculates changes and 
#' gaps relative to a benchmark lag.
#'
#' @param source Character string indicating the data source. Options are 
#' `"banks"` (default) or `"infodolar"`.
#' @param benchmark_lag Integer specifying the number of days to lag for 
#' comparison. Defaults to 1.
#'
#' @return A data frame with the following columns:
#' \describe{
#'   \item{date}{Current observation date.}
#'   \item{lag_date}{Date used for lagged values.}
#'   \item{entidad}{Name of the financial institution.}
#'   \item{buy}{Current buy rate.}
#'   \item{lag_buy}{Lagged buy rate.}
#'   \item{sell}{Current sell rate.}
#'   \item{lag_sell}{Lagged sell rate.}
#'   \item{gap}{Difference between current sell and buy rates.}
#'   \item{lag_gap}{Difference between lagged sell and buy rates.}
#'   \item{d_sell}{Change in sell rate compared to lag.}
#'   \item{d_buy}{Change in buy rate compared to lag.}
#' }
#'
#' @examples
#' \dontrun{
#'   read_tc_data("banks", benchmark_lag = 2)
#'   read_tc_data("infodolar")
#' }
#' 
#' @export
read_tc_data <- function(source = c("banks", "infodolar"), benchmark_lag = 1) {
  source <- match.arg(source)

  file_path <- switch(
    source,
    banks = "data/from_banks/_historico_from_banks.rds",
    infodolar = "data/infodolar/_historico_infodolar.rds"
  )

  raw_data <- readRDS(here::here(file_path))

  if (source == "infodolar") {
    raw_data <- select(raw_data, date, entidad, buy = compra, sell = venta)
  } else {
    raw_data <- raw_data |> 
      dplyr::filter(
        # Remover una de las tasas de scotia
        is.na(tipo) |
        str_detect(tipo, "Digitales")
      ) |>
      select(-tipo) |>
      rename(entidad = bank)
  }
  
  current_data <- raw_data |>
    arrange(date)
  
  lagged_data <- current_data |>
    mutate(
      lag_date = date,
      date = date + benchmark_lag
    ) |>
    rename(lag_buy = buy, lag_sell = sell)

  current_data |>
    left_join(lagged_data, by = c("date", "entidad")) |>
    mutate(
      gap = sell - buy,
      lag_gap = lag_sell - lag_buy,
      d_sell = sell - lag_sell,
      d_buy = buy - lag_buy,
    ) |>
    select(date, lag_date, entidad, buy, lag_buy, sell, lag_sell, gap, lag_gap, d_sell, d_buy)
}

