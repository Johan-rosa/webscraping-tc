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
summary_cards <- function(values, benchmark = "ayer") {
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
          tags$span(class = "stat-previous", glue("{benchmark}: DOP {values$lag_buy}"))
        )
      )
    ),
    
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
          tags$span(class = "stat-previous", glue("{benchmark}: DOP {values$lag_sell}"))
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
        date = colDef(show = FALSE),
        entidad = colDef(name = "Entidad", footer = "Promedio"),
        sell = colDef(
          name = "Venta",
          align = "right",
          cell = \(sell, index, col_name) {
            value_change_span(tasas_to_table, sell, col_name, index)
          },
          footer = \(values, name) {
            average_change_span(tasas_to_table, name)
          }
        ),
        buy = colDef(
          name = "Compra",
          align = "right",
          cell = \(buy, index, col_name) {
            value_change_span(tasas_to_table, buy, col_name, index)
          },
          footer = \(values, name) {
            average_change_span(tasas_to_table, name)
          }
        ),
        gap = colDef(
          name = "Margen",
          footer = \(values) {
            round(mean(values, na.rm = TRUE), 2)
        })
      )
    )
}

value_change_span <- function(data, value, column, index) {
  if (is.na(value)) return("")

  lag_column <- data[[glue("lag_{column}")]][index] 
  d_column <- data[[glue("d_{column}")]][index] 
  trend_icon <-  trend_indicator(d_column)

  sign <- case_when(
    d_column == 0 ~ "=",
    d_column  > 0 ~ "+",
    d_column  < 0 ~ "",
  )
  
  d_column <- scales::comma(d_column, 0.01, prefix = sign)
  value <- scales::comma(value, 0.01)

  span(
    span(span(style="margin-right: 3px; display: inline-block;", trend_icon), value),
    span(class = "var", style="color: #6a7282; margin-left: 5px;", glue("({d_column})"))
  )
}

average_change_span <- function(data, column) {
  value <- data[[column]] |> mean(na.rm = TRUE)
  d_value <- data[[glue("d_{column}")]] |>  mean(na.rm = TRUE)
  trend_icon <-  trend_indicator(d_value)
  
  sign <- case_when(
    d_value == 0 ~ "=",
    d_value  > 0 ~ "+",
    d_value  < 0 ~ "",
  )
  
  d_column <- scales::comma(d_value, 0.01, prefix = sign)
  value <- scales::comma(value, 0.01)
  
  span(
    span(span(style="margin-right: 3px; display: inline-block;", trend_icon), value),
    span(class = "var", style="color: #6a7282; margin-left: 5px;", glue("({d_column})"))
  )
  
}

