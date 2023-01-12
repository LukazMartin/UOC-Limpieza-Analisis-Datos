
######## Analysis ######## 

# Read dataset

df <- read.csv('../data/heart.csv')

# Overview 

str(df)

summary(df)

# Pearson correlation

cor_pearson <- cor(df)

cor_pearson[14,]

# Copy of dataframe 

df_def <- df

######## Data cleaning ######## 

# Look for empty values

sapply(df, function(x) sum(is.na(x)))

# Discretization of variable age

df$age[df$age >= 20 & df$age<30] = 2
df$age[df$age >= 30 & df$age<40] = 3
df$age[df$age >= 40 & df$age<50] = 4
df$age[df$age >= 50 & df$age<60] = 5
df$age[df$age >= 60 & df$age<70] = 6
df$age[df$age >= 70 & df$age<80] = 7

# Visualize result of discretization

table(df$age)

######## Outliers ######## 

# Function created for looking for outliers

outliers<-function(x){
  outliers<-boxplot.stats(x)$out
  return (length(outliers))
}

# Apply function for each column

sapply(df, function(x) outliers(x))

# Boxplot of outliers

boxplot(df$trtbps,df$chol,df$thalachh, names =c("trtbps","chol","thalachh"), col=c("blue","red","green"))

# Histogram of variable oldpeak

h<-hist(df$oldpeak,plot=FALSE)
plot(h, xaxt = "n", xlab = "Oldpeak Histogram", ylab = "Counts", main = "", col = "pink")

######## Data Analysis ########

# Group selection

## Agrupación por género
df.male <- df_def[df_def$sex == 1,]
df.female <- df_def[df_def$sex == 0,]

## Agrupación por edad
df.young_adult <- df_def[df_def$age<40,]
df.adult <- df_def[df_def$age>=40&df_def$age<60,]
df.old_adult <- df_def[df_def$age>=60,]

## Agrupación por presión arterial
df.normal_pressure <- df_def[df_def$trtbps<120,]
df.high_pressure <- df_def[df_def$trtbps>=120&df_def$trtbps<130,]
df.hipertension1 <- df_def[df_def$trtbps>=130&df_def$trtbps<140,]
df.hipertension2 <- df_def[df_def$trtbps>=140&df_def$trtbps<180,]
df.crisis_hipertension <- df_def[df_def$trtbps>=180,]

## Agrupación por fallo cardíaco
df.high_output <- df_def[df_def$output == 1,]
df.low_output <-df_def[df_def$output == 0,]

######## Normalization and variance test ########

# qqnorm plots

qqnorm(df.high_output$age,  xlab='Pacientes con fallo cardíaco', ylab='Edad')
qqline(df.high_output$age,col=2)
qqnorm(df.low_output$age,  xlab='Pacientes sin fallo cardíaco', ylab='Edad')
qqline(df.low_output$age,col=2)

# Shapiro test

shapiro.test(df.high_output$age)
shapiro.test(df.low_output$age)

# Fligner test

fligner.test(age ~ output, data = df_def)

# Same steps for variable trtbps

qqnorm(df.high_output$trtbps,  xlab='Pacientes con fallo cardíaco', ylab='Presión arterial')
qqline(df.high_output$trtbps,col=2)
qqnorm(df.low_output$trtbps,  xlab='Pacientes sin fallo cardíaco', ylab='Presión arterial')
qqline(df.low_output$trtbps,col=2)

# Shapiro test

shapiro.test(df.high_output$trtbps)
shapiro.test(df.low_output$trtbps)

# Fligner test

fligner.test(trtbps ~ output, data = df_def)

######## Comparing data groups ########

# Download libraries

if (!require('ggplot2')) install.packages('ggplot2'); library('ggplot2')
if (!require('gridExtra')) install.packages("gridExtra"); library('gridExtra')
if (!require('scales')) install.packages('scales'); library('scales')

# Data plot

ggplot(df_def, aes(x = output, group = sex))+geom_bar(aes(y = ..prop.., fill = factor(..x..)))+geom_text(aes( label = percent(..prop.., accuracy=0.1), y= ..prop.. ), stat= "count", vjust = -.25) + labs(y = "Porcentaje", fill="Output") +facet_grid(~sex) + scale_y_continuous(labels = percent) +ggtitle("Porcentaje de pacientes según output en función del género")

# Summaries

summary(factor(df.male$output))
summary(factor(df.female$output))

# Probability test

prop.test(x = c(72,93), n = c(96,207), alternative="greater", correct = FALSE)

# Wilcox test

wilcox.test(df_def$age~df_def$output)
wilcox.test(df_def$trtbps~df_def$output)

######## Logistic Regression ########

# Create training and testing set

set.seed(1)

sample <- sample(c(TRUE, FALSE), nrow(df_def), replace=TRUE, prob=c(0.8,0.2))
df.train  <- df_def[sample, ]
df.test   <- df_def[!sample, ]

# Create model

Modlg <- glm(output ~ age + sex + cp + trtbps + thalachh + exng + oldpeak + slp + caa + thall, data = df.train, family = binomial)
summary(Modlg)

# Required library

if (!require('caret')) install.packages('caret'); library('caret')

# Prediction

