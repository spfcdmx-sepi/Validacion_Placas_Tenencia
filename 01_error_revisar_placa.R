rm(list = ls())
library(data.table)
library(tidyverse)
library(haven)
cat('\014')

ERRORES <- fread('Validacion_Placa_Tenencia_670001-680000.csv',
                 sep = ',',
                 showProgress = T,
                 encoding = 'Latin-1')

ERRORES <- filter(ERRORES, estatus == 'ERROR. Revisar Placa')

write_dta(ERRORES,'ERROR_Validacion_670001-680000.dta',version = 14L)


