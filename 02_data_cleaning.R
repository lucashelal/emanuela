############################################################
# Script Name / Nome do Script: 01_data_loading.R
# Author / Autor: lucashelal
# Date / Data: 2025-08-14
# Purpose / Propósito: Load raw data based on config file / Carregar dados brutos conforme configuração
# Dependencies / Dependências: config/config.yml
# Usage / Uso: source("01_data_loading.R")
# PATH db: data/raw/sim
# Harmonizing variable/join panel data (less NA observations) and unique ID from dt_final that should be used: `numerodo` OR `dtrecorig`
# Variables: should be in the same format for all datasets --> `numerodo` as numeric.
############################################################


library(yaml)
config <- yaml::read_yaml("config/config.yml")
raw_data <- read.csv(config$data_path, stringsAsFactors = FALSE)


library(foreign) # For reading DBF files
library(readr) # For reading CSV files
library(dplyr)
library(tidyr)
library(ggplot2)
library(janitor)
library(purrr)
library(here)
library(stringr)
library(lubridate)
library(tibble)

source("01_data_loading.R")

# 1. Data Cleaning and Wrangling

## 1.1. Mergeing DO2006.csv, DO2007.csv ... to DO2025.csv do_overall as panel data
## PATH: raw/sim

files <- list.files("data/raw/sim", pattern = "DO\\d{4}\\.csv", full.names = TRUE)
files

# 2. Listing variables name of a single file 

do_2006 <- read_csv("data/raw/sim/DO2006.csv")
names(do_2006)

variables_raw <- names(do_2006)

# 3. Wrangling variable names as an example

## RULES: a) tolower; b) remove spaces to _; c) remove special characters; d) preserve original syntax (codex MS)

do_2006_clean <- janitor::clean_names(do_2006)
glimpse(do_2006_clean)

### 3.1. Standardizing variables types (observations)

do_2006_clean <- do_2006_clean |>
  mutate(across(where(is.character), as.factor)) |>
  mutate(across(where(is.integer), as.numeric))

glimpse(do_2006_clean)
### 3.2. Removing all commas and artifacts from cells

do_2006_clean_2 <- do_2006_clean |>
  mutate(across(where(is.character), ~ str_replace_all(., ",", ""))) |>
  mutate(across(where(is.character), ~ str_replace_all(., "\\.", ""))) |>
  mutate(across(where(is.character), ~ str_replace_all(., "-", ""))) |>
  mutate(across(where(is.character), ~ str_trim(.)))

glimpse(do_2006_clean_2)

### 3.4. Converting date variables to date format yyyymmdd

do_2006_clean_3 <- do_2006_clean_2 |>
    mutate(across(c(dtrecorig, dtobito, dtrecebim,dtregcart,dtnasc,dtinvestig,dtcadastro,dtressele,dtatestado), ~ suppressWarnings(lubridate::ymd(.))))

glimpse(do_2006_clean_3)

### 3.5. Classifying string variables (VARIAVEIS JA ESTAO EM LETRA MINUSCULA SEM ASPAS)

strg <- c("nome", "nomepai", "codestres", "codmunres", "baires", "codbaires", "codendres",
          "endres", "linhaa", "linhab", "linhac", "linhad",
          "linhaii", "causabas", "medico",
          "tpassina", "comunsvoim", "contato",
          "circobito", "acidtrab", "fonte", "dsevento", "endacid", "linhaa_o", "linhab_o",
          "linhac_o", "linhad_o", "linhaii_o", "causabas_o", "dtcadastro",
          "atestante", "descacid", "codendacid", "numendacid", "complacid", "critica", "codinst", "stcodifica", "codificado",
          "retroalim", "fonteinv", "dtrecebim",
          "causabas_r", "dtressele", "stressele", "explica_r", "vrsressele",
          "compara_cb", "nressele", "cb_pre", "nproc", "dtrecorig", "causamat", "escmaeagr1", "escmaeagr2")


# 3.5.1. Classifying string variables (assign)

