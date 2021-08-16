rm(list = ls())
library(pacman)
p_load(RSelenium,
       tidyverse,
       haven)
cat('\014')
#===============================================================================
# CARGA DEL ARCHIVO CON LAS PLACAS A VALIDAR
#===============================================================================
PLACA <- read_dta('ERROR_Validacion_670001-680000.dta')
#===============================================================================
# ANALISIS DE LA BASE
# PLACA <- PLACA %>%
#   rename(placa = nplaca) %>%
#   mutate(nplaca = nchar(placa))
#-------------------------------------------------------------------------------
# PLACA <- filter(PLACA, nplaca >= 2)
# PLACA <- slice(PLACA, 4000000:nrow(PLACA))
# write_dta(PLACA,'PLACA_auxiliares_MacBook.dta',version = 14L)
#===============================================================================
# E UTILIZA EL NAVEGADOR FIREFOX
system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE)
#-------------------------------------------------------------------------------
profile <- makeFirefoxProfile(list(browser.download.folderList = 2L,
                                   browser.download.manager.showWhenStarting = FALSE,
                                   browser.helperApps.neverAsk.openFile = 'text/plain',
                                   browser.helperApps.neverAsk.saveToDisk = 'text/plain'))
#-------------------------------------------------------------------------------
rD <- RSelenium::rsDriver(browser = 'firefox',
                          port = 4444L,
                          verbose = F,
                          extraCapabilities = profile)
#-------------------------------------------------------------------------------
remDr <- rD[['client']]
remDr$navigate('https://data.finanzas.cdmx.gob.mx/consultas_pagos/consulta_adeudosten')
#-------------------------------------------------------------------------------
BASE_TENENCIA <- NULL
l <- nrow(PLACA)
tiempo = proc.time()
for (i in 1:l) {
  
  Sys.sleep(1)
  remDr$findElement(using = 'id', value = 'inputPlaca')$sendKeysToElement(list(PLACA$placa[i]))
  Sys.sleep(1)
  remDr$findElements(using = 'xpath', "//*/button[@class = 'btn btn-cdmx']")[[1]]$clickElement()
  Sys.sleep(9)
  
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
  
  # AÑOS DE ADEUDOS
  ADEUDOS <- try(length(remDr$findElements(using = "xpath", "//*[@class = 'list-group list-group-flush']/li")))
  
  # QUE AÑOS DEBE
  YEARS <- try(remDr$findElements(using = "xpath", "//*[@class = 'list-group list-group-flush']/li"))
  
  if (ESTATUS_1 != ""){
    ESTATUS <- ESTATUS_1
    PLACA_ANTERIOR <- NA
  }
  if (ESTATUS_2 != ""){
    ESTATUS <- ESTATUS_2
    PLACA_ANTERIOR <- NA
  }
  if (ESTATUS_3 != ""){
    ESTATUS <- ESTATUS_3
    PLACA_ANTERIOR <- NA
  }
  if (ESTATUS_4 != ""){
    ESTATUS <- ESTATUS_4
    PLACA_ANTERIOR <- NA
  }
  if (ESTATUS_5 != ""){
    ESTATUS <- ESTATUS_5
    PLACA_ANTERIOR <- NA
  }
  if (ESTATUS_6 != ""){
    ESTATUS <- ESTATUS_6
    PLACA_ANTERIOR <- NA
  }
  if (ESTATUS_7 != ""){
    ESTATUS <- ESTATUS_7
    PLACA_ANTERIOR <- NA
  }
  if (ESTATUS_8 != ""){
    ESTATUS <- ESTATUS_8
    PLACA_ANTERIOR <- NA
  }
  
  if (ESTATUS_4 != "" & ESTATUS_7 != ""){
    ESTATUS <- paste0('Cuenta con Placa Anterior y ', ESTATUS_7)
    PLACA_ANTERIOR <- substr(ESTATUS_4,17,nchar(ESTATUS_4))
  }
  
  if (ESTATUS_4 != "" & ESTATUS_1 != ""){
    ESTATUS <- paste0('Cuenta con Placa Anterior y ', ESTATUS_1)
    PLACA_ANTERIOR <- substr(ESTATUS_4,17,nchar(ESTATUS_4))
  }
  
  if (ESTATUS_1 == "" & ESTATUS_2 == "" & ESTATUS_3 == "" & ESTATUS_4 == "" & ESTATUS_5 == "" & ESTATUS_6 == "" & ESTATUS_7 == "" & ESTATUS_8 == ""){
    ESTATUS <- 'ERROR. Revisar Placa'
  }
  
  if (inherits(ADEUDOS, "try-error")){
    ADEUDOS <- 0
  } else {
    ADEUDOS <- ADEUDOS
  }
  
  if (inherits(YEARS, "try-error") | length(YEARS) == 0){
    YEARS <- 0
  } else {
    YEARS <- unlist(lapply(YEARS, function(x) x$getElementText()))
  }
  
  AUX_BASE <- data.frame(placa = PLACA$placa[i],
                         estatus = ESTATUS,
                         placa_anterior = PLACA_ANTERIOR,
                         years_adeudos = ADEUDOS,
                         years = YEARS)
  
  BASE_TENENCIA <- rbind(BASE_TENENCIA, AUX_BASE)
  
  print(paste0('Placa ',i,': ',PLACA$placa[i],'. Validada'))
  #remDr$findElement(using = 'id', value = 'inputPlaca')$clearElement()
  remDr$navigate('https://data.finanzas.cdmx.gob.mx/consultas_pagos/consulta_adeudosten')
  Sys.sleep(5)
  
  rm(ESTATUS, ADEUDOS, YEARS)
  
}
proc.time()-tiempo
#-------------------------------------------------------------------------------
remDr$quit()
system("taskkill /im java.exe /f", intern = F, ignore.stdout = F)
#===============================================================================
#save(BASE_TENENCIA, file = 'Validacion_Placa_Tenencia_1-100.rda')
BASE_TENENCIA <- filter(BASE_TENENCIA, estatus != 'ERROR. Revisar Placa')
write.csv(BASE_TENENCIA,'CORRECCION_Placa_Tenencia_670001-680000.csv',row.names = F,fileEncoding = 'Latin1')
#===============================================================================
PLACA <- anti_join(PLACA, BASE_TENENCIA, by = 'placa')
write_dta(PLACA,'ERROR_Validacion_670001-680000.dta',version = 14L)


