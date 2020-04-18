## Peer-graded Assignment: Getting and Cleaning Data Course Project ##

# First, clean environment
rm(list = ls())

# Then, load libraries
if (!require(tidyverse)) install.packages('tidyverse')
library(tidyverse)

if (!require(maggritr)) install.packages('maggritr')
library(maggritr)

# download the file
con <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(con, destfile = "activities.zip", method = "curl")

# read file into R
unzip("activities.zip")
list.files()

# change to wd
setwd("UCI HAR Dataset")

# read train and test sets and labels first of all
setwd("test/")
test_set <- read.table("X_test.txt")
test_labels <- read.table("y_test.txt")

setwd("train/")
train_set <- read.table("X_train.txt")
train_labels <- read.table("y_train.txt")

# 1. Merges the training and the test sets to create one data set.
dim(test_set)
dim(train_set)
# both have same number of columns, but different number of rows

# first, I will add the labels doing a cbind, because it is the same number
# of rows between the sets and the equivalent labels
test_data <- cbind(test_labels, test_set)
colnames(test_data)[1] <- "labels"
train_data <- cbind(train_labels, train_set)
colnames(train_data)[1] <- "labels"

# now, bind both together by rbind (bind by row)
train_and_test_data <- rbind(train_data, test_data)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
mean_data <- train_and_test_data %>% group_by(labels) %>%
      summarise_all(mean)
sd_data <- train_and_test_data %>% group_by(labels) %>%
      summarise_all(sd)

# write out a .txt for each one
write.table(mean_data, "mean_train_and_test_data.txt")
write.table(sd_data, "sd_train_and_test_data.txt")

# 3. Uses descriptive activity names to name the activities in the data set

# read the activity labels file
activity_labels <- read.table("../activity_labels.txt")

# transform column "levels" into a factor
train_and_test_data$labels <- factor(train_and_test_data$labels)
levels(train_and_test_data$labels)
levels(train_and_test_data$labels) <- activity_labels$V2
# done

# 4. Appropriately labels the data set with descriptive variable names.
# here I need to set variables as the colnames
# the number of cols is 562 and number of features are 561. All cols but first represent
# features. 

# read in te file with sensors labels
columns <- read.table("../features.txt", stringsAsFactors = F)

# set colnames of train_and_test_data starting from second col as columns$V2
colnames(train_and_test_data) <- c("labels", columns$V2)

# 5. From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable 
# for each activity and each subject.

# get subject id from each data
subject_test <- read.table("../test/subject_test.txt")
subject_train <- read.table("../train/subject_train.txt")

# bind both by row (rbind)
subjects <- rbind(subject_train, subject_test)

# bind both to the set built in 4
train_and_test_complete <- cbind(subjects, train_and_test_data)
colnames(train_and_test_complete)[1] <- "subject"

# write this dataset out
write.table(train_and_test_complete, "data_labeled_task4.tsv",
            col.names = T, row.names = F, quote = F, sep = "\t")

# get the mean
mean_complete <- train_and_test_complete %>% 
      setNames(make.names(names(.), unique = TRUE)) %>%
      group_by(labels, subject) %>%
      summarise_all(mean)

# write out
write.table(mean_complete, "average_data_labeled_task5.tsv",
            col.names = T, row.names = F, quote = F, sep = "\t")
