rm(list = ls())
library(pacman)
p_load(tidyverse,
       haven,
       data.table)
cat('\014')
#-------------------------------------------------------------------------------
# CARGA DEL ARCHIVO CON LAS PLACAS A VALIDAR
#-------------------------------------------------------------------------------
PLACA <- read_dta('Bases/PLACA_auxiliares_tenencia_15-21.dta') %>%
  rename(placa = nplaca) %>%
  mutate(nplaca = nchar(placa)) %>%
  filter(nplaca >= 2)
#-------------------------------------------------------------------------------
# CARGA DE LAS PLACAS VALIDADAS
#-------------------------------------------------------------------------------
VALIDACION <- fread('Bases/Placas_Validadas_Auxiliar-Tenencia_2014-22Nov21_16Dec21.csv',
                    encoding = 'UTF-8')
#-------------------------------------------------------------------------------
# CARGA DEL AUXILIAR DE TENENCIA PARA VER LAS PLACAS NUEVAS
#-------------------------------------------------------------------------------
AUXILIAR <- fread('Bases/auxiliar_tenencia_01Ene21-20Dic21.txt',
                  sep = '|',
                  encoding = 'UTF-8')
PCANCL <- AUXILIAR %>%
  group_by(pcancl) %>%
  tally(name = 'obs')
AUXILIAR <- filter(AUXILIAR, pcancl != '0')
AUXILIAR <- filter(AUXILIAR, pcancl != 'C')
rm(PCANCL)
names(AUXILIAR)
AUXILIAR <- AUXILIAR %>%
  group_by(nplaca) %>%
  tally(name = 'obs') %>%
  rename(placa = nplaca) %>%
  mutate(nplaca = nchar(placa)) %>%
  filter(nplaca >= 2)
#-------------------------------------------------------------------------------
PLACAS_NUEVAS <- anti_join(AUXILIAR, PLACA, by = 'placa')
PLACAS_NUEVAS <- anti_join(PLACAS_NUEVAS, VALIDACION, by = 'placa') %>%
  arrange(placa)
PLACAS_NUEVAS <- dplyr::select(PLACAS_NUEVAS, placa)
#-------------------------------------------------------------------------------
write_dta(PLACAS_NUEVAS,'Placas_Nuevas_Tenencia_01Ene21-20Dic21.dta', version = 14L)


