# Webscraping tasas de cambio de bancos múltiples

Este repositorio contiene una serie de herramientas y procedimientos para consultar y registrar las tasas de cambio en las páginas web de los bancos múltples de República Dominicana.

## Dependencias

- Google chrome: se utiliza este navegador para nevegar hacia las páginas que tienen las tasas como contenido dinámico en el sitio web
- Rselenium: como automatizador de navegadores
- Rvest: para leer el contenido de páginas estáticas

## Estructura del Proyecto

- `scripts/`: Contiene los scripts principales para la configuración y ejecución del web scraping.
  - `setup.R`: Configura la versión de Chrome y RSelenium.
  - `run_webscraping.R`: Ejecuta el proceso de web scraping.
  - `get_infodolar.R`: Obtiene la tabla de tasas de cambio desde infodolar.com.do.
- `data/`: Almacena los datos obtenidos en formato CSV y RDS.
  - `from_banks/`: Datos obtenidos de los bancos.
  - `infodolar/`: Datos obtenidos de infodolar.com.do.
- `renv/`: Configuración del entorno de R.
- `dependencies.R`: Script la lista de dependencias necesarias, util para `revn`

## Cómo utilizar

1. Instalar dependencias ubicadas en el script `./dependencies.R`
2. En Windows, detectar la versión de chrome a utilizar siguiendo los pasos del archivo `./script/setup.R`
3. Correr script `./scripts/run_webscraping.R`

## Usar la data en otros proyectos

Una alternativa rápida para usar la data en cualquier proyecto es leerla  directamente de github.

```r
get_tc_from_banks <- function() {
  URL <- paste0(
    "https://raw.githubusercontent.com/",
    "Johan-rosa/webscraping-tc/refs/heads/", 
    "main/data/from_banks/_historico_from_banks.csv"
  )
  readr::read_csv(URL)
}

get_tc_infordolar <- function() {
  URL <- paste0(
    "https://raw.githubusercontent.com/",
    "Johan-rosa/webscraping-tc/refs/heads/", 
    "main/data/infodolar/_historico_infodolar.csv"
  )
  readr::read_csv(URL)
}
```