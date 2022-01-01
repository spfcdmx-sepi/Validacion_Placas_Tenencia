rm(list = ls())
library(data.table)
library(tidyverse)
library(haven)
cat('\014')

RANGO <- '3020001-3030000'

ERRORES <- fread(paste0('Validacion_Placa_Tenencia_',RANGO,'.csv'),
                 encoding = 'UTF-8')

ESTATUS <- ERRORES %>%
  group_by(estatus) %>%
  tally(name = 'obs')

ERRORES <- filter(ERRORES, estatus == 'ERROR. Revisar Placa')

write_dta(ERRORES,paste0('ERROR_Validacion_',RANGO,'.dta'),version = 14L)


