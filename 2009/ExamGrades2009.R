#install.packages("rstudioapi")
library("rstudioapi")
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#install.packages("ggplot2")
library("ggplot2")
#install.packages("cowplot")
library("cowplot")
#install.packages("ggrepel")
library("ggrepel")




##### reading data #####
dataFolder <- 'data'
data_cs <- read.csv2 (file.path(dataFolder, 'compsci2009.csv'), header = TRUE, sep=',')
data_cs$subject <- "CompSci"
data_math <- read.csv2 (file.path(dataFolder, 'math2009.csv'), header = TRUE, sep=',')
data_math$subject <- "Math"
data_rus <- read.csv2 (file.path(dataFolder, 'russian2009.csv'), header = TRUE, sep=',')
data_rus$subject <- "Russian"
data_physics <- read.csv2 (file.path(dataFolder, 'physics2009.csv'), header = TRUE, sep=',')
data_physics$subject <- "Physics"

data <- rbind(data_cs, data_math, data_rus, data_physics)
rm(data_cs, data_math, data_rus, data_physics)

data$tributesCS <- ''
data$tributesRus <- ''
data$tributesMath <- ''
data$tributesPhysics <- ''

data[data$secondary == 80 & data$subject == 'CompSci',]$tributesCS <- 'Alina'
data[data$secondary == 89 & data$subject == 'Russian',]$tributesRus <- 'Alina'
data[data$secondary == 80 & data$subject == 'Math',]$tributesMath <- 'Alina'
data[data$secondary == 69 & data$subject == 'Physics',]$tributesPhysics <- 'Alina'




##### plotting primary to secondary with labels #####
plotlabels<- ggplot(data, aes(x=primary, y=secondary)) +
  geom_point(aes(col=subject))+
  scale_y_continuous(breaks=c(20,40,60,80,100))+
  ggtitle("Primary to secondary grade conversion for Russian State Exam 2009") +
  xlab("Primary Grade")+
  ylab("Secondary Grade (0-100)")+
  geom_label_repel(aes(label=tributesCS,
                       fill = subject),
                       color = 'black',
                       size = 3.5,
                       label.padding = 0.5,
                       alpha = .4,
                       force = 18)+
  geom_label_repel(aes(label=tributesRus,
                       fill = subject),
                       color = 'black',
                       size = 3.5,
                       label.padding = 0.5,
                       alpha = .4,
                       force = 18)+
  geom_label_repel(aes(label=tributesMath,
                       fill = subject),
                       color = 'black',
                       size = 3.5,
                       label.padding = 0.5,
                       alpha = .4,
                       force = 18)+
  geom_label_repel(aes(label=tributesPhysics,
                       fill = subject),
                       color = 'black',
                       size = 3.5,
                       label.padding = 0.5,
                       alpha = .4,
                       force = 18)

#outputting into file
png(file='ExamResults2009labeled.png', width=800, height=600)
print(plotlabels +
        theme_half_open() +
        background_grid() +
        theme())
dev.off()

#physics total
nameSelf <- 'Alina'
sum(data[data$tributesCS == nameSelf | data$tributesRus == nameSelf | data$tributesMath == nameSelf,]$secondary)