rm(list = ls())
library(tidyverse)
library(openxlsx)
#-------------------------------------------------------------------------------
load('Validacion_Placa.rda')
#-------------------------------------------------------------------------------
VALIDACION$estatus_plot <- substr(VALIDACION$estatus,1,14)
VALIDACION$estatus_plot <- ifelse(VALIDACION$estatus_plot != 'Placa anterior',
                                        VALIDACION$estatus,
                                        VALIDACION$estatus_plot)
ls.str(VALIDACION)
#-------------------------------------------------------------------------------
VALIDACION$estatus <- ifelse(VALIDACION$placa == 'Z84ACW',
                             'El número de placa no se localizó en el padrón',
                             VALIDACION$estatus)
VALIDACION$estatus_plot <- ifelse(VALIDACION$placa == 'Z84ACW',
                                  'El número de placa no se localizó en el padrón',
                                  VALIDACION$estatus_plot)

VALIDACION$estatus <- ifelse(VALIDACION$placa == 'Z84ADW',
                             'El número de placa no se localizó en el padrón',
                             VALIDACION$estatus)
VALIDACION$estatus_plot <- ifelse(VALIDACION$placa == 'Z84ADW',
                                  'El número de placa no se localizó en el padrón',
                                  VALIDACION$estatus_plot)

VALIDACION$estatus <- ifelse(VALIDACION$placa == 'Z84AEP',
                             'El número de placa no se localizó en el padrón',
                             VALIDACION$estatus)
VALIDACION$estatus_plot <- ifelse(VALIDACION$placa == 'Z84AEP',
                                  'El número de placa no se localizó en el padrón',
                                  VALIDACION$estatus_plot)

VALIDACION$estatus <- ifelse(VALIDACION$placa == 'Z84AGA',
                             'El número de placa no se localizó en el padrón',
                             VALIDACION$estatus)
VALIDACION$estatus_plot <- ifelse(VALIDACION$placa == 'Z84AGA',
                                  'El número de placa no se localizó en el padrón',
                                  VALIDACION$estatus_plot)

VALIDACION$estatus <- ifelse(VALIDACION$placa == 'Z84AGZ',
                             'El número de placa no se localizó en el padrón',
                             VALIDACION$estatus)
VALIDACION$estatus_plot <- ifelse(VALIDACION$placa == 'Z84AGZ',
                                  'El número de placa no se localizó en el padrón',
                                  VALIDACION$estatus_plot)
#-------------------------------------------------------------------------------
ESTATUS_PLACA <- VALIDACION %>%
  group_by(estatus_plot) %>%
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
           row.names = F,
           overwrite = T)
#-------------------------------------------------------------------------------

