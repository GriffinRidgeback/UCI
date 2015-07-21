library(dplyr)

# 1 - Merges the training and the test sets to create one data set.
activity_labels <- read.table("./data/activity_labels.txt", colClasses = "character")
features <-  read.table("./data/features.txt", colClasses = "character")
subject_train <- read.table("./data/train/subject_train.txt", colClasses = "numeric")
X_train <- read.table("./data/train/X_train.txt", colClasses = "numeric")
y_train <- read.table("./data/train/y_train.txt", colClasses = "numeric")
subject_test <- read.table("./data/test/subject_test.txt", colClasses = "numeric")
X_test <- read.table("./data/test/X_test.txt", colClasses = "numeric")
y_test <- read.table("./data/test/y_test.txt", colClasses = "numeric")
 
train_data  <- cbind(subject_train, y_train)
train_data  <- cbind(train_data, X_train)

test_data  <- cbind(subject_test, y_test)
test_data  <- cbind(test_data, X_test)

all_data  <- rbind(train_data, test_data)

measurement_names <- read.table("./data/features.txt", stringsAsFactors = F)

names(all_data)  <- c("SubjectID", "Activity", measurement_names$V2)

# put the data in order
all_data_ordered  <- all_data[with(all_data, order(SubjectID, Activity)), ]

# 2 - Extracts only the measurements on the mean and standard deviation for each measurement. 
# get the names for excluding duplicates
names <- colnames(all_data_ordered)

# now show that none of the columns of interest are duplicated
selected_columns  <- grep(".*mean\\(.*|.*std\\(.*", names)

# and the test
length(names[selected_columns]) == length(unique(names)[selected_columns])

# Now it has been shown that none of the columns
# of interest are duplicates, so the selected_columns vector
# can be used to subset the full dataset in order to create
# a dataset with only columns containing mean and std
# measurements, which is ready to be relabeled and further reduced.
all_data_ordered  <- all_data_ordered[, c(1:2, selected_columns)]

# 3 - Uses descriptive activity names to name the activities in the data set
for (i in 1:6) {
    all_data_ordered[all_data_ordered$Activity == i, 2]  <- activity_labels$V2[i]
}

# 4 - Appropriately labels the data set with descriptive variable names. 
new_names  <- colnames((all_data_ordered))
new_names  <- gsub("-mean\\(\\)-", "Mean", new_names)
new_names  <- gsub("-mean\\(\\)", "Mean", new_names)
new_names  <- gsub("-std\\(\\)-", "Std", new_names)
new_names  <- gsub("-std\\(\\)", "Std", new_names)
names(all_data_ordered)  <- new_names

# 5 - From the data set in step 4, creates a second, independent tidy data 
# set with the average of each variable for each activity and each subject.
tidy_data <- group_by(all_data_ordered, SubjectID, Activity) %>% summarise_each(funs(mean))