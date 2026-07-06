#' @export
colores <- list(
  dark_gray  = "#595959",
  red        = "#cc0000",
  blue       = "#006699",
  green      = "#008080",
  gray       = "#bfbfbf",
  yellow     = "#F68F1C" 
)

#' Higcharter theme
#' 
#' Allow the user to add colors and axis titles
#' @export
chart_theme <- function(hc, colores, xtitle = NA, ytitle = NA) {
  hc |>
    highcharter::hc_colors(colores) |>
    highcharter::hc_xAxis(title = xtitle) |> 
    highcharter::hc_yAxis(title = ytitle)
}

#' @export
tc_chart <- function(
    tc_spot_long,
    variable = "tasa",
    chart_type = c("line", "column", "area"),
    show_legend = TRUE,
    height = NULL,
    title = NULL
) {
  chart_type <- match.arg(chart_type)
  
  tooltip_format <- glue::glue("{{series.name}}: <b>{{point.y:.2f}}</b>")
  yaxis_format   <- glue::glue("{{value:.2f}}")
  
  chart <- tc_spot_long |> 
    highcharter::hchart(chart_type, highcharter::hcaes(x = fecha, y = .data[[variable]],  group = type)) |>
    highcharter::hc_plotOptions(series = list(marker = list(enabled = FALSE))) |>
    chart_theme(colores = unname(unlist(colores))) |> 
    highcharter::hc_tooltip(pointFormat = tooltip_format) |>
    highcharter::hc_yAxis(labels = list(format = yaxis_format)) |>
    highcharter::hc_legend(enabled = show_legend)
  
  if (!is.null(height)) {
    chart <- chart |> highcharter::hc_size(height = height)
  }
  
  if (!is.null(title)) {
    chart <- highcharter::hc_title(chart, text = title)
  }
  
  chart
}