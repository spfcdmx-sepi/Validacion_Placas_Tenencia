rm(list = ls())
library(pacman)
p_load(RSelenium,
       tidyverse,
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
load('Bases/Validacion_Placas_Auxiliar-2021.rda')
#-------------------------------------------------------------------------------
# CARGA DEL AUXILIAR DE TENENCIA PARA VER LAS PLACAS NUEVAS
#-------------------------------------------------------------------------------
AUXILIAR <- fread('Bases/auxiliar_tenencia_01Ene21-22Nov21.txt',
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
#-------------------------------------------------------------------------------
write_dta(PLACAS_NUEVAS,'Placas_Nuevas_Tenencia_01Ene21-22Nov21.dta', version = 14L)


