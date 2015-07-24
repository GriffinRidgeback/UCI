---
title: "ReadMe"
author: "Kevin E. D'Elia"
date: "07/22/2015"
output: html_document
---

# Repository UCI
This repository contains the project work done for my Coursera class __Getting and Cleaning Data__.

The purpose of this project is to demonstrate my ability to collect, work with, and clean a data set. The goal is to prepare a dataset which meets the principles of tidy data^3^ and that can be used for later analysis.  To this end, the file __run_analysis.R__ contains the R code necessary for the task.

The dataset which is constructed during the initial processing of the data is a "messy" dataset because of the following violations of the tidy data principles:

1. There are duplicate columns (i.e., every column does not contain a different variable)
2. Not every row is a single observation

The motivation for the project comes from research being done in the area of wearable computing^1^.  The data used in the project is data collected from the accelerometers of the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained^2^.

Guidelines for approaching the project work can be found in the Coursera Course Project Forum^4^, ^5^.

In addition to this README, there is a file in the repository named CodeBook.md which describes the variables, the data, and any transformations or work performed to clean up the data.

## Environment
* __R version__: R version 3.2.0 (2015-04-16)
* __R Studio version__: RStudio Desktop 0.99.467
* __Operating environment(s)__: Mac OS/X Yosemite, Ubuntu 14.04, RHEL 6.6
* __Dependencies__: This script will require the following library to be installed and available - dplyr

**NOTE**:  This script was developed and executed on Unix-like platforms and makes no provisions for running on a non-Unix platform.  A future version may take into consideration the target execution platform and adjust paths accordingly.

## Overview of run_analysis.R
0. Obtain and extract the data
1. Merge the training and the test sets to create one data set
2. Extract only the columns containing values for the mean and standard deviation of each measurement
3. Use descriptive activity names to name the activities in the data set
4. Appropriately label the data set columns with descriptive variable names
5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject

## Detailed explanation
### Step 0 - Obtain and extract the data  
The dataset under analysis (*UCI HAR Dataset*) is obtained from the UCI Machine Learning Repository^2^.  The script __run_analysis.R__ contains code to:

1. set the working directory to the directory from which the script is run  
2. check for the existence of the compressed data file  
3. if the compressed data file does not exist:  
+ the file will be downloaded as *data.zip* from the link pointing to the UCI Machine Learning Repository^2^  
+ the compressed file will be extracted to the *data* directory, relative to the current working directory  
+ the files for analysis will reside in *data/UCI HAR Dataset*, *data/UCI HAR Dataset/train*, and *data/UCI HAR Dataset/test*  

**NOTE**:  The code to do the actual download and extraction has been commented out due to the prohibitive time of the download.  Prior to executing the script, it is expected that the user of the script has downloaded the file directly from the page link (__*much*__ faster!) and extracted the contents to the following directories: *./data*, *./data/train*, and *./data/test*.  Step 1 of the script will verify the existence of this directory and exit the script should it not exist.

### Step 1 - Merge the training and the test sets to create one data set  
The script first checks for the existence of the directory *./data*, which is relative to the location of the script.  If this directory does not exist, the script exits with an appropriate message.
Once the existence of the *./data* has been confirmed, the script will read in a total of 8 files.  A description of each file follows:

+ __activity_labels.txt__:  contains textual descriptions of the activities performed by the volunteer subjects (WALKING, etc.)  
+ __features.txt__: contains the names of the measurements taken during training/test (tBodyAcc-mean()-X).  Information regarding the approach to naming the measurements can be found at the UCI Machine Learning Repository^2^.  
+ __train/subject_train.txt__: contains the subject IDs which participated in the training sessions  
+ __train/y_train.txt__: contains the activity IDs which were performed by the training subjects  
+ __train/X_train.txt__: contains the measurements captured during the training sessions  
+ __train/subject_train.txt__: contains the subject IDs which participated in the testing sessions  
+ __train/y_train.txt__: contains the activity IDs which were performed by the testing subjects  
+ __train/X_train.txt__: contains the measurements captured during the testing sessions  

**NOTE**: The dataset also includes Inertial Signals data for both the training and testing sessions.  These data files were not used in the analysis.

### Step 2 - Extract only the columns containing values for the mean and standard deviation of each measurement
After the data has been read in successfully, the column headers are set using the text __SubjectID__, __Activity__, and the contents of the second column from __features.txt__.  Duplicate columns are then identified and the dataset is subsetted using the logical vector of unique columns.  Then the data is sorted first by __SubjectID__, then __Activity__.  The column names are extracted and a grep is run against them to extract the column indices for mean and standard deviation measurements. The guideline for coding the regular expression to determine which columns to keep is that any column name which includes the text __mean()__ or __std()__ was selected; all others were excluded.  This includes ones such as *angle(X,gravityMean)* [which was excluded because *mean* is a parameter] and *fBodyBodyGyroJerkMag-meanFreq()* [which was excluded because it was a weighted average].  This vector of indices is used to subset the original dataset to create a reduced dataset containing measurements for mean and standard deviations values only.

### Step 3 - Use descriptive activity names to name the activities in the data set
After the original dataset has been reduced to one containing only mean and standard deviation measurements, the numerical values which are contained in the __Activity__ column are converted to textual values using the information contained in the __activity_labels.txt__ data.  The conversion is achieved through the use of a loop which iterates over the length of the __activity_labels__ vector and subsets the dataset based on loop index, replacing the __Activity__ column value of all matching rows with the corresponding entry from the __activity_labels__ vector.  

### Step 4 - Appropriately label the data set columns with descriptive variable names
The first step in this phase of processing extracts the column headers in order to modify them to more meaningful names.  The modification steps are to replace all __-mean()-__ and __-std()-__ text with __Mean__ and __Std__, respectively.  The final modification is to prefix all measurement column headers with the Greek letter mu, which represents an arithmetic mean value, and enclose the column headers in parentheses.  The existing columns of the dataset are then overlaid with the new column headers.

### Step 5 - From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject
The final step in the processing is to do the analysis.  The dataset is grouped by __SubjectID__ and __Activity__ and the columns associated with the grouping are summarized via the mean function.  The output of the analysis is written to the local file system using __write.table__ with no specific options other than the defaults; the name of the output file is __tidy_data.txt__ and can be read back into R for verification using __tidy  <- read.table("./tidy_data.txt", header=TRUE)__ and then viewing the **tidy** variable.

**Note**: For some reason, when reading the data back in, the parentheses which enclose the variable names are replaced with periods.  So, *μ(tBodyAccMeanX)* becomes *μ.tBodyAccMeanX.* instead.  No solution for this improper substitution was found prior to the completion of the project.

##### __References__:
###### 1. [*Data Science, Wearable Computing and the Battle for the Throne as World’s Top Sports Brand*](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/)
###### 2. [*Human Activity Recognition Using Smartphones Data Set*](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) 
###### 3. [*Hadley Wickham's paper on Tidy Data*](http://www.jstatsoft.org/v59/i10/paper)
###### 4. [*David's personal course project FAQ*](https://class.coursera.org/getdata-030/forum/thread?thread_id=37)
###### 5. [*Tidy Data and the Assignment*](https://class.coursera.org/getdata-030/forum/thread?thread_id=107)  