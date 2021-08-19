rm(list = ls())
library(data.table)
library(tidyverse)
library(haven)
cat('\014')

RANGO <- '670001-680000'

VALIDACION <- fread(paste0('Validacion_Placa_Tenencia_',RANGO,'.csv'),
                    sep = ',',
                    encoding = 'Latin-1',
                    showProgress = T)

CORRECCIONES <- fread(paste0('CORRECCION_Placa_Tenencia_',RANGO,'.csv'),
                      sep = ',',
                      encoding = 'Latin-1',
                      showProgress = T)

VALIDACION <- filter(VALIDACION, estatus != 'ERROR. Revisar Placa')

VALIDACION_PLACA <- rbind(VALIDACION, CORRECCIONES)

PLACAS <- VALIDACION_PLACA %>%
  group_by(placa) %>%
  tally(name = 'obs')

save(VALIDACION_PLACA,file = paste0('Resultados_Validacion_NewVersion//Validacion_Placa_',RANGO,'.rda'))


