########################### IST 687 FINAL PROJECT ##############################
## GROUP 3: 
# Michelle Kincaid
# Divya Damahe
# Rayanna Harduarsingh
# Zeyang Zhou 

########################### UPLOADING THE DATA #################################
# Run these three functions to get a clean test of code
dev.off() # Clear the graph window
cat('\014')  # Clear the console
rm(list=ls()) # Clear user objects from the environment

# Set working directory 
# setwd("~/Desktop/IST 687/Final Project")

# Reading in the data file: 

#install.packages("jsonlite")
#The following URL is the location of the survey datafile
# https://drive.google.com/file/d/1G7f3LiSW-NmqsiBENwYd-nEfh4_9eV7D/view?usp=sharing

library(jsonlite)
library(ggplot2)

mydata.list <- jsonlite::fromJSON("completeSurvey.json")
airData <- data.frame(mydata.list)
cols <- c("Destination.City","Origin.City","Airline.Status","Age","Gender",
          "Price.Sensitivity","Year.of.First.Flight","Flights.Per.Year",
          "Loyalty","Type.of.Travel","Total.Freq.Flyer.Accts",
          "Shopping.Amount.at.Airport","Eating.and.Drinking.at.Airport",
          "Class","Day.of.Month","Flight.date","Partner.Code","Partner.Name",
          "Origin.State","Scheduled.Departure.Hour","Departure.Delay.in.Minutes",
          "Arrival.Delay.in.Minutes","Flight.cancelled","Flight.time.in.minutes",
          "Flight.Distance","Likelihood.to.recommend","olong","olat","dlong",
          "dlat","freeText")
str(airData)

############################### DATA CLEANING ################################## 

# Identifying NAs 
airData$Destination.City[is.na(airData$Destination.City)]
airData$Origin.City[is.na(airData$Origin.City)]
airData$Airline.Status[is.na(airData$Airline.Status)]
airData$Age[is.na(airData$Age)]
airData$Gender[is.na(airData$Gender)]
airData$Price.Sensitivity [is.na(airData$Price.Sensitivity)]
airData$Year.of.First.Flight[is.na(airData$Year.of.First.Flight)]
airData$Flights.Per.Year[is.na(airData$Flights.Per.Year)]
airData$Loyalty[is.na(airData$Loyalty)]
airData$Type.of.Travel[is.na(airData$Type.of.Travel)]
airData$Total.Freq.Flyer.Accts[is.na(airData$Total.Freq.Flyer.Accts)]
airData$Shopping.Amount.at.Airport[is.na(airData$Shopping.Amount.at.Airport)]
airData$Eating.and.Drinking.at.Airport[is.na(airData$Eating.and.Drinking.at.Airport)]
airData$Class[is.na(airData$Class)]
airData$Day.of.Month[is.na(airData$Day.of.Month)]
airData$Flight.date[is.na(airData$Flight.date)]
airData$Partner.Code[is.na(airData$Partner.Code)]
airData$Partner.Name[is.na(airData$Partner.Name)]
airData$Origin.State[is.na(airData$Origin.State)]
airData$Destination.State[is.na(airData$Destination.State)]
airData$Scheduled.Departure.Hour[is.na(airData$Scheduled.Departure.Hour)]
airData$Departure.Delay.in.Minutes[is.na(airData$Departure.Delay.in.Minutes)]
airData$Arrival.Delay.in.Minutes[is.na(airData$Arrival.Delay.in.Minutes)] 
airData$Flight.Distance[is.na(airData$Flight.Distance)]
airData$Flight.cancelled[is.na(airData$Flight.cancelled)]  
airData$Flight.time.in.minutes[is.na(airData$Flight.time.in.minutes)]
airData$freeText[is.na(airData$freeText)]
airData$Likelihood.to.recommend[is.na(airData$Likelihood.to.recommend)]

# Omitting NAs from Likelihood.to.recommend
x <- is.na(airData$Likelihood.to.recommend)
airData <- airData[x == FALSE,]
str(airData)
table(is.na(airData$Likelihood.to.recommend))
airData$Likelihood.to.recommend[is.na(airData$Likelihood.to.recommend)]
hist(airData$Likelihood.to.recommend)

# Lower case Origin.State, Origin.City, Destination.State, Destination.City 
airData$Destination.City <- tolower(airData$Destination.City)
airData$Destination.State <- tolower(airData$Destination.State)
airData$Origin.City  <- tolower(airData$Origin.City)
airData$Origin.State <- tolower(airData$Origin.State)

# Changing variables to factors 
airData$Airline.Status <- as.factor(airData$Airline.Status)
airData$Gender <- as.factor(airData$Gender)
airData$Type.of.Travel <- as.factor(airData$Type.of.Travel)
airData$Class <- as.factor(airData$Class)
airData$Flight.cancelled <- as.factor(airData$Flight.cancelled)

str(airData)

########################### DATA TRANSFORMATIONS ############################### 
# Arrival and Departure Delays Greater than 5 Minutes
# DEPARTURE
# 1. Changing NA to 0
airData$Departure.Delay.in.Minutes[is.na(airData$Departure.Delay.in.Minutes)]=0
# 2. Creating Departure Delay Greater than 5 Minutes 
airData$Departure.Delay.Above5 <- airData$Departure.Delay.in.Minutes>5

# ARRIVAL
# 1. Changing NA to 0
airData$Arrival.Delay.in.Minutes[is.na(airData$Arrival.Delay.in.Minutes)]=0
# 2. Creating Arrival Delay Greater than 5 Minutes
airData$Arrival.Delay.Above5 <- airData$Arrival.Delay.in.Minutes>5

# Transforming Flight.date from day/month/year format to create month variable.
flightdates <- data.frame(airData$Flight.date)
library(tidyr)
flightdates <- separate(data=flightdates, col=airData.Flight.date, into = 
      c("Flight.month","Flight.day2","Flight.year2"), sep="/")
flightdates = subset(flightdates,select=-c(Flight.day2,Flight.year2)) # Removing Flight Day and Year because duplicated in original dataframe

# Binding flightdates to airData
airData <- cbind(airData,flightdates)
airData$Flight.month <- as.numeric(airData$Flight.month)
summary(airData$Flight.month)
hist(airData$Flight.month)

# NET PROMOTOR SCORE
m<- table(airData$Likelihood.to.recommend)
str(m)
detractors<- sum(m[1:6])
passives<- sum(m[7:8])
promoters<- sum(m[9:10])
total<- as.numeric(88100)
d<- detractors/total *100
pro<- promoters/total *100
NPS<- pro-d
total<- detractors +passives +promoters
# NPS: 8.89

########################## EXPLORATORY ANALYSIS ################################
############## CLIENT DATA  #################################################### 
library(ggplot2)
library(ggmap) 

# Making copy of airData as survey to match team code: 
survey <- airData

####### STATUS #######
#prop.table(table(survey$Airline.Status))
status_hist <- ggplot(survey, aes(x= Airline.Status )) + 
  geom_histogram(stat="count",fill= 'violetred4')
status_hist<- status_hist + ggtitle("Number of Travellers wrt status") +xlab("Status")+ylab("Number of Travellers")
status_hist

agg_Airline.Status	=	aggregate(survey$Likelihood.to.recommend,
                               by	=	list(survey$Airline.Status),
                               FUN	=	mean)	
