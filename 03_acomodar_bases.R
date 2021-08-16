rm(list = ls())
library(data.table)
library(tidyverse)
library(haven)
cat('\014')

VALIDACION <- fread('Validacion_Placa_Tenencia_410001-420000.csv',
                    sep = ',',
                    encoding = 'Latin-1',
                    showProgress = T)

CORRECCIONES <- fread('CORRECCION_Placa_Tenencia_410001-420000.csv',
                      sep = ',',
                      encoding = 'Latin-1',
                      showProgress = T)

VALIDACION <- filter(VALIDACION, estatus != 'ERROR. Revisar Placa')

VALIDACION_PLACA <- rbind(VALIDACION, CORRECCIONES)
save(VALIDACION_PLACA,file = 'Resultados_Validacion/Validacion_Placa_410001-420000.rda')


