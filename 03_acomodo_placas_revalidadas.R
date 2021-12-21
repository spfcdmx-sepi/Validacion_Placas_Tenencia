rm(list = ls())
library(data.table)
library(tidyverse)
library(haven)
cat('\014')

RANGO <- '3020001-3030000'

VALIDACION <- fread(paste0('Validacion_Placa_Tenencia_',RANGO,'.csv'),
                    encoding = 'UTF-8')

CORRECCIONES <- fread(paste0('CORRECCION_Placa_Tenencia_',RANGO,'.csv'),
                      sep = ',',
                      encoding = 'UTF-8')

VALIDACION <- filter(VALIDACION, estatus != 'ERROR. Revisar Placa')

# VALIDACION_PLACA <- VALIDACION
VALIDACION_PLACA <- rbind(VALIDACION, CORRECCIONES)

ESTATUS <- VALIDACION_PLACA %>%
  group_by(estatus) %>%
  tally(name = 'obs')

PLACAS <- VALIDACION_PLACA %>%
  group_by(placa) %>%
  tally(name = 'obs')

save(VALIDACION_PLACA,file = paste0('Validacion_Placa_',RANGO,'.rda'))


