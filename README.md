# GetandCleanData_CourseProject
Repo for Course Project of the coursera Getting and Cleaning data course

## Context 
The objective for this course's project is to create a tidy datasets and a supporting code book, starting from a messy dataset of accelerometer data from the Samsung Galaxy S smartphone. 
Detailed information on the starting dataset can be found [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). 

The actual data is hosted [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)


## Content

### CodeBook.md
Describes variables, data, and a summary of the transformations performed on the original dataset. 

### run_analysis.R
Script to create tidy datasets starting from the described input material.

### ActivityRecognition.csv
A tidy dataset created by passing running the run_analysis.R script, the variables and data of which are described in CodeBook.md.

### AverageActivityRecognition.csv
A tidy dataset, similar to ActivityRecognition.csv, .but instead containing the average of each variable for each activity and each subject.