do_2006_clean_4 <- do_2006_clean_3 |>
  mutate(across(all_of(strg), as.character))

glimpse(do_2006_clean_4)

# 3.5.2. Classifying `endocor` as character and remove " " and `numerodo` as numeric

do_2006_clean_4 <- do_2006_clean_4 |>
  mutate(endocor = as.character(endocor)) |>
  mutate(endocor = str_remove_all(endocor, '"')) |>
  mutate(numerodo = as.numeric(numerodo))

# 3.5.3. Removing " " from `nome`, `nomepai`, `codestres`, `codmunres`, `baires`, `codbaires`, `codendres`, `endres`, `linhaa`, `linhab`, `linhac`, `linhad`, `linhaii`, `causabas`, `medico`, `tpassina`, `comunsvoim`, `contato`, `circobito`, `acidtrab`, `fonte`, `dsevento`, `endacid`, `linhaa_o`, `linhab_o`, `linhac_o`, `linhad_o`, `linhaii_o`, `causabas_o`, `dtcadastro`, `atestante`, `descacid`, `codendacid`, `numendacid`, `complacid`, `critica`, `codinst`, `stcodifica`, `codificado`, `retroalim`, `fonteinv`, `dtrecebim`, `causabas_r`, `dtressele`, `stressele`, `explica_r`, `vrsressele`, `compara_cb`, `nressele`, `cb_pre`, `nproc`, `dtrecorig`, `causamat`, `escmaeagr1`, `escmaeagr2`

do_2006_clean_5 <- do_2006_clean_4 |>
  mutate(across(all_of(strg), ~ str_remove_all(., '"')))

glimpse(do_2006_clean_5)

# 3.5.4. Removing spaces for _ in chr and other observations (EX: `nomepai` == "NAO DECLARADO" should be nao_declarado)
### pick manually variables to avoid error
### `nomepai`, `nome`, `codestres`, `codmunres`

do_2006_clean_6 <- do_2006_clean_5 |>
  mutate(across(c(nomepai, nome, codestres, codmunres), ~ str_replace_all(., " ", "_"))) |>
  mutate(across(c(nomepai, nome, codestres, codmunres), ~ str_to_lower(.))) |>
  mutate(across(c(nomepai, nome, codestres, codmunres), ~ str_replace_all(., "[^[:alnum:]_]", "")))

glimpse(do_2006_clean_6)

# 3.5.5. `idade` as numeric; `sexo` as factor (0 or 1); `racacor` as factor; `estciv` as factor; `esc` as factor; `esc2010` as factor

do_2006_clean_7 <- do_2006_clean_6 |>
  mutate(idade = as.numeric(idade)) |>
  mutate(sexo = as.factor(sexo)) |>
  mutate(racacor = as.factor(racacor)) |>
  mutate(estciv = as.factor(estciv)) |>
  mutate(esc = as.factor(esc)) |>
  mutate(esc2010 = as.factor(esc2010))

# recode sex for female == 0

do_2006_clean_7 <- do_2006_clean_7 |>
  mutate(sexo = recode(sexo, "F" = 0, "M" = 1))

glimpse(do_2006_clean_7)

# `stcodifica`, `codificado` as factor

do_2006_clean_7 <- do_2006_clean_7 |>
  mutate(stcodifica = as.factor(stcodifica)) |>
  mutate(codificado = as.factor(codificado))

# confpeso, confidade, confcausa, confcidade, critica as logical

do_2006_clean_8 <- do_2006_clean_7 |>
  mutate(across(c(confpeso, confidade, confcausa, confcidade, critica), as.logical))

glimpse(do_2006_clean_8)

# recode S == TRUE

# 3.6. Diagnosis of missing data (NA) as raw and % 

do_2006_clean_8 |>
  summarise(across(everything(), ~ sum(is.na(.)))) |>
  pivot_longer(everything(), names_to = "variable", values_to = "n_missing") |>
  filter(n_missing > 0) |>
  mutate(pct_missing = n_missing / nrow(do_2006_clean_8) * 100)
