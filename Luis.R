rm(list = ls())
library(data.table)
library(tidyverse)
library(haven)
cat('\014')
#-------------------------------------------------------------------------------
CARPETRA <- 'Placas_Validadas_Luis/'
ARCHIVOS <- list.files(path = CARPETRA, pattern = '.csv', full.names = T) %>% str_sort(numeric = T)
#-------------------------------------------------------------------------------
tiempo = proc.time()
for (i in seq_along(ARCHIVOS)) {
  if (i > 1) {
    
    AUX <- fread(ARCHIVOS[i],
                 encoding = 'Latin-1')
    
    VALIDACION <- rbind(VALIDACION, AUX)
  } else {
    VALIDACION <- fread(ARCHIVOS[i],
                        encoding = 'Latin-1')
  }
}
proc.time()-tiempo
#-------------------------------------------------------------------------------
ARCHIVOS
write.csv(VALIDACION,'Validacion_Placa_Tenencia_2000000-2017550.csv',fileEncoding = 'Latin1',row.names = F)


