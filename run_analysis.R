library(tidyverse)

## download data from website and unzip dataset

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "dataset.zip", mode = "wb")
unzip("dataset.zip")

## merge training and test data sets

### reading files

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

feature_name <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)

activity_label <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)

### merging dataset using cbind and rbind

names <- c("subject_id", feature_name$V2, "activity_id")
merge_train <- cbind(subject_train, X_train, y_train)
merge_test <- cbind(subject_test, X_test, y_test)
mergedata <- rbind(merge_train, merge_test)
colnames(mergedata) <- names

colnames(activity_label) <- c("activity_id", "activity_name")

## extract measurements on `mean` and `std` for each sample

feature_mean_std <- mergedata[, grepl("subject_id|activity_id|mean|std", names)]

## name `activity_id` with descriptive activity names given in activity-label

feature_named_act <- merge(feature_mean_std, activity_label, by = "activity_id")
feature_named_act$"activity_id" = NULL

## new dataset averaged over individual groups of `activity` + `subject`

unique_act_sub <- aggregate(. ~ subject_id + activity_name, feature_named_act, FUN = mean)
unique_act_sub <- arrange(unique_act_sub, subject_id, activity_name)
write.table(unique_act_sub, "unique_act_sub.txt", row.names = FALSE)
