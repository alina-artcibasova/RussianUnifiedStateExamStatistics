library("rstudioapi")
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library("ggplot2")
library("cowplot")
library("ggrepel")
library("readxl")
library("plyr")
library("RColorBrewer")

library(rvest)

dateText <- "15.06.11"

#reading data MATH
#theurl <- "https://4ege.ru/novosti-ege/1400-minimalnyy-porog-po-matematike-2011-24-balla.html"
#source_tables <- read_html(theurl)
thefilepath <- file.path("data", "1400-minimalnyy-porog-po-matematike-2011-24-balla.html")
source_tables <- read_html(thefilepath)
math_table <- html_nodes(source_tables, "table")
math_table <- html_table(math_table[[1]], fill = TRUE)
math_table <- math_table[-c(1:4, dim(math_table)[1]),]
math_table$subject <- 'Math'

#reading data RUSSIAN
#theurl <- "https://4ege.ru/novosti-ege/1377-minimalnyy-porog-po-russkomu-yazyku.html"
#source_tables <- read_html(theurl)
thefilepath <- file.path("data", "1377-minimalnyy-porog-po-russkomu-yazyku.html")
source_tables <- read_html(thefilepath)
rus_table <- html_nodes(source_tables, "table")
rus_table <- html_table(rus_table[[1]], fill = TRUE)
rus_table <- rus_table[-c(1:2, dim(rus_table)[1]),]
rus_table$subject <- 'Russian'

data <- rbind(math_table, rus_table)
colnames(data) <- c('primary', 'secondary', 'people', 'percent', 'integral', 'subject')

#creating a vector of subjects
subjects <- c('Math', 'Russian')

#creating a vector of passing grades
passingGrade <- c(24, 36)