prediction1 <- data.frame(predict(Modlg, df.test[,1:13], type = "response"))
prediction2 <- data.frame(ifelse(prediction1 < 0.5, 0, 1))

confusionMatrix(data=as.factor(prediction2$predict.Modlg..df.test...1.13...type....response..), reference=as.factor(df.test$output))

######## Visualizations ########

# Table of variable age, sex and output

sex<-c("","female","male")
adult_under_40<-c("",paste(round((sum(df.female$age<40&df.female$output==1)/sum(df.female$age<40))*100,2),"%"),
                  paste(round((sum(df.male$age<40&df.male$output==1)/sum(df.male$age<40))*100,2),"%"))

adult_40_to_50<-c("",paste(round((sum(df.female$age>=40&df.female$age<50&df.female$output==1)/
                                    sum(df.female$age>=40&df.female$age<50))*100,2),"%"),
                  paste(round((sum(df.male$age>=40&df.male$age<50&df.male$output==1)/sum(df.male$age>=40&df.male$age<50))*100,2),"%"))

adult_50_to_60<-c("",paste(round((sum(df.female$age>=50&df.female$age<60&df.female$output==1)/
                                    sum(df.female$age>=50&df.female$age<60))*100,2),"%"),
                  paste(round((sum(df.male$age>=50&df.male$age<60&df.male$output==1)/sum(df.male$age>=50&df.male$age<60))*100,2),"%"))

adult_60_to_70<-c("",paste(round((sum(df.female$age>=60&df.female$age<70&df.female$output==1)/
                                    sum(df.female$age>=60&df.female$age<70))*100,2),"%"),
                  paste(round((sum(df.male$age>=60&df.male$age<70&df.male$output==1)/sum(df.male$age>=60&df.male$age<70))*100,2),"%"))

adult_over_70<-c("",paste(round((sum(df.female$age>=70&df.female$output==1)/
                                   sum(df.female$age>=70))*100,2),"%"),
                 paste(round((sum(df.male$age>=70&df.male$output==1)/sum(df.male$age>=70))*100,2),"%"))

table<-data.frame(sex,adult_under_40,adult_40_to_50, adult_50_to_60, adult_60_to_70,adult_over_70)
knitr::kable(t(table))

# Lineplot of variables sex, blood pressure by groups

plot(c(1,2,3,4,5,1,2,3,4,5),c(sum(df.normal_pressure$sex==1),sum(df.high_pressure$sex==1),sum(df.hipertension1$sex==1),
                              sum(df.hipertension2$sex==1),sum(df.crisis_hipertension$sex==1),sum(df.normal_pressure$sex==0),sum(df.high_pressure$sex==0),sum(df.hipertension1$sex==0),
                              sum(df.hipertension2$sex==0),sum(df.crisis_hipertension$sex==0)),xaxt="n",ylab="Amount (people)",xlab="Blood Pressure",lwd=2)
lines(c(1,2,3,4,5),c(sum(df.normal_pressure$sex==1),sum(df.high_pressure$sex==1),sum(df.hipertension1$sex==1),
                     sum(df.hipertension2$sex==1),sum(df.crisis_hipertension$sex==1)),col="red",lwd=2)
xtick<-c("Normal","High Pressure","Hipertension1","Hipertension2","Crisis Hipertension")
axis(1, at=1:5, labels=xtick)
lines(c(1,2,3,4,5),c(sum(df.normal_pressure$sex==0),sum(df.high_pressure$sex==0),sum(df.hipertension1$sex==0),
                     sum(df.hipertension2$sex==0),sum(df.crisis_hipertension$sex==0)),col="blue",lwd=2)
legend(4.5, 50, legend=c("MALE", "FEMALE"),
       col=c("red", "blue"), lty=1:2, cex=0.8,bg='lightblue',text.font=4)

# Lineplot of variables sex, blood pressure and age by groups

plot(c(1,2,3,1,2,3),c(mean(df.young_adult[df.young_adult$sex==1,]$trtbps),mean(df.adult[df.adult$sex==1,]$trtbps),
                      mean(df.old_adult[df.old_adult$sex==1,]$trtbps),
                      mean(df.young_adult[df.young_adult$sex==0]$trtbps),mean(df.adult[df.adult$sex==0,]$trtbps),
                      mean(df.old_adult[df.old_adult$sex==0,]$trtbps)),
     xaxt="n",ylab="Blood pressure (mean mmHg)",xlab="Blood Pressure in different group ages",lwd=2)
lines(c(1,2,3),c(mean(df.young_adult[df.young_adult$sex==1,]$trtbps),mean(df.adult[df.adult$sex==1,]$trtbps),
                 mean(df.old_adult[df.old_adult$sex==1,]$trtbps)),col="red",lwd=2)
lines(c(1,2,3),c( mean(df.young_adult[df.young_adult$sex==0]$trtbps),mean(df.adult[df.adult$sex==0,]$trtbps),
                  mean(df.old_adult[df.old_adult$sex==0,]$trtbps)),col="blue",lwd=2)
xtick<-c("Young Adult (<40)","Adult (40-60)","Older Adult (>60)")
axis(1, at=1:3, labels=xtick)
legend(1.2,136, legend=c("MALE", "FEMALE"),
       col=c("red", "blue"), lty=1:2, cex=0.8,bg='lightblue',text.font=4)





