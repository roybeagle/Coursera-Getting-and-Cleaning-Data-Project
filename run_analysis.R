setwd("C:/Users/Ivan/Desktop/Coursera Datascience/cleaning data/week4/UCI HAR Dataset")

# Download unzip and save dataset
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "Dataset.zip")
unzip("Dataset.zip")

#Load data set into R, these are text files with space sep, use read.table
train<-read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
#str(train) V1 is int
train_act<-read.table("./UCI HAR Dataset/train/y_train.txt")
#View(train_act) activities as numeric
train_sub<-read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)
#View(train_sub) subjects as numeric ID
test<-read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
test_act<-read.table("./UCI HAR Dataset/test/y_test.txt")
test_sub<-read.table("./UCI HAR Dataset/test/subject_test.txt")

#Load the descriptive information for activity numeric labels and replace ints for labels.
activity<-read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE, colClasses="character")
train_act$V1<-factor(train_act$V1,levels=activity$V1,label=activity$V2)
test_act$V1<-factor(test_act$V1,levels=activity$V1,label=activity$V2)

#Change variable names in the dataset to their proper feature names
feats<-read.table("./UCI HAR Dataset/features.txt", header=FALSE)
colnames(train)<-feats$V2
colnames(test)<-feats$V2

colnames(train_act)<-"Activity"
colnames(test_act)<-"Activity"

colnames(train_sub)<-"Subject"
colnames(test_sub)<-"Subject"

#Merge all datasets into the appropriate test/train set. cbind since they all have the same index
train<-cbind(train, train_act)
train<-cbind(train, train_sub)
test<-cbind(test,test_act,test_sub)
master_data<-rbind(train,test)

#Extract mean and SD for each feature (exclude non-numeric and subjects)in the master data set
data_means<-sapply(master_data[-c(562:563)],mean,na.rm=TRUE)
data_sd<-sapply(master_data[-c(562:563)],sd,na.rm=TRUE)

#create a tidy data set from the merged data set
library(data.table)
mister_table<-data.table(master_data)
mister_tidy<-mister_table[,lapply(.SD,mean),by="Activity,Subject"]
write.table(mister_tidy,file="tidy.csv",sep=",", col.names=NA)

