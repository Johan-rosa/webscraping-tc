box::use(
  htmltools[tags, span],
  glue[glue],
  dplyr[
    mutate,
    across,
    everything,
    case_when
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
  if (is.na(variation)) return()
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

#' @export
report_table <- function(tasas_to_table) {
  box::use(reactable[reactable, reactableTheme, colFormat, colDef])
  
  tasas_to_table |> 
    reactable(
      compact = TRUE,
      pagination = FALSE,
      defaultColDef = colDef(
        headerClass = "table-header",
        format = colFormat(separators = TRUE, digits = 2),
        minWidth = 50,
        footerStyle = list(fontWeight = "bold")
      ),
      class = "tasas-table",
      theme = reactableTheme(cellPadding = "8px 12px"),
      highlight = TRUE, 
      striped = TRUE,
      defaultSorted = list(buy = "desc"),
      columns = list(
        d_buy = colDef(show = FALSE),
        d_sell = colDef(show = FALSE),
        lag_buy = colDef(show = FALSE),
        lag_sell = colDef(show = FALSE),
        lag_gap = colDef(show = FALSE),
        lag_date = colDef(show = FALSE),
        entidad = colDef(name = "Entidad"),
        date = colDef(show = FALSE),
        sell = colDef(
          name = "Venta",
          align = "right",
          cell = \(sell, index) {
            if (is.na(sell)) return("")
            d_sell <- tasas_to_table$d_sell[index] 
            trend_icon <-  trend_indicator(d_sell)
            sign <- case_when(
              d_sell == 0 ~ "=",
              d_sell  > 0 ~ "+",
              d_sell  < 0 ~ "",
            )
            d_sell <- scales::comma(d_sell, 0.01, prefix = sign)
            sell <- scales::comma(sell, 0.01)
            span(
              span(span(style="margin-right: 3px; display: inline-block;", trend_icon), sell), 
              span(class = "var", style="color: #6a7282; margin-left: 5px;", glue("({d_sell})"))
            )
          }
        ),
        buy = colDef(
          name = "Compra",
          align = "right",
          cell = \(buy, index) {
            d_buy <- tasas_to_table$d_buy[index] 
            trend_icon <-  trend_indicator(d_buy)
            sign <- case_when(
              d_buy == 0 ~ "=",
              d_buy  > 0 ~ "+",
              d_buy  < 0 ~ "",
            )
            
            d_buy <- scales::comma(d_buy, 0.01, prefix = sign)
            buy <- scales::comma(buy, 0.01)
            span(
              span(span(style="margin-right: 3px; display: inline-block;", trend_icon), buy),
              span(class = "var", style="color: #6a7282; margin-left: 5px;", glue("({d_buy})"))
            )
          }
        ),
        gap = colDef(name = "Brecha")
      )
    )
}