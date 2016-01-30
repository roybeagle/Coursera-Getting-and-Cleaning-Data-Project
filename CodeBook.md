### Introduction

This code book that describes the variables, the data, and any transformations or work that was performed to clean up the data.
 
###  Data Set

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

###  The experimental "information"

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

### Data Files from the experiment to be merged and processed

* 'features_info.txt': Shows information about the variables used on the feature vector.
* 'features.txt': List of all features.
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt': Training set.
* 'train/y_train.txt': Training labels.
* 'test/X_test.txt': Test set.
* 'test/y_test.txt': Test labels.
* 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
* 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
* 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
* 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.

###  Datavariables

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

### Transformations and work done on data sets

1. Download, unzip, save, and loads necessary files into workspace.  
```
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "Dataset.zip")
unzip("Dataset.zip")
```
2. The files needed for this tidy set as described in the README.md.  The files are read as table format and data frames are created from them.
```
train<-read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
train_act<-read.table("./UCI HAR Dataset/train/y_train.txt")
train_sub<-read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)
test<-read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
test_act<-read.table("./UCI HAR Dataset/test/y_test.txt")
test_sub<-read.table("./UCI HAR Dataset/test/subject_test.txt")
```
3. In the test/training data the activities variable contains non ordinal numerical values.  These will be replaced by their proper names from the activity_labels file.
```
activity<-read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE, colClasses="character")
train_act$V1<-factor(train_act$V1,levels=activity$V1,label=activity$V2)
test_act$V1<-factor(test_act$V1,levels=activity$V1,label=activity$V2)
```
4.  The varaible/column names in the test/train set are changed to thier informational names from the features names table.  The subject and activity columns will be changed manualy. 
```
feats<-read.table("./UCI HAR Dataset/features.txt", header=FALSE)
colnames(train)<-feats$V2
colnames(test)<-feats$V2

colnames(train_act)<-"Activity"
colnames(test_act)<-"Activity"

colnames(train_sub)<-"Subject"
colnames(test_sub)<-"Subject"
```
5.  Now that all the necessary changes have been made to the individual data sets, they can now be merged into one comprehensive data frame.  Additional columns are added via column joins (there is no inner or outer since data index is one to one).  Additional fields are added via row binds.
```
train<-cbind(train, train_act)
train<-cbind(train, train_sub)
test<-cbind(test,test_act,test_sub)
master_data<-rbind(train,test)
```
6.  The mean and standard deviation is derived for each feature/column for all numerical variables (exclude subject and activity).
```
data_means<-sapply(master_data[-c(562:563)],mean,na.rm=TRUE)
data_sd<-sapply(master_data[-c(562:563)],sd,na.rm=TRUE)
```
7.  Calculate the mean for each activity by activity by subject and the Save the "tidy" dataset that is created to a .csv file named "tidy.csv".
```
library(data.table)
mister_table<-data.table(master_data)
mister_tidy<-mister_table[,lapply(.SD,mean),by="Activity,Subject"]
write.table(mister_tidy,file="tidy.csv",sep=",", col.names=NA)
```
