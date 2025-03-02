# Webscraping tasas de cambio de bancos múltiples

Este repositorio contiene una serie de herramientas y procedimientos para consultar y registrar las tasas de cambio en las páginas web de los bancos múltples de República Dominicana.

## Dependencias

- Google chrome: se utiliza este navegador para nevegar hacia las páginas que tienen las tasas como contenido dinámico en el sitio web
- Rselenium: como automatizador de navegadores
- Rvest: para leer el contenido de páginas estáticas

# Cómo utilizar

1. Instalar dependencias ubicadas en el script `./dependencies.R`
2. En Windows, detectar la versión de chrome a utilizar siguiendo los pasos del archivo `./script/setup.R`
3. Correr script `./scripts/run_webscraping.R`