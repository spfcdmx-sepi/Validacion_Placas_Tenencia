rm(list = ls())
library(tidyverse)
library(openxlsx)
library(haven)
cat('\014')
#===============================================================================
# CARGA DE LAS BASES FINALES DE LAS VALIDACIONES
#===============================================================================
load('Resultados_Validacion/Validacion_Placas_1-1000000.rda')
VALIDACION_PLACAS <- VALIDACION
load('Resultados_Validacion/Validacion_Placas_1000001-2000000.rda')
VALIDACION_PLACAS <- rbind(VALIDACION_PLACAS, VALIDACION)
load('Resultados_Validacion/Validacion_Placas_2000001-3000000.rda')
VALIDACION_PLACAS <- rbind(VALIDACION_PLACAS, VALIDACION)
load('Resultados_Validacion/Validacion_Placas_3000001-4000000.rda')
VALIDACION_PLACAS <- rbind(VALIDACION_PLACAS, VALIDACION)
load('Resultados_Validacion/Validacion_Placas_4000001-4011670.rda')
VALIDACION_PLACAS <- rbind(VALIDACION_PLACAS, VALIDACION)
load('Resultados_Validacion/Validacion_Placas_Nuevas_Auxiliar_01Ene21-30Sep21.rda')
VALIDACION_PLACAS <- rbind(VALIDACION_PLACAS, VALIDACION)
load('Resultados_Validacion/Validacion_Placas_Nuevas_Auxiliar_01Ene21-22Nov21.rda')
VALIDACION_PLACAS <- rbind(VALIDACION_PLACAS, VALIDACION)
rm(VALIDACION)
#-------------------------------------------------------------------------------
VALIDACION_PLACAS$placa_anterior <- ifelse(VALIDACION_PLACAS$placa_anterior == '', NA, VALIDACION_PLACAS$placa_anterior)
VALIDACION_PLACAS$years_adeudos <- ifelse(VALIDACION_PLACAS$years_adeudos == 0, NA, VALIDACION_PLACAS$years_adeudos)
VALIDACION_PLACAS$years <- ifelse(VALIDACION_PLACAS$years == 0, NA, VALIDACION_PLACAS$years)
#-------------------------------------------------------------------------------
# PLACAS <- VALIDACION_PLACAS %>%
#   group_by(placa) %>%
#   tally(name = 'obs')
#-------------------------------------------------------------------------------
names(VALIDACION_PLACAS)
#-------------------------------------------------------------------------------
VALIDACION_PLACAS <- VALIDACION_PLACAS %>%
  group_by(placa) %>% 
  arrange(years) %>% 
  mutate(ncol=row_number()) %>% 
  pivot_wider(names_from = ncol, 
              values_from=-c(placa,estatus,placa_anterior,years_adeudos))
#-------------------------------------------------------------------------------
VALIDACION_PLACAS <- dplyr::select(VALIDACION_PLACAS, placa,estatus,placa_anterior,years_adeudos, starts_with('years'))
colnames(VALIDACION_PLACAS)[5:ncol(VALIDACION_PLACAS)] <- gsub('s','',colnames(VALIDACION_PLACAS)[5:ncol(VALIDACION_PLACAS)])
#-------------------------------------------------------------------------------
# VARIABLES EN UTF-8
#-------------------------------------------------------------------------------
names(VALIDACION_PLACAS)
# Encoding(VALIDACION_PLACAS$placa) <- 'UTF-8'
# Encoding(VALIDACION_PLACAS$estatus) <- 'UTF-8'
# Encoding(VALIDACION_PLACAS$placa_anterior) <- 'UTF-8'
#-------------------------------------------------------------------------------
PLACAS <- VALIDACION_PLACAS %>%
  group_by(placa) %>%
  tally(name = 'obs')
#-------------------------------------------------------------------------------
VALIDACION_PLACAS <- arrange(VALIDACION_PLACAS, placa)
#-------------------------------------------------------------------------------
fecha <- Sys.Date()
fecha <- format(fecha,'%d%b%y')
write.csv(VALIDACION_PLACAS,paste0('Placas_Validadas_Auxiliar-Tenencia_2014-22Nov21_',fecha,'.csv'),row.names = F,fileEncoding = 'UTF-8')
# write_dta(VALIDACION_PLACAS,'Placas_Validadas_Auxiliar_2014-2020.dta',version = 14L)
#===============================================================================
# OBSERVACIONES DEL ESTATUS DE LA PLACA PARA LA GRAFICA
#===============================================================================
ESTATUS_PLACA <- VALIDACION_PLACAS %>%
  group_by(estatus) %>%
  tally(name = 'obs')
#-------------------------------------------------------------------------------
names(ESTATUS_PLACA) <- c('Estatus','Placas')
#-------------------------------------------------------------------------------
# VALIDACION <- VALIDACION %>%
#   filter(estatus_plot == 'Placa anterior' | estatus_plot == 'Adeudos') %>%
#   dplyr::select(placa)
# library(haven)
# VALIDACION_LIZ <- slice(VALIDACION, 1:180000)
# write_dta(VALIDACION_LIZ,'PLACAS.dta',version = 14L)
# VALIDACION_ERICK <- slice(VALIDACION, 180001:nrow(VALIDACION))
# write_dta(VALIDACION_ERICK,'PLACAS_ERICK.dta',version = 14L)
#-------------------------------------------------------------------------------
write.xlsx(ESTATUS_PLACA,
           'Resultados_Estatus_Placa.xlsx',
           rowNames = F,
           overwrite = T)
#-------------------------------------------------------------------------------

