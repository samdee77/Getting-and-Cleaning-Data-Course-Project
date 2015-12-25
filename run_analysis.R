# set the working  directory to the folder where the data for the project is located.

setwd("C:/Users/sam/Desktop/R-Coursera/UCI HAR Dataset")
#load packagesto be use for the project
library(dplyr)

#1. Merges the training and the test sets to create one data set.


#Proceed to read the training and test data sets into dataframes using the 'read.table()' function.

subject_train<-read.table('train/subject_train.txt')
X_train<-read.table('train/X_train.txt')
y_train<-read.table('train/y_train.txt')

subject_test<-read.table('test/subject_test.txt')
X_test<-read.table('test/X_test.txt')
y_test<-read.table('test/y_test.txt')


#proceed to add column names to the files subject_train and subject_test

colnames(subject_train)<-"subject"
colnames(subject_test)<-"subject"

#proceed to read the name of the features into a variable and add column names for the files
feature_names<-read.table('features.txt')
colnames(X_train)<-feature_names$V2
colnames(X_test)<-feature_names$V2

#proceed to add column name 'activity' to the the label files
colnames(y_train) <- "activity"
colnames(y_test) <- "activity"

#proceed to combine the files into one data named 'dat' making use of the 'cbind()' and 'rbind()' functions 
dat_train<-cbind(subject_train,y_train,X_train)
dat_test<-cbind(subject_test,y_test,X_test)
dat<-rbind(dat_train,dat_test)

#2.Extracts only the measurements on the mean and standard deviation for each measurement.
# proceed to extract the column indices that contain 'mean()' or 'std()' in them.
meanSTDcol<- grepl("mean\\(\\)", names(dat)) | grepl("std\\(\\)", names(dat))

#Add the 'subject' and 'activity' columns to the list and proceed to romove not required columns.
meanSTDcol[1:2]<-TRUE
dat<-dat[,meanSTDcol]

#3. Uses descriptive activity names to name the activities in the data set.
#4. Appropriately labels the data set with descriptive variable names.
#Use the 'factor()' function to change the activity variable from numeric to a factor variable, 
#using the labels argurment to add the descriptive variable names

dat$activity <- factor(dat$activity, labels=c("Walking","Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))


#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity 
#and each subject.
#use the 'aggregate()' function to split the data into subsets, compute the mean and save the result as 'tidy_data'
tidy_data<-aggregate(.~subject+activity,data = dat,mean)
write.table(tidy_data, file = "tidy.txt", row.names = FALSE)