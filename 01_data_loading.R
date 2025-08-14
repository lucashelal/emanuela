############################################################
# Script Name / Nome do Script: 01_data_loading.R
# Author / Autor: lucashelal
# Date / Data: 2025-08-14
# Purpose / Propósito: Load raw data based on config file / Carregar dados brutos conforme configuração
# Dependencies / Dependências: config/config.yml
# Usage / Uso: source("01_data_loading.R")
############################################################

install.packages("pacman")
install.packages("yaml")
install.packages("foreign")
library(foreign)

pacman::p_load(
    foreign, # DBF file reading
    yaml, # YAML file reading
    tidyverse, # Data manipulation and visualization
    lubridate, # Date and time manipulation
    janitor, # Data cleaning
    here, # File path management
    forcats, # Categorical variable handling
    stringr, # String manipulation
    purrr, # Functional programming
    tibble, # Tidy data frames
    readr, # Read and write data
    read.csv # Read CSV files
)

# 1. Load configuration
library(yaml)
config <- read_yaml("config/config.yml")

# 2. Convert DBFs to CSV

# DO2006.DBF to DO2025.DBF

dbf_files <- list.files(path = config$data_path, pattern = "\\.DBF$", full.names = TRUE) # chama a lista de arquivos DBF no repositório e guarda em dbf_files

for (dbf_file in dbf_files) {
    df <- read.dbf(dbf_file)
    # Salva o dataframe como CSV
    write.csv(df, file = sub("\\.DBF$", ".csv", dbf_file), row.names = FALSE)
}

# 3. Load raw data as panel 
raw_data <- list.files(path = config$output_path, pattern = "\\.csv$", full.names = TRUE) %>%
    map_df(~ read_csv(.x)) # Carrega os dados brutos como um painel (análise no tempo)

# EN: Data loaded and available in `raw_data`
# PT: Dados carregados e disponíveis em `raw_data`