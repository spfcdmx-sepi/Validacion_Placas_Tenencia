rm(list = ls())
library(pacman)
p_load(RSelenium,
       tidyverse,
       haven,
       data.table)
cat('\014')
#-------------------------------------------------------------------------------
# CARGA DEL ARCHIVO CON LAS PLACAS FALTANTES
#-------------------------------------------------------------------------------
VALIDACION_PLACA <- fread('PLACAS_Faltantes_1-1000000.csv',
                           encoding = 'UTF-8')
#-------------------------------------------------------------------------------
ESTATUS_PLACAS <- VALIDACION_PLACA %>%
  group_by(estatus) %>%
  tally(name = 'obs')
#-------------------------------------------------------------------------------
save(VALIDACION_PLACA, file = 'PLACAS_Faltantes_1-1000000.rda')


