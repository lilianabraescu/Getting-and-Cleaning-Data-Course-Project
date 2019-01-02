# Getting and Cleaning Data: Course Project
        # "Human Activity Recognition Using Smartphones"

# Necessary Packages 
library(data.table)  
library(dplyr)

        # Download Data Set
if(!file.exists("./Samsungdata")){
        dir.create("./Samsungdata")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./Samsungdata/Samsung.zip", method = "curl", mode = "wb")
## Unzip
if (!file.exists("./UCI HAR Dataset")) {
        unzip(zipfile = "./Samsungdata/Samsung.zip", exdir = "./Samsungdata")}

        # Read Data
features <- read.table("Samsungdata/UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("Samsungdata/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("Samsungdata/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("Samsungdata/UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("Samsungdata/UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("Samsungdata/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("Samsungdata/UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("Samsungdata/UCI HAR Dataset/train/y_train.txt", col.names = "code")


        # 1. Merge the training and the test sets to create one data set
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(x, y, subject)
# Check dimensions before and after data were merged
dim(x_train); dim(x_test); dim(x)
dim(y_train); dim(y_test); dim(y)
dim(subject_train); dim(subject_test); dim(subject)
str(Merged_Data)


        # 2. Extract measurements on the mean and standard deviation
mean_std <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))


        # 3. Use descriptive activity names to name the activities in the data set
descriptive_activity <- activities[mean_std$code, 2]


        # 4. Appropriately labels the data set with descriptive variable names
names(mean_std) <- gsub("^t", "time", names(mean_std))           # prefix "t" becomes "time"
names(mean_std) <- gsub("^f", "frequency", names(mean_std))      # prefix "f" becomes "frequency"
names(mean_std) <- gsub("Acc", "accelerometer", names(mean_std)) # "Acc" becomes "accelerometer"
names(mean_std) <- gsub("Gyro", "gyroscope", names(mean_std))    # "Gyro" becomes "gyroscope"
names(mean_std) <- gsub("Mag", "magnitude", names(mean_std))     # "Mag" becomes "magnitude"
names(mean_std) <- gsub("BodyBody", "Body", names(mean_std))     # "BodyBody" becomes "Body"
names(mean_std)[2] = "descriptive_activity"                      # "code" becomes "descriptive_activity"
names(mean_std)


        # 5. Independent tidy data set with the average of each variable for each activity and each subject
Merged_Data$subject <- as.factor(Merged_Data$subject)                  # set "subject" as a factor variable
Merged_Data <- data.table(Merged_Data)
Tidy_Data <- aggregate(. ~subject + descriptive_activity, Merged_Data, mean) # create tidy data set
Tidy_Data <- Tidy_Data[order(Tidy_Data$subject, Tidy_Data$descriptive_activity),]
write.table(Tidy_Data, "Tidy_Data.txt", row.name=FALSE)                # create txt file for submission
