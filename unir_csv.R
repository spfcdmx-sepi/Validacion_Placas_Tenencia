rm(list = ls())
library(tidyverse)
library(data.table)
cat('\014')

path_file <- getwd()
ARCHIVOS <- list.files(path = path_file, pattern = '.csv$', full.names = T) %>% str_sort(numeric = T)
ARCHIVOS

BASE_UNIDA <- NULL
for (i in seq_along(ARCHIVOS)) {
  
  if (i > 1){
    BASE <- fread(ARCHIVOS[i],
                  sep = ',',
                  encoding = 'Latin-1')
    BASE_UNIDA <- rbind(BASE_UNIDA, BASE)
  } else {
    BASE_UNIDA <- fread(ARCHIVOS[i],
                        sep = ',',
                        encoding = 'Latin-1')
  }
}

VAR_UNICAS <- BASE_UNIDA %>%
  group_by(placa) %>%
  tally(name = 'obs')

write.csv(BASE_UNIDA,'Validacion_Placa_Tenencia_120001-132000.csv',row.names = F,fileEncoding = 'Latin1')


