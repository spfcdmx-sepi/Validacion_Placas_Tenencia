rm(list = ls())
library(data.table)
library(tidyverse)
library(haven)
cat('\014')
#-------------------------------------------------------------------------------
CARPETA <- paste0(getwd(),'/Resultados_Validacion/')
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
PLACA <- VALIDACION %>%
  group_by(placa) %>%
  tally(name = 'obs')
#-------------------------------------------------------------------------------
save(VALIDACION, file = 'Validacion_Placa.rda')
#-------------------------------------------------------------------------------

