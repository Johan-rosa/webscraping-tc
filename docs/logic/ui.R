box::use(
  htmltools[tags],
  glue[glue],
  dplyr[
    mutate,
    across,
    everything,
  ],
  scales[comma],
)

sign <- function(value) {
  dplyr::case_when(
    value == 0 ~ "=",
    value  > 0 ~ "+",
    value  < 0 ~ "",
  )
}

change_class <- function(value) {
  dplyr::case_when(
    value == 0 ~ "",
    value  > 0 ~ "increase",
    value  < 0 ~ "decrease"
  )
}

#' @export
summary_cards <- function(values) {
  checkmate::assert_names(
    names(values),
    subset.of = c(
      "buy", "sell", "gap", 
      "lag_buy", "lag_sell", "lag_gap", 
      "d_sell","d_buy", 
      "n_banks"
    )
  )
  
  values <- values |>
    mutate(
      across(everything(), \(x) round(x, 2)),
      across(c(buy, sell, lag_buy, lag_sell), \(x) comma(x, 0.01))
    )

  tags$dl(
    class = "stats-container",
    
    tags$div(
      tags$div(
        class = "stat-header",
        tags$dt(class = "stat-name", "Tasa de venta"),
        tags$div(
          class = glue("stat-change {change_class(values$d_sell)}"),
          glue("{sign(values$d_sell)}{values$d_sell}")
        )
      ),
      tags$dd(
        class = "stat-details",
        tags$div(
          class = "stat-value",
          glue("DOP {values$sell}"),
          tags$span(class = "stat-previous", glue("ayer: DOP {values$lag_sell}"))
        )
      )
    ),
    
    tags$div(
      tags$div(
        class = "stat-header",
        tags$dt(class = "stat-name", "Tasa de compra"),
        tags$div(
          class = glue("stat-change {change_class(values$d_buy)}"),
          glue("{sign(values$d_sell)}{values$d_buy}")
        )
      ),
      tags$dd(
        class = "stat-details",
        tags$div(
          class = "stat-value",
          glue("DOP {values$buy}"),
          tags$span(class = "stat-previous", glue("ayer: DOP {values$lag_buy}"))
        )
      )
    ),
    
    tags$div(
      tags$dt(class = "stat-name", "Entidades consultadas"),
      tags$dd(
        class = "stat-details",
        tags$div(
          class = "stat-value",
          values$n_banks
        )
      )
    )
  )
}

#' Icon to indicate trend: unchanged, up, down, or new
#' @export
trend_indicator <- function(variation) {
  value <- dplyr::case_when(
    variation == 0 ~ "unchanged",
    variation  > 0 ~ "up",
    variation   < 0 ~ "down"
  )
  
  label <- switch(
    value,
    unchanged = "Unchanged",
    up = "Trending up",
    down = "Trending down", 
    new = "New"
  )
  
  # Add img role and tooltip/label for accessibility
  args <- list(role = "img", title = label)
  
  if (value == "unchanged") {
    args <- c(args, list("–", style = "color: #6B7280; font-weight: 700"))
  } else if (value == "up") {
    args <- c(args, list(shiny::icon("caret-up"), style = "color: #22C55E"))
  } else if (value == "down") {
    args <- c(args, list(shiny::icon("caret-down"), style = "color: #EF4444"))
  } else {
    args <- c(args, list(shiny::icon("circle"), style = "color: #2e77d0; font-size: 0.6rem"))
  }
  do.call(htmltools::tags$span, args)
}