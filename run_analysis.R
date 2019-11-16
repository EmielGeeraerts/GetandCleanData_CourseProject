################################################################################
#This script downloads a messy dataset of accelerometer data from the Samsung 
#Galaxy S smartphone and transforms it into two tidy datasets, one with the full 
#data, the second with averaged data

#This script is created for the Getting and Cleaning Data coursera course
################################################################################
#Check if datafolder exists
if(!dir.exists("./UCI HAR Dataset")){
    #download file if it does not exist
    if(!file.exists("./ActivitySamsung.zip")){
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileUrl, destfile = "./ActivitySamsung.zip", method = "curl")
        }
    
    #extract downloaded zipfile
    unzip("./ActivitySamsung.zip")
}

#1111111111111111111111111111111111111111111111111111111111111111111111111111111
#zipfile contains folder named "UCI HAR Dataset", containing subfolders named
#"test" and "train" and text files describing activity labels and features

#each subfolder contains files with the feature values (X_...), the activity 
#label (y_...) and the subject performing the task(subject_...). Inertial Signals
#folder is not used here.

#We read in each of these files, name their columns and merge on row number
#After doing this for both train and test files, all data is merged into a
#single table
#1111111111111111111111111111111111111111111111111111111111111111111111111111111
#Get feature names: second column of the features.txt file
featNames <- as.character(read.table("./UCI HAR Dataset/features.txt")[[2]])

#Do training data
#load specific datasets
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt") #default sep is ok
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#name columns
names(X_train) <- featNames
names(y_train) <- "activity"
names(subject_train) <- "subject"

#merge train components
train <- cbind(subject_train, y_train, X_train)

#Do test data
#load specific datasets
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt") #default sep is ok
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#name columns
names(X_test) <- featNames
names(y_test) <- "activity"
names(subject_test) <- "subject"

#merge test components
test <- cbind(subject_test, y_test, X_test) #assume rows are in same order

#merge train and test into full activity dataset
#train and test constitute independent observations, so bind rows
act_full <- rbind(train, test)

#2222222222222222222222222222222222222222222222222222222222222222222222222222222
#With our dataset collected, we only extract measurements containing means and
#standard deviations (std).
#2222222222222222222222222222222222222222222222222222222222222222222222222222222
#search column names for the '-mean' and '-std' pattern. 
selectedFeatures <- grep('-mean()|-std()', featNames, value = TRUE, ignore.case = TRUE)

#keep subject and activity feature as well
selectedFeatures <- c("subject", "activity", selectedFeatures)

#subset dataframe to keep only selected features
act <- act_full[selectedFeatures]

#3333333333333333333333333333333333333333333333333333333333333333333333333333333
#Right now, activities in our dataset are denoted by a number, which carries
#little meaning by itself. To make it more clear we change these numbers by 
#the name of the activity they represent
#3333333333333333333333333333333333333333333333333333333333333333333333333333333
#load the activity list legend as a named vector
activity_label <- as.character(read.table("./UCI HAR Dataset/activity_labels.txt")[[2]])
names(activity_label) <- as.character(read.table("./UCI HAR Dataset/activity_labels.txt")[[1]])
#Note that the name of each vector element corresponds to the number in the dataset
my_replace <- function(to_replace, replace_with){
    #this function takes a character vector to_replace and replaces the elements 
    #based on named vector replace_with. Names of replace_with are the values to
    #replace, its elements are the values to replace with.
    #if a value of to_replace has is not present in the names of replace_with,
    #the original value is kept.
    to_replace <- ifelse(to_replace %in% names(replace_with), #check if value can be replaced with something
                         replace_with[to_replace], #replace value
                         to_replace) #keep original
    return(to_replace)
}

act$activity <- my_replace(act$activity, activity_label)
#4444444444444444444444444444444444444444444444444444444444444444444444444444444
#Right now, variable names are not intuitive to read. However, the provided
#features_info.txt clears up a lot. Current abbreviated variable names appear
#preferred over very length alternatives: tBodyGyroJerkMag-std() would become 
#timebodygyroscopicjerkmagnitudestandarddeviation
#Therefore, we feel that current variable names are suffienctly descriptive
#and write current table as-is
#4444444444444444444444444444444444444444444444444444444444444444444444444444444
#write one of the two output tables
write.table(act, file = "ActivityRecognition.txt", row.names = FALSE)

#5555555555555555555555555555555555555555555555555555555555555555555555555555555
#The second output table of the course assignment is a variation on the first,
#with data presented as averages for each activity and subject. 

#5555555555555555555555555555555555555555555555555555555555555555555555555555555
#For this, we use the dplyr function group_by(), followed by a call to 
#summarise_all to get the average of each variable
library(tidyverse)
act_av <- act %>% as_tibble %>%
                group_by(activity, subject) %>%
                    summarise_all(list('average' = mean))

#write the second output table
write.table(act_av, file = "AverageActivityRecognition.txt", row.names = FALSE)
