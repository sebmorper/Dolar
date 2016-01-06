#######################################CLEANING DATA####################################

#####################################WORKING DIRECTORY##################################
### Set a working directory
directory <- "/Users/Sebastian/Documents/R/Dolar"
setwd(directory)

########################################PACKAGES########################################
require(tidyr)

######################################TRANSFORM#########################################
### Input data
tipo.cambio <- read.csv("./DATA/RAW/DolarInegi.csv")[10:374,1:2]
google.search <- read.csv("./DATA/RAW/GoogleTrends.csv")[5:630,1:2]
desocupacion <- read.csv("./DATA/RAW/Desocupacion.csv")[11:141,1:2]
exportaciones <- read.csv("./DATA/RAW/Exportaciones.csv")[11:559, 1:2]
exportacion.petrolera <- read.csv("./DATA/RAW/ExportacionPetrolera.csv")[12:418,1:2]
importaciones <- read.csv("./DATA/RAW/Importaciones.csv")[10:559,1:2]
precio.petroleo <- read.csv("./DATA/RAW/PrecioPetroleo.csv")[9:438,1:2]

### Data Transformation
names.var <- c("date", "var")
names(tipo.cambio) <- names.var
names(google.search) <- names.var
names(desocupacion) <- names.var
names(exportaciones) <- names.var
names(exportacion.petrolera) <- names.var
names(importaciones) <- names.var
names(precio.petroleo) <- names.var

# Google Search
google.search <- separate(google.search, date, into = c("init","fin"), sep = " - ")
google.search$init <- as.Date(google.search$init, "%Y-%m-%d")
google.search$month.year <- paste(format(google.search$init, "%m"), format(google.search$init, "%Y"), sep = "-")
google.search$var <- as.numeric(paste(google.search$var))
google.search <- aggregate(google.search$var, list(google.search$month.year), mean)
names(google.search) <- names.var
google.search$date <- paste("01", google.search$date, sep = "-")
google.search$date <- as.Date(google.search$date, "%d-%m-%Y")

# Tipo de Cambio
tipo.cambio$var <- as.numeric(paste(tipo.cambio$var))
tipo.cambio$var[354] <- 14.17
tipo.cambio$date <- paste(tipo.cambio$date, "01", sep = "/")
tipo.cambio$date <- as.Date(tipo.cambio$date, "%Y/%m/%d")

# Desocupacion
desocupacion$var <- as.numeric(paste(desocupacion$var))
desocupacion$date <- paste(desocupacion$date, "01", sep = "/")
desocupacion$date <- as.Date(desocupacion$date, "%Y/%m/%d")

# Exportaciones
exportaciones$var <- as.numeric(paste(exportaciones$var))
exportaciones$date <- paste(exportaciones$date, "01", sep = "/")
exportaciones$date <- as.Date(exportaciones$date, "%Y/%m/%d")

# Exportacion Petrolera
exportacion.petrolera$var <- as.numeric(paste(exportacion.petrolera$var))
exportacion.petrolera$date <- paste(exportacion.petrolera$date, "01", sep = "/")
exportacion.petrolera$date <- as.Date(exportacion.petrolera$date, "%Y/%m/%d")

# Importaciones
importaciones$var <- as.numeric(paste(importaciones$var))
importaciones$date <- paste(importaciones$date, "01", sep = "/")
importaciones$date <- as.Date(importaciones$date, "%Y/%m/%d")

# Precio del Petroleo
precio.petroleo$var <- as.numeric(paste(precio.petroleo$var))
precio.petroleo$date <- paste(precio.petroleo$date, "01", sep = "/")
precio.petroleo$date <- as.Date(precio.petroleo$date, "%Y/%m/%d")

### Final Data
final.data <- merge(tipo.cambio, google.search, by = "date")
final.data <- merge(final.data, desocupacion, by = "date")
final.data <- merge(final.data, exportacion.petrolera, by = "date")
final.data <- merge(final.data, exportaciones, by = "date")
final.data <- merge(final.data, importaciones, by = "date")
final.data <- merge(final.data, precio.petroleo, by = "date")
names(final.data) <- c("date", "tipo.cambio", "search", "desocupacion", "exp.petrolera", "exportaciones",
                       "importaciones", "precio.petroleo")

##########################################EXPORT#########################################
write.csv(x = final.data, file = "./DATA/PROCESSED/Dolar.csv")
