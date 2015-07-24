library(dplyr)

# 0 - Download and extract the files
# setwd(".")
# if (!file.exists("getdata_projectfiles_UCI HAR Dataset.zip")) {
#   fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#   download.file(fileUrl, destfile = "./data.zip", method = "curl")
#   unzip("data.zip", exdir = "./data")  # will extract data.zip into folder UCI HAR Dataset
# }

if (!file.exists("./data")) {
    stop("The directory data does not exist in the current directory.")
}

#------------------------------------------------------------------
# 1 - Merges the training and the test sets to create one data set.
#------------------------------------------------------------------
readline(prompt="Step 1 will read in data and perform the merge; press [enter] to continue... ")

# activity lables (WALKING, etc.)
activity_labels <- read.table("./data/activity_labels.txt", colClasses = "character")

# feature labels (tBodyAcc-mean()-X, etc.)
features <-  read.table("./data/features.txt", stringsAsFactors = F, colClasses = "character")

# Subject IDs for the training data
subject_train <- read.table("./data/train/subject_train.txt", colClasses = "numeric")

# Measurement data from the training cycle
X_train <- read.table("./data/train/X_train.txt", colClasses = "numeric")

# Activity IDs for the training data
y_train <- read.table("./data/train/y_train.txt", colClasses = "numeric")

# Subject IDs for the test data
subject_test <- read.table("./data/test/subject_test.txt", colClasses = "numeric")

# Measurement data from the test cycle
X_test <- read.table("./data/test/X_test.txt", colClasses = "numeric")

# Activity IDs for the test data
y_test <- read.table("./data/test/y_test.txt", colClasses = "numeric")
 
readline(prompt="All data files read. Now perform the merge; press [enter] to continue... ")

# perform a column-wise bind of the training subject and activity IDs
train_data  <- cbind(subject_train, y_train)

# perform a column-wise bind of the two columns and the training measurements
train_data  <- cbind(train_data, X_train)

# perform a column-wise bind of the test subject and activity IDs
test_data  <- cbind(subject_test, y_test)

# perform a column-wise bind of the two columns and the testing measurements
test_data  <- cbind(test_data, X_test)

# perform the final merge of the training and test data
all_data  <- rbind(train_data, test_data)

readline(prompt="All data files merged into one dataset. Press [enter] to continue... ")

#--------------------------------------------------------------------------------------------
# 2 - Extracts only the measurements on the mean and standard deviation for each measurement. 
#--------------------------------------------------------------------------------------------
readline(prompt="Step 2 will extract only mean/standard deviation measurements; press [enter] to continue... ")

# set the column headers
names(all_data)  <- c("SubjectID", "Activity", features$V2)

# remove duplicate column names
all_data <- all_data[, !duplicated(colnames(all_data))]

# put the data in order
all_data_ordered  <- all_data[with(all_data, order(SubjectID, Activity)), ]

# extract the column names
names <- colnames(all_data_ordered)

# grep for the columns of interest; selected_columns will contain the 
# indices of the columns which match the regular expressions
selected_columns  <- grep(".*mean\\(.*|.*std\\(.*", names)

# the selected_columns vector can be used to subset the full dataset 
# in order to create a dataset with only columns containing mean and 
# std measurements, which is ready to be relabeled and further reduced.
all_data_ordered  <- all_data_ordered[, c(1:2, selected_columns)]

readline(prompt="Mean/Standard deviation measurements extracted successfully. Press [enter] to continue... ")

#----------------------------------------------------------------------------
# 3 - Uses descriptive activity names to name the activities in the data set.
#----------------------------------------------------------------------------
readline(prompt="Step 3 will appropriately name the activities in the data set; press [enter] to continue... ")

# replace the numerical activity value for all matching with a textual representation
for (i in 1:length(activity_labels$V2)) {
    all_data_ordered[all_data_ordered$Activity == i, 2]  <- activity_labels$V2[i]
}

readline(prompt="Descriptive Activity labels applied to dataset. Press [enter] to continue... ")

#-----------------------------------------------------------------------
# 4 - Appropriately labels the data set with descriptive variable names. 
#-----------------------------------------------------------------------
readline(prompt="Step 4 will appropriately name the columns in the data set; press [enter] to continue... ")

# create a new vector to hold the modified column headers
new_names  <- colnames((all_data_ordered))

# modify headers for mean values
new_names  <- gsub("-mean\\(\\)-", "Mean", new_names)
new_names  <- gsub("-mean\\(\\)", "Mean", new_names)

# modify headers for standard deviation values
new_names  <- gsub("-std\\(\\)-", "Std", new_names)
new_names  <- gsub("-std\\(\\)", "Std", new_names)

# add indicator to show that all values are means
mean_names  <- paste("μ(", new_names[3:length(new_names)], ")", sep = "")

# set the new column headers
names(all_data_ordered)  <- c(new_names[1:2], mean_names)

readline(prompt="Descriptive Variable labels (column headers) applied to dataset. Press [enter] to continue... ")

#--------------------------------------------------------------------------
# 5 - From the data set in step 4, creates a second, independent tidy data.
#--------------------------------------------------------------------------
readline(prompt="Step 5 will create the tidy data; press [enter] to continue... ")

# create tidy dataset with the average of each variable for each activity and each subject.
tidy_data <- group_by(all_data_ordered, SubjectID, Activity) %>% summarise_each(funs(mean))

# write out the tidy data, omitting the row.names
write.table(tidy_data, "./tidy_data.txt", row.names = F)

readline(prompt="Analysis of data completed; tidy data set produced and written to local file system. Press [enter] to exit the script... ")