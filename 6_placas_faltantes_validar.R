rm(list = ls())
library(data.table)
library(tidyverse)
library(haven)
cat('\014')
#===============================================================================
# PLACAS TOTALES: 1-1000000
#===============================================================================
# PLACAS <- read_dta('Resultados_Validacion/Resultados_1_1000000/PLACAS_auxiliares_tenencia_1-1000000.dta')
#===============================================================================
# PLACAS TOTALES: 1000001-2000000
#===============================================================================
# PLACAS <- read_dta('Resultados_Validacion/Resultados_1000001_2000000/PLACAS_auxiliares_tenencia_1000001-2000000.dta')
#===============================================================================
# PLACAS TOTALES: 2000001-3000000
#===============================================================================
PLACAS <- read_dta('Resultados_Validacion/Resultados_2000001-3000000/PLACAS_auxiliares_tenencia_2000001-3000000.dta')
#===============================================================================
# PLACAS TOTALES: 3000001-4000000
#===============================================================================
# PLACAS <- read_dta('Resultados_Validacion/Resultados_3000001_4000000/PLACAS_auxiliares_tenencia_3000001-4000000.dta')
#===============================================================================
# PLACAS TOTALES: 4000001-4011670
#===============================================================================
# PLACAS <- read_dta('Resultados_Validacion/Resultados_4000001_4011670/PLACAS_auxiliares_tenencia_4000001-4011670.dta')
#-------------------------------------------------------------------------------
# 1
# CARPETA <- paste0(getwd(),'/Resultados_Validacion/Resultados_1_1000000')
# CARPETA <- paste0(getwd(),'/Resultados_Validacion/Resultados_1000001_2000000')
CARPETA <- paste0(getwd(),'/Resultados_Validacion/Resultados_2000001-3000000')
# CARPETA <- paste0(getwd(),'/Resultados_Validacion/Resultados_3000001_4000000')
ARCHIVOS <- list.files(path = CARPETA, pattern = '.rda', full.names = T) %>% str_sort(numeric = T)
ARCHIVOS
ARCHIVOS <- ARCHIVOS[50:54]
ARCHIVOS
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
PLACAS_VALIDADAS <- VALIDACION %>%
  group_by(placa) %>%
  tally(name = 'obs')
#-------------------------------------------------------------------------------
# VARIABLES DE SOBRA
#-------------------------------------------------------------------------------
# MERGE <- PLACAS %>% 
#   mutate(base = 'Auxiliar') %>%
#   merge(PLACAS_VALIDADAS, by = 'placa', all = T)
# MERGE <- filter(MERGE, is.na(base))
#-------------------------------------------------------------------------------
# PLACAS_FALTANTES <- merge(PLACAS, VALIDACION, by = 'placa', all.y = T)
# PLACAS_FALTANTES <- filter(PLACAS_FALTANTES, is.na(estatus))
PLACAS_FALTANTES <- anti_join(PLACAS, PLACAS_VALIDADAS, by = 'placa')
#-------------------------------------------------------------------------------
# write_dta(PLACAS_FALTANTES,'PLACAS_Faltantes_1-1000000.dta',version = 14L)
# write_dta(PLACAS_FALTANTES,'PLACAS_Faltantes_1000001-2000000.dta',version = 14L)
write_dta(PLACAS_FALTANTES,'PLACAS_Faltantes_2500001-2550000.dta',version = 14L)
#-------------------------------------------------------------------------------
# 2
#-------------------------------------------------------------------------------
VALIDACION_PLACA <- fread('Placa_Faltantes_Tenencia_1000001_2000000.csv')
save(VALIDACION_PLACA, file = 'Placa_Faltantes_Tenencia_1000001_2000000.rda')
#-------------------------------------------------------------------------------
# 3
#-------------------------------------------------------------------------------
PLACAS <- read_dta('Resultados_Validacion/Resultados_1000001_2000000/PLACAS_auxiliares_tenencia_1000001-2000000.dta')
#-------------------------------------------------------------------------------
CARPETA <- paste0(getwd(),'/Resultados_Validacion/Resultados_1000001_2000000')
ARCHIVOS <- list.files(path = CARPETA, pattern = '.rda', full.names = T) %>% str_sort(numeric = T)
ARCHIVOS
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
VALIDACION <- merge(VALIDACION, PLACAS, by = 'placa')
#-------------------------------------------------------------------------------
PLACAS_UNICAS <- VALIDACION %>%
  group_by(placa) %>%
  tally(name = 'obs')
#-------------------------------------------------------------------------------
ESTATUS_PLACA <- VALIDACION %>%
  group_by(estatus) %>%
  tally(name = 'obs')
#-------------------------------------------------------------------------------
save(VALIDACION, file = 'Resultados_Validacion/Validacion_Placas_1000001_2000000.rda')
