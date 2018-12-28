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
mean_std

        # 3. Use descriptive activity names to name the activities in the data set
descriptive_activ <- activities[mean_std$code, 2]
descriptive_activ

        # 4. Appropriately labels the data set with descriptive variable names
names(Merged_Data) <- gsub("^t", "time", names(Merged_Data))           # prefix "t" becomes "time"
names(Merged_Data) <- gsub("^f", "frequency", names(Merged_Data))      # prefix "f" becomes "frequency"
names(Merged_Data) <- gsub("Acc", "accelerometer", names(Merged_Data)) # "Acc" becomes "accelerometer"
names(Merged_Data) <- gsub("Gyro", "gyroscope", names(Merged_Data))    # "Gyro" becomes "gyroscope"
names(Merged_Data) <- gsub("Mag", "magnitude", names(Merged_Data))     # "Mag" becomes "magnitude"
names(Merged_Data) <- gsub("BodyBody", "Body", names(Merged_Data))     # "BodyBody" becomes "Body"
names(Merged_Data)[2] = "activity" # "code" column from Merged_data becomes "activity"
names(Merged_Data)

        # 5. Independent tidy data set with the average of each variable for each activity
Tidy_Data <- Merged_Data %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))
write.table(Tidy_Data, "Tidy_Data.txt", row.name=FALSE) # create txt file (requested for submission)

