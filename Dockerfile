# Use a base image with R and Selenium dependencies
FROM rocker/r-ver:4.1.1

# Install necessary system dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libgmp3-dev \
    libgit2-dev \
    libfontconfig1 \
    libxrender1 \
    libxtst6 \
    libxi6 \
    openjdk-11-jre-headless  # Install OpenJDK (Java Runtime Environment)

RUN R -e "install.packages('remotes')"

RUN R -e "remotes::install_github('rstudio/renv@0.15.5')"

RUN mkdir -p /home/webscraping_tc/data/daily

COPY renv.lock /home/webscraping_tc/renv.lock
COPY scripts /home/webscraping_tc/scripts

# Download and install the standalone Selenium server
RUN apt-get install -y wget \
    && wget https://selenium-release.storage.googleapis.com/3.141/selenium-server-standalone-3.141.59.jar \
    && mv selenium-server-standalone-3.141.59.jar /usr/local/bin/selenium-server.jar

# Copy the start script
COPY start.sh /usr/local/bin/start.sh

# Expose the port used by Selenium
EXPOSE 4444

# Make the start script executable
RUN chmod +x /usr/local/bin/start.sh

# Use the start script as the CMD
CMD ["/usr/local/bin/start.sh"]

# Run your R script
RUN R -e "setwd('/home/webscraping_tc');renv::init();renv::restore();source('scripts/run_webscraping.R')" 