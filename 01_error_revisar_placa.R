rm(list = ls())
library(data.table)
library(tidyverse)
library(haven)
cat('\014')

RANGO <- '670001-680000'

ERRORES <- fread(paste0('Validacion_Placa_Tenencia_',RANGO,'.csv'),
                 sep = ',',
                 showProgress = T,
                 encoding = 'Latin-1')

ERRORES <- filter(ERRORES, estatus == 'ERROR. Revisar Placa')

write_dta(ERRORES,paste0('ERROR_Validacion_',RANGO,'.dta'),version = 14L)


