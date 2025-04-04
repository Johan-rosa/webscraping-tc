quarto::quarto_render(input = "docs/index.qmd")
quarto::quarto_render(input = "pdf-report/index.qmd")

pagedown::chrome_print("pdf-report/index.html", "Sonde mercado cambiario.pdf")
