#install.packages("rstudioapi")
library("rstudioapi")
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#install.packages("ggplot2")
library("ggplot2")
#install.packages("cowplot")
library("cowplot")
#install.packages("ggrepel")
library("ggrepel")

## reading data
dataFolder <- 'data'
data <- read.csv2 (file.path(dataFolder, 'CompSciGrades.csv'), header = TRUE, sep=',')
data$subject <- 'CompSci'
colnames(data) <- c('primary', 'secondary', 'subject')


data2 <- read.csv2 (file.path(dataFolder, 'RussianGrades.csv'), header = TRUE, sep=',')
data2$subject <- 'Russian'
colnames(data2) <- c('primary', 'secondary', 'subject')

data3 <- read.csv2 (file.path(dataFolder, 'MathGrades.csv'), header = TRUE, sep=',')
data3$subject <- 'Math'
colnames(data3) <- c('primary', 'secondary', 'subject')

data4 <- read.csv2 (file.path(dataFolder, 'PhysicsGrades.csv'), header = TRUE, sep=',')
data4$subject <- 'Physics'
colnames(data4) <- c('primary', 'secondary', 'subject')

data <- rbind(data, data2, data3, data4) 

data$tributesCS <- ''
data[data$secondary == 81 & data$subject == 'CompSci',]$tributesCS <- 'Anton'
data[data$secondary == 77 & data$subject == 'CompSci',]$tributesCS <- 'Angelica'
data[data$secondary == 51 & data$subject == 'CompSci',]$tributesCS <- 'Michail'
data[data$secondary == 64 & data$subject == 'CompSci',]$tributesCS <- 'Artemiy'
data[data$secondary == 84 & data$subject == 'CompSci',]$tributesCS <- 'Ksenia'
data[data$secondary == 75 & data$subject == 'CompSci',]$tributesCS <- 'Dmitriy'

data$tributesRus <- ''
data[data$secondary == 91 & data$subject == 'Russian',]$tributesRus <- 'Anton'
data[data$secondary == 94 & data$subject == 'Russian',]$tributesRus <- 'Angelica'
data[data$secondary == 98 & data$subject == 'Russian',]$tributesRus <- 'Ksenia'
data[data$secondary == 67 & data$subject == 'Russian',]$tributesRus <- 'Artemiy'
data[data$secondary == 65 & data$subject == 'Russian',]$tributesRus <- 'Michail'
data[data$secondary == 82 & data$subject == 'Russian',]$tributesRus <- 'Dmitriy'

data$tributesMath <- ''
data[data$secondary == 90 & data$subject == 'Math',]$tributesMath <- 'Anton'
data[data$secondary == 62 & data$subject == 'Math',]$tributesMath <- 'Angelica'
data[data$secondary == 76 & data$subject == 'Math',]$tributesMath <- 'Ksenia'
data[data$secondary == 50 & data$subject == 'Math',]$tributesMath <- 'Artemiy, Michail'
data[data$secondary == 72 & data$subject == 'Math',]$tributesMath <- 'Dmitriy'

data$tributesPhysics <- ''
data[data$secondary == 91 & data$subject == 'Physics',]$tributesPhysics <- 'Anton'
data[data$secondary == 68 & data$subject == 'Physics',]$tributesPhysics <- 'Angelica'
#data[data$secondary == 91 & data$subject == 'Physics',]$tributesPhysics <- 'Ksenia'
#data[data$secondary == 68 & data$subject == 'Physics',]$tributesPhysics <- 'Artemiy'
#data[data$secondary == 91 & data$subject == 'Physics',]$tributesPhysics <- 'Michail'
#data[data$secondary == 68 & data$subject == 'Physics',]$tributesPhysics <- 'Dmitriy'


## plotting stuff
plotlabels<- ggplot(data, aes(x=primary, y=secondary)) +
  geom_point(aes(col=subject))+
  scale_y_continuous(breaks=c(20,40,60,80,100))+
  ggtitle("Primary to secondary grade conversion for Russian State Exam 2020") +
  geom_label_repel(aes(label=tributesCS,
                       fill = subject),
                       color = 'black',
                       size = 3.5,
                       label.padding = 0.5,
                       alpha = .4,
                       force = 14)+
  geom_label_repel(aes(label=tributesRus,
                       fill = subject),
                       color = 'black',
                       size = 3.5,
                       label.padding = 0.5,
                       alpha = .4,
                       force = 17)+
  geom_label_repel(aes(label=tributesMath,
                       fill = subject),
                       color = 'black',
                       size = 3.5,
                       label.padding = 0.5,
                       alpha = .4,
                       force = 23)+
  geom_label_repel(aes(label=tributesPhysics,
                       fill = subject),
                   color = 'black',
                   size = 3.5,
                   label.padding = 0.5,
                   alpha = .4,
                   force = 23)

plotdots<- ggplot(data, aes(x=primary, y=secondary)) +
  geom_point(aes(col=subject))+
  scale_y_continuous(breaks=c(20,40,60,80,100))+
  ggtitle("Primary to secondary grade conversion for Russian State Exam 2020")

png(file='ExamResults2020.png', width=800, height=600)
print(plotdots +
        theme_half_open() +
        background_grid() +
        theme())
dev.off()

png(file='ExamResults2020labeled.png', width=1000, height=800)
print(plotlabels +
        theme_half_open() +
        background_grid() +
        theme())
dev.off()


#compsci
nameBro <- 'Anton'
sum(data[data$tributesCS == nameBro | data$tributesRus == nameBro | data$tributesMath == nameBro,]$secondary)
nameSis <- 'Angelica'
sum(data[data$tributesCS == nameSis | data$tributesRus == nameSis | data$tributesMath == nameSis,]$secondary)

#compsci
nameBro <- 'Anton'
sum(data[data$tributesPhysics == nameBro | data$tributesRus == nameBro | data$tributesMath == nameBro,]$secondary)
nameSis <- 'Angelica'
sum(data[data$tributesPhysics == nameSis | data$tributesRus == nameSis | data$tributesMath == nameSis,]$secondary)