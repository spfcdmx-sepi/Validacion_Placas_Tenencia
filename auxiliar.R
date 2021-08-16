rm(list = ls())
library(data.table)
library(tidyverse)
library(haven)
cat('\014')

AUXILIAR <- fread('Base_Tenencia_11Ago21.csv',
                  showProgress = T,
                  encoding = 'Latin-1')
AUXILIAR <- data.table(AUXILIAR)

names(AUXILIAR)

PLACAS <- AUXILIAR %>%
  group_by(nplaca) %>%
  tally(name = 'obs')

load('Validacion_Placa.rda')
VALIDACION <- VALIDACION %>%
  filter(estatus == 'Adeudos' | estatus == 'Sin adeudos') %>%
  rename(estatus_scraping = estatus)

MERGE <- merge(AUXILIAR, VALIDACION, by.x = 'nplaca', by.y = 'placa')

write_dta(MERGE,'Tenencia_11Ago21.dta',version = 14L)
