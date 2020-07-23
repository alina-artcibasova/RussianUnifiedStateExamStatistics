#install.packages("rstudioapi")
library("rstudioapi")
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#install.packages("ggplot2")
library("ggplot2")
#install.packages("cowplot")
library("cowplot")
#install.packages("ggrepel")
library("ggrepel")
#install.packages("readxl")
library("readxl")
#install.packages("plyr")
library("plyr")

library(RColorBrewer)
#ownPalette = brewer.pal(2, 'Set1')



##### reading data #####

#creating data frame
data <- data.frame(primary=c(),
                   secondary=c(),
                   people=c(),
                   percent=c(),
                   integralPercent=c(),
                   subject=c())

#creating a vector of subjects
subjects <- c('Russian', 'Math',
              'Physics', 'Chemistry',
              'CompSci', 'Biology',
              'History', 'Geography',
              'English', 'German',
              'French', 'Spanish',
              'Sociology', 'Literature')

passingGrade <- c(37, 21,
                  31, 33,
                  36, 35,
                  30, 34,
                  20, 20,
                  20, 20,
                  39, 30)

# reading from file
for(i in 1:length(subjects)){
  data_temp <- read_excel(file.path('data', 'tablica_perevodov_23.06.09.xls'), sheet = i, skip=4)
  data_temp$subject <- subjects[i]
  data_temp <- data_temp[-dim(data_temp)[1],]
  data <- rbind(data, data_temp)
}

#making sure colnames are in check after merging data
colnames(data) <- c('primary', 'secondary', 'people', 'percent', 'integral', 'subject')
rm(data_temp)

#creating categories
data$passing <- TRUE

for (i in 1:length(subjects)){
  data[data$subject == subjects[i],]$passing <- data[data$subject == subjects[i],]$secondary >= passingGrade[i] 
}

data$passing2 <- ''
data[data$passing == TRUE,]$passing2 <- 'passed'
data[data$passing == FALSE,]$passing2 <- 'failed'


##### plotting primary to secondary #####

plotdots<- ggplot(data, aes(x=primary, y=secondary, col=passing2)) +
  geom_point() +
  scale_y_continuous(breaks=c(20,40,60,80,100)) +
  ggtitle("Primary to secondary grade conversion for Russian State Exam 2009")+
  xlab("Primary Grade")+
  ylab("Secondary Grade (0-100)")+
  facet_wrap( ~ subject, ncol=4) +
  scale_color_brewer(palette = "Set1")

png(file='ExamResults2009.png', width=800, height=600)
print(plotdots +
        theme_half_open() +
        background_grid() +
        theme(legend.title=element_blank()))
dev.off()





##### plotting participants distribution #####
plots <- ggplot(data, aes(x=secondary, y=percent, col=passing2))+
  geom_point()+
  geom_line()+
  facet_wrap( ~ subject, ncol=4) +
  xlab("Secondary Grade (0-100)")+
  ylab("Participants (%)")+ 
  ggtitle("Distribution of grades for Russian State Exam 2009 (23.06.09)") +
  scale_color_brewer(palette = "Set1")

#outputting data into file
png(file='ExamDistribution2009.png', width=800, height=600)
plots +
  theme_half_open() +
  background_grid() +
  theme(legend.title=element_blank())
dev.off()





##### plotting number of participants for each subject #####
participantSummary <- ddply(data, .(subject, passing2), 
                            summarize, 
                            numbers = sum(people))

participantSummary$subject <- factor(participantSummary$subject,
                                     levels = participantSummary$subject[order(-participantSummary$numbers)])

#plotting summary
plotSummary <- ggplot(participantSummary, aes(x=subject, y=numbers, fill=passing2))+
  geom_col()+
  ggtitle("Numbers of participants for different subjects in Russian State Exam 2009 (23.06.09)")+
  ylab("Number of people")+ 
  theme(axis.title.x = element_blank(),
        legend.title=element_blank()) +
  scale_fill_brewer(palette = "Set1")

#outputting data into files
  
png(file='ExamSubjectSummary2009.png', width=800, height=600)
plotSummary +
    theme_half_open() +
    background_grid() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
          axis.title.x = element_blank(),
          legend.title=element_blank())
dev.off()