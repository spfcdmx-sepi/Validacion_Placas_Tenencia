rm(list = ls())
library(data.table)
library(tidyverse)
library(haven)
cat('\014')
#===============================================================================
# ARCHIVOS DE 1-1000000
#===============================================================================
# CARPETA <- paste0(getwd(),'/Resultados_Validacion/Resultados_1_1000000')
# ARCHIVOS <- list.files(path = CARPETA, pattern = '.rda', full.names = T) %>% str_sort(numeric = T)
#-------------------------------------------------------------------------------
# tiempo = proc.time()
# for (i in seq_along(ARCHIVOS)) {
#    if (i > 1) {
#       load(ARCHIVOS[i])
#       AUX <- VALIDACION_PLACA
#       
#       VALIDACION <- rbind(VALIDACION, AUX)
#       
#       rm(AUX,VALIDACION_PLACA)
#    } else {
#       load(ARCHIVOS[i])
#       
#       VALIDACION <- VALIDACION_PLACA
#       
#       rm(VALIDACION_PLACA)
#    }
# }
# proc.time()-tiempo
#-------------------------------------------------------------------------------
# ESTATUS_PLACA <- VALIDACION %>%
#   group_by(estatus) %>%
#   tally(name = 'obs')
#-------------------------------------------------------------------------------
# save(VALIDACION, file = 'Resultados_Validacion/Validacion_Placas_1-1000000.rda')
#===============================================================================
# TERMINADO: ARCHIVOS DE 1000001-2000000
#===============================================================================
# CARPETA <- paste0(getwd(),'/Resultados_Validacion/Resultados_1000001_2000000')
# ARCHIVOS <- list.files(path = CARPETA, pattern = '.rda', full.names = T) %>% str_sort(numeric = T)
#-------------------------------------------------------------------------------
# tiempo = proc.time()
# for (i in seq_along(ARCHIVOS)) {
#   if (i > 1) {
#     load(ARCHIVOS[i])
#     AUX <- VALIDACION_PLACA
#     
#     VALIDACION <- rbind(VALIDACION, AUX)
#     
#     rm(AUX,VALIDACION_PLACA)
#   } else {
#     load(ARCHIVOS[i])
#     
#     VALIDACION <- VALIDACION_PLACA
#     
#     rm(VALIDACION_PLACA)
#   }
# }
# proc.time()-tiempo
#-------------------------------------------------------------------------------
# ESTATUS_PLACA <- VALIDACION %>%
#   group_by(estatus) %>%
#   tally(name = 'obs')
#-------------------------------------------------------------------------------
# save(VALIDACION, file = 'Resultados_Validacion/Validacion_Placas_1000001-2000000.rda')
#===============================================================================
# ARCHIVOS DE 2000001_3000000
#===============================================================================
CARPETA <- paste0(getwd(),'/Resultados_Validacion/Resultados_2000001-3000000')
ARCHIVOS <- list.files(path = CARPETA, pattern = '.rda', full.names = T) %>% str_sort(numeric = T)
#-------------------------------------------------------------------------------
tiempo = proc.time()
for (i in seq_along(ARCHIVOS)) {
  if (i > 1) {
    load(ARCHIVOS[i])
    AUX <- VALIDACION_PLACA
    
    VALIDACION <- rbind(VALIDACION, AUX)
    
    rm(AUX,VALIDACION_PLACA)
  } else {
    load(ARCHIVOS[i])
    
    VALIDACION <- VALIDACION_PLACA
    
    rm(VALIDACION_PLACA)
  }
}
proc.time()-tiempo
#-------------------------------------------------------------------------------
ESTATUS_PLACA <- VALIDACION %>%
  group_by(estatus) %>%
  tally(name = 'obs')
#-------------------------------------------------------------------------------
save(VALIDACION, file = 'Resultados_Validacion/Validacion_Placas_2000001-3000000.rda')
#===============================================================================
# ARCHIVOS DE 3000001-4000000
#===============================================================================
CARPETA <- paste0(getwd(),'/Resultados_Validacion/Resultados_3000001-4000000')
ARCHIVOS <- list.files(path = CARPETA, pattern = '.rda', full.names = T) %>% str_sort(numeric = T)
#-------------------------------------------------------------------------------
tiempo = proc.time()
for (i in seq_along(ARCHIVOS)) {
  if (i > 1) {
    load(ARCHIVOS[i])
    AUX <- VALIDACION_PLACA
    
    VALIDACION <- rbind(VALIDACION, AUX)
    
    rm(AUX,VALIDACION_PLACA)
  } else {
    load(ARCHIVOS[i])
    
    VALIDACION <- VALIDACION_PLACA
    
    rm(VALIDACION_PLACA)
  }
}
proc.time()-tiempo
#-------------------------------------------------------------------------------
ESTATUS_PLACA <- VALIDACION %>%
  group_by(estatus) %>%
  tally(name = 'obs')
#-------------------------------------------------------------------------------
save(VALIDACION, file = 'Resultados_Validacion/Validacion_Placas_3000001-4000000.rda')
#===============================================================================
# BUSCAR PLACA EN PARTICULAR
#===============================================================================
# PLACA <- read_dta('PLACA_auxiliares_tenencia_15-21.dta')
# PLACA <- PLACA %>%
#   rename(placa = nplaca) %>%
#   mutate(nplaca = nchar(placa)) %>%
#   filter(nplaca >= 2)
# OBS_PLACA <- c(grep('581TAZ', PLACA$placa))
# BASE_OBS_PLACA <- PLACA[c(OBS_PLACA),]
#-------------------------------------------------------------------------------                    
# load('Resultados_Validacion/Validacion_Placas_Auxiliar-2021.rda')
# VALIDACION <- anti_join(VALIDACION, PLACA, by = 'placa')
# save(VALIDACION, file = 'Validacion_Placas_Auxiliar-2021.rda')


