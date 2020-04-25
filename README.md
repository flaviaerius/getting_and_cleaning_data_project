# Dataset of features measurement per activity

This repository contains the script *run_analysis.R* which performs analysis of sensors measurement captured by a smartphone for 6 different activities performed by 30 subjects.
It also contains the codebook for the tidy dataset which is the last output of the script, describing the variables.

The script should be run locally.

First of all, the script will clean the environment:

```Rscript
rm(list = ls())
```
Then, it will load the libraries needed to perform alterations in the data, tidyverse and maggritr:

```Rscript
if (!require(tidyverse)) install.packages('tidyverse')
library(tidyverse)

if (!require(maggritr)) install.packages('maggritr')
library(maggritr)
```
After that, the script will download the required data, unzip it, and read the files needed (train and test sets) into R:

```Rscript
con <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(con, destfile = "activities.zip", method = "curl")

# unzip the file
unzip("activities.zip")
list.files()

# change to wd
setwd("UCI HAR Dataset")

# read train and test sets and labels first of all
setwd("test/")
test_set <- read.table("X_test.txt")
test_labels <- read.table("y_test.txt")

setwd("../train/")
train_set <- read.table("X_train.txt")
train_labels <- read.table("y_train.txt")
```

With train and test data inside R, the script will merge the two datasets in one, completing the first task required by the course, which is:

### 1. Merges the training and the test sets to create one data set.

```Rscript
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
```
The next part of the script will complete the second task, which is:

### 2. Extracts only the measurements on the mean and standard deviation for each measurement.

Basically, it will extract mean and standard deviation values for each measurement, and write them out of R:

``` Rscript
mean_data <- train_and_test_data %>% group_by(labels) %>%
      summarise_all(mean)
sd_data <- train_and_test_data %>% group_by(labels) %>%
      summarise_all(sd)

# write out a .txt for each one
setwd("..")
write.table(mean_data, "mean_train_and_test_data.txt")
write.table(sd_data, "sd_train_and_test_data.txt")
```

Next part of the script will add the activities names to the dataset, which are WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING. This is the third part of the task:
### 3. Uses descriptive activity names to name the activities in the data set

```Rscript
# read the activity labels file
activity_labels <- read.table("activity_labels.txt")

# transform column "levels" into a factor
train_and_test_data$labels <- factor(train_and_test_data$labels)
levels(train_and_test_data$labels)
levels(train_and_test_data$labels) <- activity_labels$V2
# done
```

Next, the columns will be appropriately named, as the fourth part of the task:
### 4. Appropriately labels the data set with descriptive variable names.

```Rscript
# read in the file with sensors labels
columns <- read.table("features.txt", stringsAsFactors = F)

# change the names to extensible ones
columns <- columns$V2

# t is time
columns <- gsub("^t", "time", columns)

# f is frequency
columns <- gsub("^f", "frequency", columns)

# Acc is accelerometer
columns <- gsub("Acc", "Accelerometer", columns)

# Gyro is gyroscope
columns <- gsub("Gyro", "Gyroscope", columns)

# Mag is magnitude
columns <- gsub("Mag", "Magnitude", columns)

# BodyBody is mistaken, substitute by Body only
columns <- gsub("BodyBody", "Body", columns)

# change name of 555 to 558
columns[555] <- "angle(timeBodyAccelerometerMean,gravity)"

columns[556] <- "angle(timeBodyAccelerometerJerkMean),gravityMean)"

columns[557] <- "angle(timeBodyGyroscopeMean,gravityMean)"

columns[558] <- "angle(tBodyGyroscopeJerkMean,gravityMean)"

# set colnames of train_and_test_data starting from second col as columns$V2
colnames(train_and_test_data) <- c("labels", columns)
```

And, finally, the last part of the script will create a tidy dataset containing the average of each variable for each activity and subject, and write it out of R, as a tsv file.
### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

```Rscript
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
```

With this, the script part of the assignment is completed.


