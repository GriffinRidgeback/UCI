activity_labels <- read.table("./data/activity_labels.txt", colClasses = "character")
features <-  read.table("./data/features.txt", colClasses = "character")
subject_train <- read.table("./data/train/subject_train.txt")
X_train <- read.table("./data/train/X_train.txt")
y_train <- read.table("./data/train/y_train.txt")
subject_test <- read.table("./data/test/subject_test.txt")
X_test <- read.table("./data/test/X_test.txt")
y_test <- read.table("./data/test/y_test.txt")

train_data  <- cbind(subject_train, y_train)
train_data  <- cbind(train_data, X_train)

test_data  <- cbind(subject_test, y_test)
test_data  <- cbind(test_data, X_test)

all_data  <- rbind(train_data, test_data)

measurement_names <- read.table("./data/features.txt", stringsAsFactors = F)

names(all_data)  <- c("SubjectID", "Activity", measurement_names$V2)

all_data_ordered  <- all_data[with(all_data, order(SubjectID, Activity)), ]