status_Like_bar <- ggplot(agg_Airline.Status, aes(x= reorder(Group.1,x),y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
status_Like_bar<- status_Like_bar + ggtitle("Likelihood to recommend wrt Status") +xlab("Status")+ylab("Likelihood to recommend")
status_Like_bar

####### GENDER #######
gender_hist <- ggplot(survey, aes(x=Gender)) + 
  geom_histogram(stat="count",aes(fill= Gender))
gender_hist<- gender_hist + ggtitle("Number of Travellers wrt Gender") +xlab("Gender")+ylab("Number of Travellers")
gender_hist
agg_Gender	=	aggregate(survey$Likelihood.to.recommend,
                       by	=	list(survey$Gender),
                       FUN	=	mean)
g_gen_bar<- ggplot(agg_Gender, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
g_gen_bar<- g_gen_bar + ggtitle("Likelihood to recommend wrt gender") +xlab("Gender")+ ylab("Likelihood to recommend")
g_gen_bar

####### PRICE SENSITIVITY #######
ps_hist <- ggplot(survey, aes(x=Price.Sensitivity)) + 
  geom_histogram(stat="count",fill= 'violetred4')+stat_bin(binwidth=1, geom="text", aes(label=..count..), vjust=-0.5) 
ps_hist<- ps_hist + ggtitle("Number of Travellers wrt Price sensitivity") +xlab("Price Sensitivity")+ylab("Number of Travellers")
ps_hist

agg_Price.Sensitivity=	aggregate(survey$Likelihood.to.recommend,
                                 by	=	list(survey$Price.Sensitivity),
                                 FUN	=	mean)

g_ps_bar<- ggplot(agg_Price.Sensitivity, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
g_ps_bar<- g_ps_bar + ggtitle("Likelihood to recommend wrt Price sensitivity") +xlab("Price sensitivity")+ylab("Likelihood to recommend")
g_ps_bar

####### YEAR OF FIRST FLIGHT #######
year_hist <- ggplot(survey, aes(x=Year.of.First.Flight)) + 
  geom_histogram(stat="count",fill= 'darkorange3')+stat_bin(binwidth=1, geom="text", aes(label=..count..), vjust=-0.5) 
year_hist<- year_hist + ggtitle("Number of Travellers wrt First flight") +xlab("First Flight ")+ylab("Number of Travellers")
year_hist
agg_Year.of.First.Flight=	aggregate(survey$Likelihood.to.recommend,
                                    by	=	list(survey$Year.of.First.Flight),
                                    FUN	=	mean)
#agg_Year.of.First.Flight$Group.1<- 2020- agg_Year.of.First.Flight 
year_bar<- ggplot(agg_Year.of.First.Flight, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
year_bar<- year_bar + ggtitle("Likelihood to recommend wrt Year of 1st Flight") +xlab("Year of 1st flight")+ylab("Likelihood to recommend")
year_bar
#year of the 1st flight does not play a major role in the likelihood to recommend value

####### TYPE OF TRAVEL #######
type_travel_hist <- ggplot(survey, aes(x=Type.of.Travel)) + 
  geom_histogram(stat="count",fill= 'darkorange3')+ ggtitle("Number of travellers in each type of travel")
type_travel_hist
agg_Type.of.Travel=	aggregate(survey$Likelihood.to.recommend,
                              by	=	list(survey$Type.of.Travel),
                              FUN	=	mean)
tt_bar<- ggplot(agg_Type.of.Travel, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
tt_bar<- tt_bar + ggtitle("Likelihood to recommend wrt Type of trave") +xlab("Type of travel")+ylab("Likelihood to recommend")
tt_bar

####### CLASS #######
class_hist <- ggplot(survey, aes(x=Class)) + 
  geom_histogram(stat="count",fill= 'violetred4')+ ggtitle("Number of travellers: Class")
class_hist<- class_hist + ggtitle("Number of Travellers wrt Class") +xlab("Class ")+ylab("Number of Travellers")
class_hist
agg_Class=	aggregate(survey$Likelihood.to.recommend,
                     by	=	list(survey$Class),
                     FUN	=	mean)
class_bar<- ggplot(agg_Class, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
class_bar<- class_bar + ggtitle("Likelihood to recommend wrt Class") +xlab("Class")+ylab("Likelihood to recommend")
class_bar

####### TOTAL FREQUENCY OF FLYER ACCOUNTS #######
table(survey$Total.Freq.Flyer.Accts)
flyr_acc_hist <- ggplot(survey, aes(x=Total.Freq.Flyer.Accts)) + stat_bin(binwidth=1, geom="text", aes(label=..count..), vjust=-0.5) +
  geom_histogram(stat="count",fill= 'darkorange3')+ ggtitle("Number of travellers: Total Flyer accounts")
flyr_acc_hist
agg_Total.Freq.Flyer.Accts=	aggregate(survey$Likelihood.to.recommend,
                                      by	=	list(survey$Total.Freq.Flyer.Accts),
                                      FUN	=	mean)
flyr_acc_bar<- ggplot(agg_Total.Freq.Flyer.Accts, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
flyr_acc_bar<- flyr_acc_bar + ggtitle("Likelihood to recommend wrt Total Flyer accounts") +xlab("Total Flyer accounts")+ylab("Likelihood to recommend")
flyr_acc_bar

#agg need adjustment
#age bins:- 15-19,20-29, 30-39, 40-49,50-59,60-69,70-85 #small groups to find the
#to drill down on details
table(survey$Total.Freq.Flyer.Accts)

####### AGE #######
new_survey<- survey
table(new_survey$Age)
new_survey$Age[which(new_survey$Age<20)]<-"15-19"
new_survey$Age[which(new_survey$Age>19 & new_survey$Age<30)]<-"20-29"
new_survey$Age[which(new_survey$Age>29 & new_survey$Age<40)]<-"30-39"
new_survey$Age[which(new_survey$Age>39 & new_survey$Age<50)]<-"40-49"
new_survey$Age[which(new_survey$Age>49 & new_survey$Age<60)]<-"50-59"
new_survey$Age[which(new_survey$Age>59 & new_survey$Age<70)]<-"60-69"
new_survey$Age[which(new_survey$Age>69)]<-"70-85"

age_hist <- ggplot(new_survey, aes(x=Age)) +
  geom_histogram(stat="count",fill= 'violetred4')+ ggtitle("Number of travellers: Age")
age_hist

agg_Age_r	=	aggregate(new_survey$Likelihood.to.recommend,
                      by	=	list(new_survey$Age),
                      FUN	=	mean)
age_bar<- ggplot(agg_Age_r, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
age_bar<- age_bar + ggtitle("Likelihood to recommend wrt Age") +xlab("Age groups")+ylab("Likelihood to recommend")
age_bar

####### SHOPPING AMOUNT AT AIRPORT #######
# Shopping amount bins- no or yes
new_survey$Shopping_bins[which(new_survey$Shopping.Amount.at.Airport<1)]<-"No Shopping"
new_survey$Shopping_bins[which(new_survey$Shopping.Amount.at.Airport>0)]<-"Shopped at Airport"
shop_hist <- ggplot(new_survey, aes(x=Shopping_bins))  +
  geom_histogram(stat="count",fill= 'violetred4')+ ggtitle("Number of travellers: Shopping/Not shopping")
shop_hist

agg_Shopping.Amount.at.Airport=	aggregate(new_survey$Likelihood.to.recommend,
                                          by	=	list(new_survey$Shopping_bins),
                                          FUN	=	mean)
shop_bar<- ggplot(agg_Shopping.Amount.at.Airport, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
shop_bar<- shop_bar + ggtitle("Likelihood to recommend wrt Shopping") +xlab("Shopping")+ylab("Likelihood to recommend")
shop_bar

####### EATING AND DRINKING AT AIRPORT #######
summary(survey$Eating.and.Drinking.at.Airport)
boxplot(survey$Eating.and.Drinking.at.Airport)
new_survey$eat_bins[which(new_survey$Eating.and.Drinking.at.Airport < 30)]<-"0-30"
new_survey$eat_bins[which(new_survey$Eating.and.Drinking.at.Airport >29 & new_survey$Eating.and.Drinking.at.Airport <67)]<-"30-67"
new_survey$eat_bins[which(new_survey$Eating.and.Drinking.at.Airport >66 & new_survey$Eating.and.Drinking.at.Airport <90)]<-"67-90"
new_survey$eat_bins[which(new_survey$Eating.and.Drinking.at.Airport >89)]<-"91-895"
eat_hist <- ggplot(new_survey, aes(x=eat_bins))  +
  geom_histogram(stat="count",fill= 'violetred4')+ ggtitle("Number of travellers: Amount spent on Eating and Drinking at Airport")
eat_hist
agg_Eat_r=	aggregate(new_survey$Likelihood.to.recommend,
                     by	=	list(new_survey$eat_bins),
                     FUN	=	mean)
eat_bar<- ggplot(agg_Eat_r, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
eat_bar<- eat_bar + ggtitle("Likelihood to recommend wrt Eating/drinking at Airport") +xlab("Spending groups")+ylab("Likelihood to recommend")
eat_bar

###### LOYALTY ######
summary(airData$Loyalty)
hist(airData$Loyalty)
##### LOYALTY - LTR #####
LoyaltyPlot <- ggplot(airData, aes(x=Loyalty, y=Likelihood.to.recommend)) + 
  geom_point(stat="summary") +
  ggtitle("Average Likelihood to Recommend by Loyalty")
LoyaltyPlot

###### LIKELIHOOD TO RECOMMEND ###### 
summary(airData$Likelihood.to.recommend)
hist(airData$Likelihood.to.recommend)

############## FLIGHT DATA  #################################################### 
##### DAY OF MONTH ##### 
summary(airData$Day.of.Month)
hist(airData$Day.of.Month)
# Aggregate LTR by Day of Month
agg_Flight.day <-	aggregate(airData$Likelihood.to.recommend,
                            by	=	list(airData$Day.of.Month),
                            FUN	=	mean)
agg_Flight.day <- agg_Flight.day[order(agg_Flight.day$x),]
agg_day.table <- agg_Flight.day
agg.day.plot<- ggplot(agg_day.table, aes(x=Group.1, y=x, fill=x)) + geom_line(stat="identity") +
  ggtitle("Average Likelihood to Recommend by Flight Day") + 
  geom_text(aes(label = round(x,2), vjust=-0.5)) +
  xlab("Day") +
  ylab("Likelihood to Recommend") +
  ylim(6,8)
agg.day.plot

#####  SCHEDULED DEPARTURE HOUR ##### 
summary(airData$Scheduled.Departure.Hour)
# Scheduled Departure Hour - LTR
agg.departure.plot <- ggplot(agg_Departure.hour, aes(x=Group.1,y=x, fill=x)) + 
  geom_line(stat="identity") + geom_text(aes(label = round(x,2), vjust=-0.5)) + 
  theme(axis.text.x = element_text(angle = 30)) +
  ggtitle("Average Likelihood to Recommend by Scheduled Flight Departure Hour") +
  xlab("Scheduled Departure Hour") +
  ylab("Likelihood to Recommend") +
  ylim(0,8)
agg.departure.plot

##### FLIGHT TIME ##### 
summary(airData$Flight.time.in.minutes)
hist(airData$Flight.time.in.minutes)

#####  MONTH OF FLIGHT ##### 
hist(airData$Flight.month)
# Aggregate LTR by Flight Month
agg_Flight.month <-	aggregate(airData$Likelihood.to.recommend,
                              by	=	list(airData$Flight.month),
                              FUN	=	mean)
agg_Flight.month <- agg_Flight.month[order(agg_Flight.month$x),]
##### MONTH OF FLIGHT - LTR #####
agg_month.table <- agg_Flight.month
agg.month.plot <- ggplot(agg_month.table, aes(x=Group.1, y=x, fill=x)) + geom_bar(stat="identity") +
  ggtitle("Average Likelihood to Recommend by Flight Month") + 
  geom_text(aes(label = round(x,2), vjust=-0.5)) +
  xlab("Month") +
  ylab("Likelihood to Recommend")
agg.month.plot

#####  PARTNER NAME ##### 
partner.name.table <- data.frame(table(airData$Partner.Name))
names(partner.name.table)[names(partner.name.table) == "Var1"] <- "Partner.Name"
Partner.Name.Freq <- ggplot(partner.name.table, aes(x=Partner.Name, y=Freq)) +
  geom_bar(stat="identity") +
  ggtitle("Partner Name Frequencies")
Partner.Name.Freq + coord_flip()
# Aggregating Partner Name by Likelihood to Recommend 
agg_Partner.name	=	aggregate(airData$Likelihood.to.recommend,
                             by	=	list(airData$Partner.Name),
                             FUN	=	mean)
agg_Partner.name <- agg_Partner.name[order(agg_Partner.name$x),]
# Partner.name with highest Likelihood to recommend is West Airways Inc. 
# Partner.namewith lowest Likelihood to recommend is Flyfast Airways Inc.
# Partner Name- LTR
PartnerNamePlot <- ggplot(agg_Partner.name, aes(x=Group.1, y=x, fill=x)) +
  geom_bar(stat="identity") +
  geom_text(aes(label = round(x,2), hjust=0)) +
  ggtitle("Average Likelihood to Recommend by Partner Name") +
  xlab("Partner Name") +
  ylab("Likelihood to Recommend")
PartnerNamePlot + coord_flip()

#####  FLIGHT TIME IN MINUTES ##### 
summary(airData$Flight.time.in.minutes)
airData$Flight.time.in.minutes <- na_interpolation(airData$Flight.time.in.minutes)
hist(airData$Flight.time.in.minutes) 

##### FLIGHT DISTANCE ##### 
summary(airData$Flight.Distance)
hist(airData$Flight.Distance)

##### FLIGHTS PER YEAR ##### 
hist(airData$Flights.Per.Year)
summary(airData$Flights.Per.Year)
# Flights Per Year - LTR
FlightsPerYearPlot <- ggplot(airData, aes(x=Flights.Per.Year, y=Likelihood.to.recommend)) + 
  geom_point(stat="summary") +
  ggtitle("Mean Likelihood to Recommend by Flights per Year")
FlightsPerYearPlot

##### ORIGIN CITY #####
# Origin City - Frequencies
freq_Origin.City	=	aggregate(airData$Destination.City,
                             by	=	list(survey$Origin.City),
                             FUN	=	length)
freq_Origin.City<- freq_Origin.City[order(freq_Origin.City$x),]
least_freq_originc<- freq_Origin.City[1:6,]
most_freq_originc<- freq_Origin.City[207:212,]
# Origin City - MostFrequent
origin.c_freq_bar <- ggplot(most_freq_originc, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
origin.c_freq_bar<-origin.c_freq_bar +theme(axis.text.x = element_text(angle = 30))
origin.c_freq_bar<- origin.c_freq_bar +  ggtitle("Most frequent Origin cities") +xlab("Origin city")+ylab("number of travellers")
origin.c_freq_bar
# Origin City - Least Frequent
origin.c_lest_freq_bar <- ggplot(least_freq_originc, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
origin.c_lest_freq_bar<-origin.c_lest_freq_bar +theme(axis.text.x = element_text(angle = 30))
origin.c_lest_freq_bar<- origin.c_lest_freq_bar +  ggtitle("Least frequent Origin cities") +xlab("Origin city")+ylab("number of travellers")
origin.c_lest_freq_bar
# Origin City - Aggregate LTR
agg_Origin.City	=	aggregate(airData$Likelihood.to.recommend,
                            by	=	list(airData$Origin.City),
                            FUN	=	mean)
agg_Origin.City <- agg_Origin.City[order(agg_Origin.City$x),]
head(agg_Origin.City) # Lowest likelihood.to.recommend
tail(agg_Origin.City) # Highest likelihood.to.recommend

#####  ORIGIN CITY - LTR  ##### 
agg_Origin.City <- agg_Origin.City[order(agg_Origin.City$x),]
originc_top5<- agg_Origin.City[207:212,]
# Top Origin City and Likelihood to Recommend
originc_top_bar <- ggplot(originc_top5, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
originc_top_bar<-originc_top_bar +theme(axis.text.x = element_text(angle = 30))
originc_top_bar<- originc_top_bar +  ggtitle("Origin cities with highest average Likelihood to recommend") +xlab("Origin City")+ylab("Likelihood to recommend")
originc_top_bar
# Bottom Origin City and Likelihood to Recommend
originc_bottom5<- agg_Origin.City[1:5,]
origin_bottom_bar<- ggplot(originc_bottom5, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-1))
origin_bottom_bar<-origin_bottom_bar +theme(axis.text.x = element_text(angle = 30))
origin_bottom_bar<- origin_bottom_bar +  ggtitle("Origin Cities with lowest average Likelihood to recommend") +xlab("Origin City")+ylab("Likelihood to recommend")
origin_bottom_bar

##### ORIGIN STATE #####
# Origin State - Frequencies
freq_Origin.State = aggregate(airData$Origin.State,
                              by = list(airData$Origin.State),
                              FUN = length) 
freq_Origin.State <- freq_Origin.State[order(freq_Origin.State$x),]
least_freq_Origin.State <- freq_Origin.State[1:5,]
most_freq_Origin.State <- freq_Origin.State[45:49,]
# Origin State - Most Frequent 
origin.s_freq_bar <- ggplot(most_freq_Origin.State, aes(x=Group.1,y=x, fill=x)) +
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
origin.s_freq_bar <-origin.s_freq_bar +theme(axis.text.x = element_text(angle = 30))
origin.s_freq_bar <- origin.s_freq_bar +  ggtitle("Most Frequent Origin States") +xlab("Origin States")+ylab("Number of Travelers")
origin.s_freq_bar + scale_color_brewer(palette="Dark2")
origin.s_freq_bar
# Origin State - Least Frequent
origin.s_lest_freq_bar <- ggplot(least_freq_Origin.State, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
origin.s_lest_freq_bar<- origin.s_lest_freq_bar +theme(axis.text.x = element_text(angle = 30))
origin.s_lest_freq_bar<- origin.s_lest_freq_bar +  ggtitle("Least Frequent Origin States") +xlab("Origin States")+ylab("Number of Travelers")
origin.s_lest_freq_bar
# Origin State - Aggregate LTR
agg_Origin.State	=	aggregate(airData$Likelihood.to.recommend,
                             by	=	list(airData$Origin.State),
                             FUN	=	mean)
agg_Origin.State <- agg_Origin.State[order(agg_Origin.State$x),]
head(agg_Origin.State) # Lowest likelihood.to.recommend
tail(agg_Origin.State) # Highest likelihood.to.recommend

##### ORIGIN STATE - LTR ##### 
agg_Origin.State <- agg_Origin.State[order(agg_Origin.State$x),]
origin.s_top5 <- data.frame(agg_Origin.State[45:49,])
# Origin States - LTR
origin.s_top_bar <- ggplot(origin.s_top5, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") + geom_text(aes(label = round(x,2), vjust=-0.5)) + 
  theme(axis.text.x = element_text(angle = 30)) +
  ggtitle("Origin States with Highest Average Likelihood to Recommend") +
  xlab("Origin State") +
  ylab("Likelihood to Recommend")
origin.s_top_bar
# Origin States - LTR
origin.s_bottom5<- agg_Origin.State[1:5,]
origin.s_bottom_bar <- ggplot(origin.s_bottom5, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
origin.s_bottom_bar<-origin.s_bottom_bar +theme(axis.text.x = element_text(angle = 30))
origin.s_bottom_bar<- origin.s_bottom_bar +  ggtitle("Origin States with Lowest Average Likelihood to Recommend") +xlab("Origin State")+ ylab("Likelihood to Recommend")
origin.s_bottom_bar 


##### DESTINATION CITY #####
##Destination 
freq_Destination.City	=	aggregate(airData$Destination.City,
                                  by	=	list(airData$Destination.City),
                                  FUN	=	length)
freq_Destination.City<- freq_Destination.City[order(freq_Destination.City$x),]
least_freq_destinations<- freq_Destination.City[1:6,]
most_freq_destinations<- freq_Destination.City[207:212,]
# Desination City - Most Frequent
desti.c_freq_bar <- ggplot(most_freq_destinations, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
desti.c_freq_bar<-desti.c_freq_bar +theme(axis.text.x = element_text(angle = 30))
desti.c_freq_bar<- desti.c_freq_bar +  ggtitle("Most frequent Desitnation cities") +xlab("Destination city")+ylab("number of travellers")
desti.c_freq_bar+ scale_color_brewer(palette="Dark2")
desti.c_freq_bar
# Destination City - Least Frequent
desti.c_lest_freq_bar <- ggplot(least_freq_destinations, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
desti.c_lest_freq_bar<-desti.c_lest_freq_bar +theme(axis.text.x = element_text(angle = 30))
desti.c_lest_freq_bar<- desti.c_lest_freq_bar +  ggtitle("Least frequent Desitnation cities") +xlab("Destination city")+ylab("number of travellers")
desti.c_lest_freq_bar
# Destination City - Aggregate LTR
agg_Destination.City <-	aggregate(airData$Likelihood.to.recommend,
                                  by	=	list(airData$Destination.City),
                                  FUN	=	mean)
agg_Destination.City <- agg_Destination.City[order(agg_Destination.City$x),]
head(agg_Destination.City) # Lowest likelihood.to.recommend
tail(agg_Destination.City) # Highest likelihood.to.recommend
# Destination City - LTR
agg_Destination.City <- agg_Destination.City[order(agg_Destination.City$x),]
disti.c_top5<- agg_Destination.City[207:212,]
# Destination City - Least Frequent LTR
desti.c_top_bar <- ggplot(disti.c_top5, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
desti.c_top_bar<-desti.c_top_bar +theme(axis.text.x = element_text(angle = 30))
desti.c_top_bar<- desti.c_top_bar +  ggtitle("Destination cities with highest average Likelihood to recommend") +xlab("Origin city")+ylab("Likelihood to recommend")
desti.c_top_bar
# Destination City - Least Frequent LTR
desti.c_bottom5<- agg_Destination.City[1:6,]
desti.c_bottom_bar<- ggplot(desti.c_bottom5, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
desti.c_bottom_bar<-desti.c_bottom_bar +theme(axis.text.x = element_text(angle = 30))
desti.c_bottom_bar<- desti.c_bottom_bar +  ggtitle("Destination cities with lowest average Likelihood to recommend") +xlab("Origin city")+ylab("Likelihood to recommend")
desti.c_bottom_bar

###### DESTINATION STATE ###### 
freq_Destination.State = aggregate(airData$Destination.State,
                                   by = list(airData$Destination.State),
                                   FUN = length) 
freq_Destination.State <- freq_Destination.State[order(freq_Destination.State$x),]
least_freq_Destination.State  <- freq_Destination.State [1:5,]
most_freq_Destination.State  <- freq_Destination.State [44:49,]
# Destination State - Most Frequent
desti.s_freq_bar <- ggplot(most_freq_Destination.State, aes(x=Group.1,y=x, fill=x)) +
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
desti.s_freq_bar <-desti.s_freq_bar +theme(axis.text.x = element_text(angle = 30))
desti.s_freq_bar <- desti.s_freq_bar +  ggtitle("Most Frequent Desitnation States") +xlab("Destination States")+ylab("Number of Travelers")
desti.s_freq_bar + scale_color_brewer(palette="Dark2")
desti.s_freq_bar 
# Destination State - Least Frequent
desti.s_lest_freq_bar <- ggplot(least_freq_Destination.State, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
desti.s_lest_freq_bar<-desti.s_lest_freq_bar +theme(axis.text.x = element_text(angle = 30))
desti.s_lest_freq_bar<- desti.s_lest_freq_bar +  ggtitle("Least Frequent Desitnation States") +xlab("Destination States")+ylab("Number of Travelers")
desti.s_lest_freq_bar
# Destination State - Aggregate LTR
agg_Destination.State	=	aggregate(airData$Likelihood.to.recommend,
                                  by	=	list(airData$Destination.State),
                                  FUN	=	mean)
agg_Destination.State <- agg_Destination.State[order(agg_Destination.State$x),]
head(agg_Destination.State) # Lowest likelihood.to.recommend
tail(agg_Destination.State) # Highest likelihood.to.recommend

# Destination State - Aggregate LTR Bar
agg_Destination.State <- agg_Destination.State[order(agg_Destination.State$x),]
desti.s_top5 <- data.frame(agg_Destination.State[45:49,])
# Top Destination States and Likelihood to Recommend
desti.s_top_bar <- ggplot(desti.s_top5, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") + geom_text(aes(label = round(x,2), vjust=-0.5))
desti.s_top_bar <- desti.s_top_bar + theme(axis.text.x = element_text(angle = 30))
desti.s_top_bar <- desti.s_top_bar + ggtitle("Destination States with Highest Average Likelihood to Recommend") +xlab("Destination State")+ ylab("Likelihood to Recommend")
desti.s_top_bar 
# Bottom Destination States and Likelihood to Recommend
desti.s_bottom5 <- agg_Destination.State[1:5,]
desti.s_bottom_bar<- ggplot(desti.s_bottom5, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
desti.s_bottom_bar<-desti.s_bottom_bar +theme(axis.text.x = element_text(angle = 30))
desti.s_bottom_bar<- desti.s_bottom_bar +  ggtitle("Destination States with Lowest Average Likelihood to Recommend") +xlab("Destination State")+ylab("Likelihood to Recommend")
desti.s_bottom_bar

###### SCHEDULED DEPARTURE HOUR ###### 
summary(airData$Scheduled.Departure.Hour)
hist(airData$Scheduled.Departure.Hour)  
# Frequency
freq_departurehour = aggregate(airData$Scheduled.Departure.Hour,
                              by = list(airData$Scheduled.Departure.Hour),
                              FUN = length) 
freq_departurehour <- freq_departurehour[order(freq_departurehour$x),]
least_freq_departurehour <- freq_departurehour[1:4,]
most_freq_departurehour <- freq_departurehour[19:23,]
# Least Frequent Plot
least_departurehour <- ggplot(least_freq_departurehour, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
least_departurehour<- least_departurehour +theme(axis.text.x = element_text(angle = 30))
least_departurehour<- least_departurehour +  ggtitle("Least Frequent Departure Hour") +xlab("Hour")+ylab("Number of Travelers")
least_departurehour
# Most Frequent Plot
most_departurehour <- ggplot(most_freq_departurehour, aes(x=Group.1,y=x, fill=x)) + 
  geom_bar(stat="identity") +geom_text(aes(label = round(x,2), vjust=-0.5))
most_departurehourr<- most_departurehour +theme(axis.text.x = element_text(angle = 30))
most_departurehour<- most_departurehour+  ggtitle("Most Frequent Departure Hour") +xlab("Hour")+ylab("Number of Travelers")
most_departurehour
# Aggregate Likelihood to Recommend by Scheduled Departure Hour
agg_Departure.hour <- aggregate(airData$Likelihood.to.recommend,
                                by = list(airData$Scheduled.Departure.Hour),
                                FUN = mean)
agg_Departure.hour <- agg_Departure.hour[order(agg_Departure.hour$x),]

##### ARRIVAL DELAY GREATER THAN 5 MINUTES #####
# Creating a matrix for Arrival Delay Greater than 5 Minutes
countarrivaldelay <- table(airData$Arrival.Delay.Above5)
countarrivaldelay
percentarrivaldelay <- prop.table(countarrivaldelay)
percentarrivaldelay
# Histogram for Arrival Delay Greater than 5 Minutes
arrivaldelay.table <- data.frame(table(airData$Arrival.Delay.Above5))
names(arrivaldelay.table)[names(arrivaldelay.table) == "Var1"] <- "Arrival.Delay"
Arrival.Delay.5.Freq <- ggplot(arrivaldelay.table, aes(x=Arrival.Delay, y=Freq)) +
  geom_bar(stat="identity") +
  ggtitle("Arrival Delay Greater than 5 Minutes Frequencies")
Arrival.Delay.5.Freq 
##### ARRIVAL DELAY GREATER THAN 5 - LTR#### 
agg_arrival5 <- aggregate(airData$Likelihood.to.recommend,
                          by = list(airData$Arrival.Delay.Above5),
                          FUN = mean)
agg.arrival5.plot <- ggplot(agg_arrival5, aes(x=Group.1, y=x, fill=x)) + geom_bar(stat="identity") +
  ggtitle("Average Likelihood to Recommend if Arrival Delays Greater than 5 Minutes") +
  geom_text(aes(label = round(x,2), vjust=-0.5)) +
  xlab("If Arrival Delay was Greater than 5 Minutes") +
  ylab("Likelihood to Recommend")
agg.arrival5.plot

##### DEPARTURE DELAY GREATER THAN 5 MINUTES #####
# Dept Delay Greater than 5 - Frequencies
freq_arrival5 <- aggregate(airData$Arrival.Delay.Above5,
                           by = list(airData$Arrival.Delay.Above5),
                           FUN = length)
freq_arrival5 <- ggplot(freq_arrival5, aes(x=Group.1, y=x)) + geom_bar(stat="identity") +
  ggtitle("Frequency of Arrival Delays Greater than 5 Minutes") +
  geom_text(aes(label = round(x,2), vjust=-0.5)) +
  xlab("If Arrival Delay was Greater than 5 Minutes") +
  ylab("Number of Travelers")
freq_arrival5 
##### DEPARTURE DELAY GREATER THAN 5 - LTR ##### 
agg_dept5<- aggregate(airData$Likelihood.to.recommend,
                      by = list(airData$Departure.Delay.Above5),
                      FUN = mean)
agg.delay.plot <- ggplot(agg_dept5, aes(x=Group.1, y=x, fill=x)) + geom_bar(stat="identity") +
  ggtitle("Average Likelihood to Recommend if Departure Delays Greater than 5 Minutes") +
  geom_text(aes(label = round(x,2), vjust=-0.5)) +
  xlab("If DepartureDelay was Greater than 5 Minutes") +
  ylab("Likelihood to Recommend")
agg.delay.plot

##### FLIGHT CANCELLED #####
# Create matrix for Flight.cancelled
countcancelled <- table(airData$Flight.cancelled)
countcancelled
percentcancelled <- data.frame(prop.table(countcancelled))
percentcancelled 
# Histogram for Flight Cancelled
freq_cancelled <- aggregate(airData$Flight.cancelled,
                            by = list(airData$Flight.cancelled),
                            FUN = length)
freq.cancelled <- ggplot(freq_cancelled, aes(x=Group.1, y=x)) + geom_bar(stat="identity") +
  ggtitle("Frequency of Flight Cancellations") +
  geom_text(aes(label = round(x,2), vjust=-0.5)) +
  xlab("Flight Cancelled") +
  ylab("Number of Travelers")
freq.cancelled 
##### FLIGHT CANCELLATIONS - LTR #####
agg_cancelled <- aggregate(airData$Likelihood.to.recommend,
                           by = list(airData$Flight.cancelled),
                           FUN = mean)
CancellationPlot <- ggplot(agg_cancelled, aes(x=Group.1, y=x, fill=x)) + geom_bar(stat="identity") +
  ggtitle("Average Likelihood to Recommend if Flight was Cancelled") +
  geom_text(aes(label = round(x,2), vjust=-0.5)) +
  xlab("Flight Cancelled") +
  ylab("Likelihood to Recommend")
CancellationPlot

##### FLIGHT TIME #####
as.numeric(airData$Flight.time.in.minutes)
summary(airData$Flight.time.in.minutes)

##### FLIGHT DISTANCE - LTR ##### 
hist(airData$Flight.Distance)
agg_flight.distance <- aggregate(airData$Likelihood.to.recommend,
                                 by = list(airData$Flight.Distance),
                                 FUN = mean)
agg_flight.distance <- agg_flight.distance[order(agg_flight.distance$x),]
distance.plot <- ggplot(agg_flight.distance, aes(x=Group.1, y=x) + geom_bar() +
                          ggtitle("Avereage Likelihood to Recommend by Flight Distance") +
                          xlab("Flight Distance in Miles") + ylab("Likelihood to Recommend"))
distance.plot

# Longest distance
which.max(airData$Flight.Distance)
airData[26395,]
freq_flight.distance <- aggregate(airData$Flight.Distance,
                                  by = list(airData$Flight.Distance),
                                  FUN = length)
freq_flight.distance <- freq_flight.distance[order(freq_flight.distance$x),]
FlightDistancePlot <- ggplot(airData, aes(x=Flight.Distance, y=Likelihood.to.recommend)) + 
  geom_point(stat="summary") +
  ggtitle("Average Likelihoood to recommend by Flight Distance")
FlightDistancePlot

####### BI-VARIATE ANALYSIS OF LIKELIHOOD TO RECOMMEND BY FLIGHT CLASS 
survey<- airData
str(survey$Class)
table(survey$Class)
prop.table(table(survey$Class))
Flight.Business<-survey[which(survey$Class=="Business"),]
Flight.Eco<-survey[which(survey$Class=="Eco"),]
Flight.EcoPlus<-survey[which(survey$Class=="Eco Plus"),]

#visualization
#histogram
hist(Flight.Business$Age)
hist(Flight.Business$Price.Sensitivity)
hist(Flight.Business$Year.of.First.Flight)
hist(Flight.Business$Flights.Per.Year)
hist(Flight.Business$Loyalty)
hist(Flight.Business$Total.Freq.Flyer.Accts)
hist(Flight.Business$Shopping.Amount.at.Airport,xlim = c(0,200),breaks = 50)
hist(Flight.Business$Eating.and.Drinking.at.Airport,xlim = c(0,200),breaks = 50)
hist(Flight.Business$Scheduled.Departure.Hour)
hist(Flight.Business$Departure.Delay.in.Minutes,xlim = c(0,200),breaks = 40)
hist(Flight.Business$Arrival.Delay.in.Minutes,xlim = c(0,100),breaks = 40)
hist(Flight.Business$Flight.time.in.minutes)
hist(Flight.Business$Flight.Distance)

#table
table(Flight.Business$Gender)
table(Flight.Business$Class)
table(Flight.Business$Partner.Code)
table(Flight.Business$Flight.cancelled)
table(Flight.Business$Type.of.Travel)

#barplot
barplot(Flight.Business$Flights.Per.Year)

#boxplot
boxplot(Flight.Business$Flights.Per.Year)

#plot
plot(Flight.Business$Flights.Per.Year)
                        
################################## MAPS #######################################                       
install.packages("maps")
install.packages("ggmap")
install.packages("mapproj")
library(maps)
library(ggmap)
library(mapproj)

# Loading states for our U.S state map
us <- map_data("state")

# Creating new dataframes: one for origin and one for destination flights only
originflights <- data.frame(airData$olong, airData$olat)
destinationflights <- data.frame(airData$dlong, airData$dlat)

# Renaming columns
colnames(originflights) <- c("originlong", "originlat")
colnames(destinationflights) <- c("destlong", "destlat")

# Origin Flights Map
originflightsmap <- ggplot(originflights, aes(originflights$originlong, originflights$originlat))
originflightsmap <- originflightsmap + geom_polygon(data=us, aes(x=long, y=lat, group=group), color="black", fill="white")
originflightsmap <- originflightsmap + geom_point(color = "red", size =4)
originflightsmap <- originflightsmap + xlim(-125, -67) + ylim(25,60)
originflightsmap <- originflightsmap + ylab("Latitude") + xlab("Longitude")
originflightsmap <- originflightsmap + ggtitle("Origin Airport Locations")
originflightsmap

# Destination Flights Map
destinationflightsmap <- ggplot(destinationflights, aes(destinationflights$destlong, destinationflights$destlat))
destinationflightsmap <- destinationflightsmap + geom_polygon(data=us, aes(x=long, y=lat, group=group), color="black", fill="white")
destinationflightsmap <- destinationflightsmap + geom_point(color = "dark green", size=5)
destinationflightsmap <- destinationflightsmap + xlim(-125, -67) + ylim(25,60)
destinationflightsmap <- destinationflightsmap + ylab("Latitude") + xlab("Longitude")
destinationflightsmap <- destinationflightsmap + ggtitle("Destination Airport Locations")
destinationflightsmap

#creating new dataframe with the only columns I'm using to make mapping easier, one for origin flights and one for destination flights with score
origin.map <- data.frame(as.numeric(airData$Likelihood.to.recommend), airData$olong, airData$olat)
destination.map <- data.frame(as.numeric(airData$Likelihood.to.recommend), airData$dlong, airData$dlat) 

#renaming columns 
colnames(origin.map) <- c("Recommendation", "originlong", "originlat")
colnames(destination.map) <- c("Recommendation", "destlong", "destlat")

#Map Plot of Origin Airport Location w/ Score
originmap <- ggplot(origin.map, aes(origin.map$originlong, origin.map$originlat))
originmap <- originmap + geom_polygon(data=us, aes(x=long, y=lat, group=group), color="black", fill="white")
originmap <- originmap + geom_point(aes(color=Recommendation), size = 4) + scale_color_gradient2(low = "dodgerblue4", high = "dodgerblue")
originmap <- originmap + xlim(-125, -67) + ylim(25,60)
originmap <- originmap + ylab("Latitude") + xlab("Longitude")
originmap <- originmap + ggtitle("Recommendation by Origin Airport Location")
originmap

#Map Plot of Destination Airport Location w/ Score
destinationmap <- ggplot(destination.map, aes(destination.map$destlong, destination.map$destlat))
destinationmap <- destinationmap + geom_polygon(data=us, aes(x=long, y=lat, group=group), color="black", fill="white")
destinationmap <- destinationmap + geom_point(aes(color=Recommendation), size=4) + scale_color_gradient2(low = "firebrick4", high = "firebrick1")
destinationmap <- destinationmap + xlim(-125, -67) + ylim(25,60)
destinationmap <- destinationmap + ylab("Latitude") + xlab("Longitude")
destinationmap <- destinationmap + ggtitle("Recommendation by Destination Airport Location")
destinationmap

################################ SVM MODEL #####################################
install.packages("kernlab")
install.packages("caret")
library(kernlab)
library(caret)

airData$Likelihood.to.recommend <- as.factor(airData$Likelihood.to.recommend)
trainList <- createDataPartition(y=airData$Likelihood.to.recommend,p=.7,list=FALSE)
trainSet <- airData[trainList,]
testSet <- airData[-trainList,]

trainSet[["Likelihood.to.recommend"]] = factor(trainSet[["Likelihood.to.recommend"]])

#training SVM
svmModel <- ksvm(Likelihood.to.recommend ~ ., data=trainSet, kernel = "rbfdot", 
                 kpar = "automatic", C = 100, cross = 4, prob.model = TRUE )
svmModel 

#Predicitng the training cases
svmPred <- predict(svmModel, newdata=trainSet, type = "response")
summary(svmPred)
str(svmPred)
head(svmPred)
predtable <- table(svmPred, trainSet$Likelihood.to.recommend)
predtable
sum(diag(table(svmPred, trainSet$Likelihood.to.recommend)))/sum(table(svmPred, trainSet$Likelihood.to.recommend))
cmatrix <- confusionMatrix(svmPred, trainSet$Likelihood.to.recommend)                                                              


################################ APRIORI MODEL #################################
install.packages("arules")
install.packages("arulesViz")
library(arules)
library(arulesViz)

x<- is.na(survey$Likelihood.to.recommend)
survey<- survey[x == FALSE,]

a_survey<- survey

y<- is.na(a_survey$Arrival.Delay.in.Minutes)
a_survey<- a_survey[y == FALSE,]

m_survey<- a_survey

#Age- children and senior / mid 
boxplot(a_survey$Age)
summary(a_survey$Age)
a_survey$Age[which(a_survey$Age<33)]<-"15-32 Age"
a_survey$Age[which(a_survey$Age>32 & a_survey$Age<60 )]<-"33-59 Age"
a_survey$Age[which(a_survey$Age>59)]<-"60-85 Age"
unique(a_survey$Age)
a_survey$Age<- as.factor(a_survey$Age)

#status- blue 0 and others 1
a_survey$Airline.Status<- as.factor(a_survey$Airline.Status)
summary(a_survey$Airline.Status)

#shopping
a_survey$Shopping.Amount.at.Airport[which(m_survey$Shopping.Amount.at.Airport >0)]<-"Shopped"
a_survey$Shopping.Amount.at.Airport[which(m_survey$Shopping.Amount.at.Airport <1)]<-"No Shopping"
unique(a_survey$Shopping.Amount.at.Airport)
a_survey$Shopping.Amount.at.Airport<- as.factor(a_survey$Shopping.Amount.at.Airport)
summary(a_survey$Shopping.Amount.at.Airport)

#eating 
table(a_survey$Eating.and.Drinking.at.Airport)
a_survey$Eating.and.Drinking.at.Airport[which(m_survey$Eating.and.Drinking.at.Airport >0)]<-"Eat at Airport"
a_survey$Eating.and.Drinking.at.Airport[which(m_survey$Eating.and.Drinking.at.Airport <1)]<-"Didnt eat at airport"
unique(a_survey$Eating.and.Drinking.at.Airport)
a_survey$Eating.and.Drinking.at.Airport<- as.factor(a_survey$Eating.and.Drinking.at.Airport)
summary(a_survey$Eating.and.Drinking.at.Airport)

#price sensitivity
table(a_survey$Price.Sensitivity)
unique(a_survey$Price.Sensitivity)
a_survey$Price.Sensitivity<- as.factor(a_survey$Price.Sensitivity)
summary(a_survey$Price.Sensitivity)

#Class
unique(a_survey$Class)
a_survey$Class<- as.factor(a_survey$Class)

#Likelihood to recommend
a_survey$Likelihood.to.recommend[which(m_survey$Likelihood.to.recommend <7)]<-"Detractors"
a_survey$Likelihood.to.recommend[which(m_survey$Likelihood.to.recommend >6 & m_survey$Likelihood.to.recommend <9 )]<-"Passives"
a_survey$Likelihood.to.recommend[which(m_survey$Likelihood.to.recommend >8 )]<-"Promoters"
unique(a_survey$Likelihood.to.recommend)
a_survey$Likelihood.to.recommend<- as.factor(a_survey$Likelihood.to.recommend)
table(a_survey$Likelihood.to.recommend)

#Delay in Departure  - no or less than 5 . more than 5 mins
a_survey$Departure.Delay.in.Minutes[which(m_survey$Departure.Delay.in.Minutes <6)]<-"No or < 5 mins delay in depart"
a_survey$Departure.Delay.in.Minutes[which(m_survey$Departure.Delay.in.Minutes >5)]<-"> 5 mins delay in Depart"
unique(a_survey$Departure.Delay.in.Minutes)
a_survey$Departure.Delay.in.Minutes<- as.factor(a_survey$Departure.Delay.in.Minutes)
table(a_survey$Departure.Delay.in.Minutes)

#Delay in Arrival#not working 
a_survey$Arrival.Delay.in.Minutes[which(m_survey$Arrival.Delay.in.Minutes <6)]<-"No or < 5 mins delay in arrival"
a_survey$Arrival.Delay.in.Minutes[which(m_survey$Arrival.Delay.in.Minutes >5)]<-"> 5 mins delay in arrival"
table(m_survey$Arrival.Delay.in.Minutes)
unique(a_survey$Arrival.Delay.in.Minutes)
a_survey$Arrival.Delay.in.Minutes<- as.factor(a_survey$Arrival.Delay.in.Minutes)

#partner name
table(m_survey$Partner.Name)
unique(a_survey$Partner.Name)
a_survey$Partner.Name<- as.factor(m_survey$Partner.Name)
table(is.na(a_survey$Partner.Name))

#new table with new columns 
new_survey<- data.frame(a_survey$Partner.Name,a_survey$Departure.Delay.in.Minutes,a_survey$Likelihood.to.recommend,a_survey$Class,a_survey$Price.Sensitivity,a_survey$Shopping.Amount.at.Airport,a_survey$Age,a_survey$Airline.Status,a_survey$Eating.and.Drinking.at.Airport)
new_survey
#converting to transactions matrix
new_surveyM<- as(new_survey,"transactions")

inspect(new_surveyM)
itemFrequency(new_surveyM)
itemFrequencyPlot(new_surveyM)

rules1<- apriori(new_surveyM,parameter = list(supp= 0.005,conf=0.5),
                 appearance = list(default="lhs", rhs= "a_survey.Likelihood.to.recommend=Detractors"))
inspect(rules1)
inspectDT(rules1) 

rules2<- apriori(new_surveyM,parameter = list(supp= 0.005,conf=0.5),
                 appearance = list(default="lhs", rhs= "a_survey.Likelihood.to.recommend=Promoters"))
inspect(rules2)
inspectDT(rules2) 

rules3<- apriori(new_surveyM,parameter = list(supp= 0.005,conf=0.5),
                 appearance = list(default="lhs", rhs= "a_survey.Likelihood.to.recommend=Passives"))
inspect(rules3)
inspectDT(rules3) 

################################### LM MODEL ###################################
modelage<- lm(formula= Likelihood.to.recommend~Age, data= survey)
model_gender<- lm(formula= Likelihood.to.recommend~Gender, data= survey)
model_Airline.Status<- lm(formula= Likelihood.to.recommend~Airline.Status, data= survey)
model_Price.Sensitivity<- lm(formula= Likelihood.to.recommend~Price.Sensitivity, data= survey)
model_Year.of.First.Flight<- lm(formula= Likelihood.to.recommend~Year.of.First.Flight, data= survey)
model_Loyalty<- lm(formula= Likelihood.to.recommend~Loyalty, data= survey)
model_shop<- lm(formula= Likelihood.to.recommend~Shopping.Amount.at.Airport, data= survey)
model_Type.of.Travel<- lm(formula= Likelihood.to.recommend~Type.of.Travel, data= survey)
model_class<- lm(formula= Likelihood.to.recommend~Class, data= survey)
model_eat<- lm(formula= Likelihood.to.recommend~Eating.and.Drinking.at.Airport, data= survey)
model_f_accs<- lm(formula= Likelihood.to.recommend~Total.Freq.Flyer.Accts, data= survey)
model_Flights.Per.Year<- lm(formula= Likelihood.to.recommend~Flights.Per.Year, data= survey)

summary(modelage)
summary(model_gender)
summary(model_Airline.Status)
summary(model_Price.Sensitivity)
summary(model_Year.of.First.Flight)
summary(model_Loyalty)
summary(model_shop)
summary(model_Type.of.Travel)
summary(model_class)
summary(model_eat)
summary(model_f_accs)
summary(model_Flights.Per.Year)

modelall2<- lm(formula= Likelihood.to.recommend~Airline.Status+Gender+Type.of.Travel,data= survey)
summary(modelall2)
unique(survey$Type.of.Travel)

predDF <- data.frame(Airline.Status = "Silver", Gender="Male", Type.of.Travel="Business travel")
predict(modelall2, predDF)
#9.264907 
predDF <- data.frame(Airline.Status = "Silver", Gender="Female", Type.of.Travel="Mileage tickets")
predict(modelall2, predDF)
#8.907768 
predDF <- data.frame(Airline.Status = "Silver", Gender="Female", Type.of.Travel="Personal Travel")
predict(modelall2, predDF)
#6.580204 

######################## LINEAR AND MULTIPLE REGRESSION ########################
airdata.m<- airData
survey.p<- airdata.m
#Flight.cancelled
#Categorical response variables
#Class
Flight.Business<-survey.p[which(survey.p$Class=="Business"),]
Flight.Eco<-survey.p[which(survey.p$Class=="Eco"),]
Flight.EcoPlus<-survey.p[which(survey.p$Class=="Eco Plus"),]

#Gender
Customer.F<-survey.p[which(survey.p$Gender=="Female"),]
Customer.M<-survey.p[which(survey.p$Gender=="Male"),]

#Type.of.Travel
customer.PT<-survey.p[which(survey.p$Type.of.Travel=="Business travel"),]
customer.BT<-survey.p[which(survey.p$Type.of.Travel=="Personal Travel"),]
customer.MT<- survey.p[which(survey.p$Type.of.Travel=="Mileage tickets"),]                 

#Airline.Status
table(survey.p$Airline.Status)
customer.Blue<- survey.p[which(survey.p$Airline.Status=="Blue"),]
customer.Gold<- survey.p[which(survey.p$Airline.Status=="Gold"),]
customer.Platinum<- survey.p[which(survey.p$Airline.Status=="Platinum"),]
customer.Silver<- survey.p[which(survey.p$Airline.Status=="Silver"),]

#Flight.cancelled
Flight.T<-airdata.m[which(airdata.m$Flight.cancelled=="No"),]
Flight.F<-airdata.m[which(airdata.m$Flight.cancelled=="Yes"),]

#Partner code
table(survey.p$Partner.Code)
dim(table(survey.p$Partner.Code))#14
survey.p[which(survey.p$Partner.Code=="AA"),]

# LINEAR MODEL
model.all<- lm(formula=Likelihood.to.recommend~Arrival.Delay.in.Minutes+Departure.Delay.in.Minutes+Age
               +Price.Sensitivity+Flights.Per.Year+Loyalty+Total.Freq.Flyer.Accts
               + Shopping.Amount.at.Airport+ Eating.and.Drinking.at.Airport+Flight.time.in.minutes
               +Flight.Distance, data= survey.p)
summary(model.all)
predDF<- data.frame(Arrival.Delay.in.Minutes=15.38,Departure.Delay.in.Minutes=14.96,Age=46.17,Gender=0.5634,Price.Sensitivity=1.277,
                    Flights.Per.Year=20,Loyalty=-0.27294,Total.Freq.Flyer.Accts=0.8915,Shopping.Amount.at.Airport=26.69,
                    Eating.and.Drinking.at.Airport=67.98,Flight.time.in.minutes=113.1,Flight.Distance=809.9)
predict(model.all,predDF)#Mean.Likelihood.to.recommend=7.318498, result = 7.318364
mean(survey.p$Likelihood.to.recommend)

# MODEL: CLASS
model.Flight.Business<- lm(formula=Likelihood.to.recommend~Arrival.Delay.in.Minutes+Departure.Delay.in.Minutes+Age
                           +Price.Sensitivity+Flights.Per.Year+Loyalty+Total.Freq.Flyer.Accts
                           + Shopping.Amount.at.Airport+ Eating.and.Drinking.at.Airport+Flight.time.in.minutes
                           +Flight.Distance, data= Flight.Business)
summary(model.Flight.Business)

model.Flight.Business<- lm(formula=Likelihood.to.recommend~Arrival.Delay.in.Minutes+Departure.Delay.in.Minutes+Age
                           +Price.Sensitivity+Flights.Per.Year+Loyalty+Total.Freq.Flyer.Accts
                           + Shopping.Amount.at.Airport+ Eating.and.Drinking.at.Airport+Flight.time.in.minutes
                           +Flight.Distance, data= Flight.Business)
summary(model.Flight.Business)

model.Flight.Eco<- lm(formula=Likelihood.to.recommend~Arrival.Delay.in.Minutes+Departure.Delay.in.Minutes+Age
                      +Price.Sensitivity+Flights.Per.Year+Loyalty+Total.Freq.Flyer.Accts
                      + Shopping.Amount.at.Airport+ Eating.and.Drinking.at.Airport+Flight.time.in.minutes
                      +Flight.Distance, data= Flight.Eco)
summary(model.Flight.Eco)

model.Flight.EcoPlus<- lm(formula=Likelihood.to.recommend~Arrival.Delay.in.Minutes+Departure.Delay.in.Minutes+Age
                          +Price.Sensitivity+Flights.Per.Year+Loyalty+Total.Freq.Flyer.Accts
                          + Shopping.Amount.at.Airport+ Eating.and.Drinking.at.Airport+Flight.time.in.minutes
                          +Flight.Distance, data= Flight.EcoPlus)
summary(model.Flight.EcoPlus)

# MODEL: GENDER
model.Customer.F<- lm(formula=Likelihood.to.recommend~Arrival.Delay.in.Minutes+Departure.Delay.in.Minutes+Age
                      +Price.Sensitivity+Flights.Per.Year+Loyalty+Total.Freq.Flyer.Accts
                      + Shopping.Amount.at.Airport+ Eating.and.Drinking.at.Airport+Flight.time.in.minutes
                      +Flight.Distance, data= Customer.F)
summary(model.Customer.F)

model.Customer.M<- lm(formula=Likelihood.to.recommend~Arrival.Delay.in.Minutes+Departure.Delay.in.Minutes+Age
                      +Price.Sensitivity+Flights.Per.Year+Loyalty+Total.Freq.Flyer.Accts
                      + Shopping.Amount.at.Airport+ Eating.and.Drinking.at.Airport+Flight.time.in.minutes
                      +Flight.Distance, data= Customer.M)
summary(model.Customer.M)

#Model: Type.of.Travel
model.customer.PT<- lm(formula=Likelihood.to.recommend~Arrival.Delay.in.Minutes+Departure.Delay.in.Minutes+Age
                       +Price.Sensitivity+Flights.Per.Year+Loyalty+Total.Freq.Flyer.Accts
                       + Shopping.Amount.at.Airport+ Eating.and.Drinking.at.Airport+Flight.time.in.minutes
                       +Flight.Distance, data= customer.PT)
summary(model.customer.PT)

model.customer.BT<- lm(formula=Likelihood.to.recommend~Arrival.Delay.in.Minutes+Departure.Delay.in.Minutes+Age
                       +Price.Sensitivity+Flights.Per.Year+Loyalty+Total.Freq.Flyer.Accts
                       + Shopping.Amount.at.Airport+ Eating.and.Drinking.at.Airport+Flight.time.in.minutes
                       +Flight.Distance, data= customer.BT)
summary(model.customer.BT)

model.customer.MT<- lm(formula=Likelihood.to.recommend~Arrival.Delay.in.Minutes+Departure.Delay.in.Minutes+Age
                       +Price.Sensitivity+Flights.Per.Year+Loyalty+Total.Freq.Flyer.Accts
                       + Shopping.Amount.at.Airport+ Eating.and.Drinking.at.Airport+Flight.time.in.minutes
                       +Flight.Distance, data= customer.MT)
summary(model.customer.MT)

#Airline.Status
model.customer.Blue<- lm(formula=Likelihood.to.recommend~Arrival.Delay.in.Minutes+Departure.Delay.in.Minutes+Age
                         +Price.Sensitivity+Flights.Per.Year+Loyalty+Total.Freq.Flyer.Accts
                         + Shopping.Amount.at.Airport+ Eating.and.Drinking.at.Airport+Flight.time.in.minutes
                         +Flight.Distance, data= customer.Blue)
summary(model.customer.Blue)

model.customer.Gold<- lm(formula=Likelihood.to.recommend~Arrival.Delay.in.Minutes+Departure.Delay.in.Minutes+Age
                         +Price.Sensitivity+Flights.Per.Year+Loyalty+Total.Freq.Flyer.Accts
                         + Shopping.Amount.at.Airport+ Eating.and.Drinking.at.Airport+Flight.time.in.minutes
                         +Flight.Distance, data= customer.Gold)
summary(model.customer.Gold)

model.customer.Platinum<- lm(formula=Likelihood.to.recommend~Arrival.Delay.in.Minutes+Departure.Delay.in.Minutes+Age
                             +Price.Sensitivity+Flights.Per.Year+Loyalty+Total.Freq.Flyer.Accts
                             + Shopping.Amount.at.Airport+ Eating.and.Drinking.at.Airport+Flight.time.in.minutes
                             +Flight.Distance, data= customer.Platinum)
summary(model.customer.Platinum)

model.customer.Silver<- lm(formula=Likelihood.to.recommend~Arrival.Delay.in.Minutes+Departure.Delay.in.Minutes+Age
                           +Price.Sensitivity+Flights.Per.Year+Loyalty+Total.Freq.Flyer.Accts
                           + Shopping.Amount.at.Airport+ Eating.and.Drinking.at.Airport+Flight.time.in.minutes
                           +Flight.Distance, data= customer.Silver)
summary(model.customer.Silver)

#Flight cancelled or not. No = T, Yes= F
model.Flight.T<- lm(formula=Likelihood.to.recommend~Arrival.Delay.in.Minutes+Departure.Delay.in.Minutes+Age
                    +Price.Sensitivity+Flights.Per.Year+Loyalty+Total.Freq.Flyer.Accts
                    + Shopping.Amount.at.Airport+ Eating.and.Drinking.at.Airport+Flight.time.in.minutes
                    +Flight.Distance, data= Flight.T)
summary(model.Flight.T)

model.Flight.F<- lm(formula=Likelihood.to.recommend~Age+Price.Sensitivity+Flights.Per.Year+Loyalty
                    +Total.Freq.Flyer.Accts+ Shopping.Amount.at.Airport+ Eating.and.Drinking.at.Airport
                    , data= Flight.F)
summary(model.Flight.F)

# LINEAR MODEL FUNCTION
lmf<- function(b){
  model.aa<- lm(formula=Likelihood.to.recommend~Arrival.Delay.in.Minutes+Departure.Delay.in.Minutes+Age
                +Price.Sensitivity+Flights.Per.Year+Loyalty+Total.Freq.Flyer.Accts
                + Shopping.Amount.at.Airport+ Eating.and.Drinking.at.Airport+Flight.time.in.minutes
                +Flight.Distance, data= b)
  return(model.aa)
}

# NPS FUNCTION
#NPS:-100%-100%
NPS<- function(a){
  s<-length(a$Likelihood.to.recommend[which(a$Likelihood.to.recommend>8)])/length(a$Likelihood.to.recommend)-
    length(a$Likelihood.to.recommend[which(a$Likelihood.to.recommend<7)])/length(a$Likelihood.to.recommend)
  return(s)
}

# CALCULATING NPS
#Class
NPS(Flight.Business)
NPS(Flight.Eco)
NPS(Flight.EcoPlus)
NPS.TypeofClass<- c("Business"=NPS(Flight.Business),"Eco"=NPS(Flight.Eco),"EcoPlus"=NPS(Flight.EcoPlus))
barplot(NPS.TypeofClass,legend.text = "NPS",main="Class")

#Gender
NPS(Customer.F)
NPS(Customer.M)
NPS.Gender<- c("Female"=NPS(Customer.F),"Male"=NPS(Customer.M))
barplot(NPS.Gender,main="Gender")

#Type.of.Travel
NPS(customer.PT)
NPS(customer.BT)
NPS(customer.MT)
NPS.Type.of.Travel<- c("PersonalT"=NPS(customer.PT),"BusinessT"=NPS(customer.BT),"MilesT"=NPS(customer.MT))
barplot(NPS.Type.of.Travel,main="Type.of.Travel")

#Airline.Status
NPS(customer.Blue)
NPS(customer.Gold)
NPS(customer.Platinum)
NPS(customer.Silver)
NPS.Airline.Status<- c("Blue"=NPS(customer.Blue),"Gold"=NPS(customer.Gold),"Platinum"=NPS(customer.Platinum),"Silver"=NPS(customer.Silver))
barplot(NPS.Airline.Status,main="Airline.Status")

#Flight cancelled or not. No = T, Yes= F
NPS(Flight.T)
NPS(Flight.F)
NPS.Flight.cancelled<- c("True"=NPS(Flight.T),"False"=NPS(Flight.F))
barplot(NPS.Flight.cancelled,main="Flight.cancelled")

#Flight.Partner
NPS(survey.p[which(survey.p$Partner.Code=="AA"),])
NPS(survey.p[which(survey.p$Partner.Code=="AS"),])
NPS(survey.p[which(survey.p$Partner.Code=="B6"),])
NPS(survey.p[which(survey.p$Partner.Code=="DL"),])
NPS(survey.p[which(survey.p$Partner.Code=="EV"),])
NPS(survey.p[which(survey.p$Partner.Code=="F9"),])
NPS(survey.p[which(survey.p$Partner.Code=="FL"),])
NPS(survey.p[which(survey.p$Partner.Code=="HA"),])
NPS(survey.p[which(survey.p$Partner.Code=="MQ"),])
NPS(survey.p[which(survey.p$Partner.Code=="OO"),])
NPS(survey.p[which(survey.p$Partner.Code=="OU"),])
NPS(survey.p[which(survey.p$Partner.Code=="US"),])
NPS(survey.p[which(survey.p$Partner.Code=="VX"),])
NPS(survey.p[which(survey.p$Partner.Code=="WN"),])
NPS.Partner<- c("AA"=NPS(survey.p[which(survey.p$Partner.Code=="AA"),]),
                "AS"=NPS(survey.p[which(survey.p$Partner.Code=="AS"),]),
                "B6"=NPS(survey.p[which(survey.p$Partner.Code=="B6"),]),
                "DL"=NPS(survey.p[which(survey.p$Partner.Code=="DL"),]),
                "EV"=NPS(survey.p[which(survey.p$Partner.Code=="EV"),]),
                "F9"=NPS(survey.p[which(survey.p$Partner.Code=="F9"),]),
                "FL"=NPS(survey.p[which(survey.p$Partner.Code=="FL"),]),
                "HA"=NPS(survey.p[which(survey.p$Partner.Code=="HA"),]),
                "MQ"=NPS(survey.p[which(survey.p$Partner.Code=="MQ"),]),
                "OO"=NPS(survey.p[which(survey.p$Partner.Code=="OO"),]),
                "OU"=NPS(survey.p[which(survey.p$Partner.Code=="OU"),]),
                "US"=NPS(survey.p[which(survey.p$Partner.Code=="US"),]),
                "VX"=NPS(survey.p[which(survey.p$Partner.Code=="US"),]),
                "WN"=NPS(survey.p[which(survey.p$Partner.Code=="WN"),]))
barplot(NPS.Partner,main="Flight.Partner",cex.names= 0.7)

############################### TEXT ANALYSIS ##################################
install.packages("quanteda")
library(quanteda)

feedback_corpus<- corpus(airData$freeText)
feedback_DFM<- dfm(feedback_corpus, remove_punct = TRUE, remove=stopwords("english"))
feedback_DFM

set.seed(11)
textplot_wordcloud(feedback_DFM, min_count=10)

fb_Matrix	<- as.matrix(feedback_DFM)
fb_Matrix
wordCounts <- colSums(fb_Matrix)
wordCounts<- sort(wordCounts,	decreasing=TRUE)
wordCounts

posWords	<- scan("positive-words.txt",	character(0),	sep	=	"\n")
negWords<-  scan("negative-words.txt",	character(0),	sep	=	"\n")

matchedP	<- match(names(wordCounts),	posWords,	nomatch	=	0)
matchedN	<- match(names(wordCounts),	negWords,	nomatch	=	0)

matchedP 
matchedN

matchedPWords<- wordCounts[matchedP != 0]
matchedNWords<- wordCounts[matchedN != 0]
sum(matchedP != 0)
sum(matchedN != 0)
matchedPWords
matchedNWords
