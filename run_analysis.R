library(dplyr)

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

# get the names for excluding duplicates
names <- colnames(all_data_ordered)

# Now we can remove the duplicate column names
all_data_ordered  <- all_data_ordered[, !duplicated(names)]

# refresh this variable, since the column names have changed
names <- colnames(all_data_ordered)

# This is a check for no duplicates in our columns of interest
# need to have a better name for this
selected_columns  <- grep("(mean|std)", names)

# and the test
length(names[selected_columns]) == length(unique(names)[selected_columns])

# Now select the columns of interest and filter again to exclude Freq
# Don't know how to make one grep statement to handle them all