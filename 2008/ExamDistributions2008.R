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
              'French', 'Sociology', 'Literature')

# reading from file
for(i in 1:13){
  data_temp <- read_excel(file.path('data', 'tabl_sootv.xls'), sheet = i, skip=4)
  data_temp$subject <- subjects[i]
  data_temp <- data_temp[-dim(data_temp)[1],]
  data <- rbind(data, data_temp)
}

#making sure colnames are in check after merging data
colnames(data) <- c('primary', 'secondary', 'people', 'percent', 'integral', 'subject')
rm(data_temp)

#creating categories
data$category <- ""
data[data$subject == "Russian" |
       data$subject == "Math",]$category <- 'Obligatory'

data[data$subject == "English" |
       data$subject == "German" |
       data$subject == "French",]$category <- 'Foreign Languages'

data[data$subject == "Physics" |
       data$subject == "Chemistry" |
       data$subject == "Biology" |
       data$subject == "CompSci"|
       data$subject == "Geography",]$category <- 'Natural Sciences'

data[data$subject == "History" |
       data$subject == "Sociology" |
       data$subject == "Literature",]$category <- 'Social Sciences'





##### plotting primary to secondary #####

plotdots<- ggplot(data, aes(x=primary, y=secondary)) +
  geom_point() +
  scale_y_continuous(breaks=c(20,40,60,80,100)) +
  ggtitle("Primary to secondary grade conversion for Russian State Exam 2008")+
  xlab("Primary Grade")+
  ylab("Secondary Grade (0-100)")+
  facet_wrap( ~ subject, ncol=4)

png(file='ExamResults2008.png', width=800, height=600)
print(plotdots +
        theme_half_open() +
        background_grid() +
        theme())
dev.off()





##### plotting participants distribution #####
plots <- ggplot(data, aes(x=secondary, y=percent))+
  geom_point()+
  geom_line()+
  facet_wrap( ~ subject, ncol=4) +
  xlab("Secondary Grade (0-100)")+
  ylab("Participants (%)")+ 
  ggtitle("Distribution of grades for Russian State Exam 2008 (16.06.08)")

#outputting data into files
png(file='ExamDistribution2008.png', width=800, height=600)
plots +
  theme_half_open() +
  background_grid() +
  theme()
dev.off()





##### plotting number of participants for each subject #####
participantSummary <- ddply(data, .(subject), 
                            summarize, 
                            numbers = sum(people))

participantSummary$subject <- factor(participantSummary$subject,
                                     levels = participantSummary$subject[order(-participantSummary$numbers)])

#plotting summary
plotSummary <- ggplot(participantSummary, aes(x=subject, y=numbers))+
  geom_col()+
  ggtitle("Numbers of participants for different subjects in Russian State Exam 2008 (16.06.08)")+
  ylab("Number of people")+ 
  theme(axis.title.x = element_blank())

#outputting data into files
png(file='ExamSubjectSummary2008.png', width=800, height=600)
plotSummary +
    theme_half_open() +
    background_grid() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
          axis.title.x = element_blank())
dev.off()