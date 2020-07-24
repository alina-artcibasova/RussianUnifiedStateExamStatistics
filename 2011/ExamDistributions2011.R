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

##### READING DATA #####
#reading data MATH
#theurl <- "https://4ege.ru/novosti-ege/1400-minimalnyy-porog-po-matematike-2011-24-balla.html"
#source_tables <- read_html(theurl)
thefilepath <- file.path("data", "1400-minimalnyy-porog-po-matematike-2011-24-balla.html")
source_tables <- read_html(thefilepath)
math_table <- html_nodes(source_tables, "table")
math_table <- html_table(math_table[[1]], fill = TRUE)
math_table <- math_table[-c(1:4, dim(math_table)[1]),]
math_table$subject <- 'Math'
colnames(math_table) <- c('primary', 'secondary', 'people', 'percent', 'integral', 'subject')

#reading data RUSSIAN
#theurl <- "https://4ege.ru/novosti-ege/1377-minimalnyy-porog-po-russkomu-yazyku.html"
#source_tables <- read_html(theurl)
thefilepath <- file.path("data", "1377-minimalnyy-porog-po-russkomu-yazyku.html")
source_tables <- read_html(thefilepath)
rus_table <- html_nodes(source_tables, "table")
rus_table <- html_table(rus_table[[1]], fill = TRUE)
rus_table <- rus_table[-c(1:2, dim(rus_table)[1]),]
rus_table$subject <- 'Russian'
colnames(rus_table) <- c('primary', 'secondary', 'people', 'percent', 'integral', 'subject')

#reading ocr data

#creating data frame
data <- data.frame(primary=c(),
                   secondary=c(),
                   people=c(),
                   percent=c(),
                   integralPercent=c(),
                   subject=c())

fileList <- list.files(file.path('data', 'ocr'))

for(i in 1:length(fileList)){
  data_temp <- read_excel(file.path('data', 'ocr', fileList[i]), sheet = 1, skip=2)
  data_temp <- data_temp[-dim(data_temp)[1],]
  data_temp$subject <- fileList[i]
  colnames(data_temp) <- c('primary', 'secondary', 'people', 'percent', 'integral', 'subject')
  data <- rbind(data, data_temp)
}

data[grep('geograf', data$subject),]$subject <- 'Geography'
data[grep('himiya', data$subject),]$subject <- 'Chemistry'
data[grep('istoriya', data$subject),]$subject <- 'History'
data[grep('bio', data$subject),]$subject <- 'Biology'
data[grep('liter', data$subject),]$subject <- 'Literature'
data[grep('angl', data$subject),]$subject <- 'English'
data[grep('ispanskiy', data$subject),]$subject <- 'Spanish'
data[grep('fiz', data$subject),]$subject <- 'Physics'
data[grep('franc', data$subject),]$subject <- 'French'
data[grep('nemeckiy', data$subject),]$subject <- 'German'
data[grep('obshestvoz', data$subject),]$subject <- 'Sociology'
data[grep('inf', data$subject),]$subject <- 'CompSci'

data <- rbind(data, math_table, rus_table)

rm(math_table, rus_table, data_temp, source_tables, fileList, thefilepath)

data$primary <- as.numeric(as.character(data$primary))
data$secondary <- as.numeric(as.character(data$secondary))
data$people <- as.numeric(gsub(' ', '', as.character(data$people)))
data$percent <- as.numeric(as.character(data$percent))

#creating a vector of subjects
subjects <- c('Russian', 'Math',
              'Physics','Literature',
              'CompSci',
              'English', 'German',
              'French', 'Spanish',
              'Geography', 'Chemistry',
              'Biology', 'History', 'Sociology')

#creating a vector of passing grades
passingGrade <- c(36, 24,
                  33, 32,
                  40,
                  20, 20,
                  20, 20,
                  35, 32,
                  36, 30, 39)

#checking if the grade is passing or not
data$passing <- TRUE

for (i in 1:length(subjects)){
  data[data$subject == subjects[i],]$passing <- data[data$subject == subjects[i],]$secondary >= passingGrade[i] 
}

data$passing2 <- ''
data[data$passing == TRUE,]$passing2 <- 'passed'
data[data$passing == FALSE,]$passing2 <- 'failed'

#checking if the percent is computed correctly
for (i in 1:length(subjects)){
  peopleSum <- sum(data[data$subject == subjects[i],]$people)
  data[data$subject == subjects[i],]$percent <- data[data$subject == subjects[i],]$people/peopleSum
}


data$passing2 <- as.factor(data$passing2)
data$subject <- as.factor(data$subject)







##### plotting primary to secondary #####

plotdots<- ggplot(data, aes(x=primary, y=secondary, col=passing2)) +
  geom_point() +
  scale_y_continuous(breaks=c(20,40,60,80,100)) +
  ggtitle("Primary to secondary grade conversion for Russian State Exam 2011")+
  xlab("Primary Grade")+
  ylab("Secondary Grade (0-100)")+
  facet_wrap( ~ subject, ncol=4) +
  scale_color_brewer(palette = "Set1")

png(file='PrimaryToSecondary2011.png', width=800, height=600)
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
  ggtitle(paste0("Distribution of grades for Russian State Exam 2011 (", dateText, ")")) +
  scale_color_brewer(palette = "Set1")

#outputting data into file
png(file='ExamDistribution2011.png', width=800, height=600)
plots +
  theme_half_open() +
  background_grid() +
  theme(legend.title=element_blank())
dev.off()





##### plotting number of participants for each subject #####
#making a summary
participantSummary <- ddply(data, .(subject, passing2), 
                            summarize, 
                            numbers = sum(people))
#second summary for total numbers of people
participantSummary2 <- ddply(data, .(subject), 
                             summarize, 
                             numbers = sum(people))

#separating summary into passing and failing
participantSummaryPassed <- participantSummary[participantSummary$passing2 == 'passed',]
participantSummaryFailed <- participantSummary[participantSummary$passing2 == 'failed',]

#ordering both by the total number of people who took the exam
participantSummaryPassed$subject <- factor(participantSummaryPassed$subject,
                                           levels = participantSummaryPassed$subject[order(-participantSummary2$numbers)])
participantSummaryFailed$subject <- factor(participantSummaryFailed$subject,
                                           levels = participantSummaryFailed$subject[order(-participantSummary2$numbers)])
#combining them back together
participantSummary <- rbind(participantSummaryPassed, participantSummaryFailed)

rm(participantSummary2, participantSummaryPassed, participantSummaryFailed)

#plotting summary
plotSummary <- ggplot(participantSummary, aes(x=subject, y=numbers, fill=passing2))+
  geom_col()+
  ggtitle(paste0("Numbers of participants for different subjects in Russian State Exam 2011 (", dateText, ")"))+
  ylab("Number of people")+ 
  theme(axis.title.x = element_blank(),
        legend.title=element_blank()) +
  scale_fill_brewer(palette = "Set1")

#outputting data into files

png(file='ExamSubjectSummary2011.png', width=800, height=600)
plotSummary +
  theme_half_open() +
  background_grid() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        axis.title.x = element_blank(),
        legend.title=element_blank())
dev.off()