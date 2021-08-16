rm(list = ls())
library(pacman)
p_load(RSelenium,
       tidyverse,
       lubridate,
       haven)
cat('\014')
#===============================================================================
# CARGA DEL ARCHIVO CON EL CURP
#===============================================================================
PLACA <- read_dta('C:/Users/jodop/OneDrive/Subdireccion_EPI/Auxiliares_Padrones_Bases/PLACA_auxiliares_tenencia_15-21.dta')
#===============================================================================
# ANALISIS DE LA BASE
PLACA <- PLACA %>%
  rename(placa = nplaca) %>%
  mutate(nplaca = nchar(placa))
#-------------------------------------------------------------------------------
PLACA <- PLACA %>%
  filter(nplaca >= 2)
#===============================================================================
# SE UTILIZA EL NAVEGADOR FIREFOX
system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE)
#-------------------------------------------------------------------------------
profile <- makeFirefoxProfile(list(browser.download.folderList = 2L,
                                   browser.download.manager.showWhenStarting = FALSE,
                                   browser.helperApps.neverAsk.openFile = 'text/plain',
                                   browser.helperApps.neverAsk.saveToDisk = 'text/plain'))
#-------------------------------------------------------------------------------
rD <- RSelenium::rsDriver(browser = 'firefox',
                          port = 4445L,
                          verbose = F,
                          extraCapabilities = profile)
#-------------------------------------------------------------------------------
remDr <- rD[['client']]
remDr$navigate('https://data.finanzas.cdmx.gob.mx/consultas_pagos/consulta_adeudosten')
#-------------------------------------------------------------------------------
ini <- 4006001
fin <- 4007000
#-------------------------------------------------------------------------------
BASE_TENENCIA <- NULL
l <- nrow(PLACA)
tiempo = proc.time()
for (i in ini:fin) {
  
  Sys.sleep(1)
  remDr$findElement(using = 'id', value = 'inputPlaca')$sendKeysToElement(list(PLACA$placa[i]))
  Sys.sleep(1)
  remDr$findElements(using = 'xpath', "//*/button[@class = 'btn btn-cdmx']")[[1]]$clickElement()
  Sys.sleep(7)
  
  # ESTATUS: Sin adeudos
  ESTATUS_1 <- remDr$findElements(using = 'xpath', '//*[@id="lbl_sin_adeudos"]/p')[[1]]$getElementText()[[1]]
  # ESTATUS: El número de placa no se localizó en el padrón
  ESTATUS_2 <- remDr$findElements(using = 'xpath', '//*[@id="lbl_consulta_pagos_class_010"]/p')[[1]]$getElementText()[[1]]
  # ESTATUS: VEHICULO CON ADEUDOS DE TENENCIA, FAVOR DE ACUDIR A LA ADMINISTRACION TRIBUTARIA MAS CERCANA A SU DOMICILIO
  ESTATUS_3 <- remDr$findElements(using = 'xpath', '//*[@id="lbl_consulta_pagos_class_008"]/span')[[1]]$getElementText()[[1]]
  # ESTATUS: Placa anterior
  ESTATUS_4 <- remDr$findElements(using = 'xpath', '//*[@id="lbl_placa_anterior"]/p')[[1]]$getElementText()[[1]]
  # ESTATUS: PLACA CON PROBLEMAS DE ADEUDOS DEL IMPUESTO SOBRE TENENCIA
  ESTATUS_5 <- remDr$findElements(using = 'xpath', '//*[@id="lbl_consulta_pagos_class_007"]/p')[[1]]$getElementText()[[1]]
  # ESTATUS: EL VEHICULO FUE LOCALIZADO EN EL PADRON FISCAL DEL DISTRITO FEDERAL CON ESTATUS BAJA
  ESTATUS_6 <- remDr$findElements(using = 'xpath', '//*[@id="lbl_consulta_pagos_class_012"]/span')[[1]]$getElementText()[[1]]
  # ESTATUS: Adeudos
  ESTATUS_7 <- remDr$findElements(using = 'xpath', '//*[@id="lbl_consulta_pagos_class_013"]/span')[[1]]$getElementText()[[1]]
  # ESTATUS: Vehiculo reportado por Fiscalizacion y no puede verificar
  ESTATUS_8 <- remDr$findElements(using = 'xpath', '//*[@id="lbl_consulta_pagos_class_011"]/p')[[1]]$getElementText()[[1]]
  
  if (ESTATUS_1 != ""){
    ESTATUS <- ESTATUS_1
  }
  if (ESTATUS_2 != ""){
    ESTATUS <- ESTATUS_2
  }
  if (ESTATUS_3 != ""){
    ESTATUS <- ESTATUS_3
  }
  if (ESTATUS_4 != ""){
    ESTATUS <- ESTATUS_4
  }
  if (ESTATUS_5 != ""){
    ESTATUS <- ESTATUS_5
  }
  if (ESTATUS_6 != ""){
    ESTATUS <- ESTATUS_6
  }
  if (ESTATUS_7 != ""){
    ESTATUS <- ESTATUS_7
  }
  if (ESTATUS_8 != ""){
    ESTATUS <- ESTATUS_8
  }
  
  if (ESTATUS_1 == "" & ESTATUS_2 == "" & ESTATUS_3 == "" & ESTATUS_4 == "" & ESTATUS_5 == "" & ESTATUS_6 == "" & ESTATUS_7 == "" & ESTATUS_8 == ""){
    ESTATUS <- 'ERROR. Revisar Placa'
  }
  
  AUX_BASE <- data.frame(placa = PLACA$placa[i],
                         estatus = ESTATUS)
  
  BASE_TENENCIA <- rbind(BASE_TENENCIA, AUX_BASE)
  
  print(paste0('Placa ',i,': ',PLACA$placa[i],'. Validada'))
  #remDr$findElement(using = 'id', value = 'inputPlaca')$clearElement()
  remDr$navigate('https://data.finanzas.cdmx.gob.mx/consultas_pagos/consulta_adeudosten')
  Sys.sleep(5)
  
  write.csv(BASE_TENENCIA,paste0('Validacion_Placa_Tenencia_',ini,'-',fin,'.csv'),row.names = F,fileEncoding = 'Latin1')
  
  rm(ESTATUS)
  
}
proc.time()-tiempo
#-------------------------------------------------------------------------------
remDr$quit()
system("taskkill /im java.exe /f", intern = F, ignore.stdout = F)
#===============================================================================


