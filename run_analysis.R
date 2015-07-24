
# Step 1
# Merges the training and the test sets to create one data set.

test_activities <- read.table("test/y_test.txt", col.names = "activity")
test_subjects <- read.table("test/subject_test.txt", col.names = "subject")
test_features <- read.table("test/X_test.txt")
train_activities <- read.table("train/y_train.txt", col.names = "activity")
train_subjects <- read.table("train/subject_train.txt", col.names = "subject")
train_features <- read.table("train/X_train.txt")

merged_data <- rbind(cbind(test_subjects, test_activities, test_features),
                     cbind(train_subjects, train_activities, train_features))


# Step 2
# Extracts only the measurements on the mean and standard deviation for each
# measurement.

features <- read.table("features.txt", strip.white = TRUE, stringsAsFactors = FALSE)

# subject and label shoulb not be excluded
extraction <- c(TRUE, TRUE, grepl("(mean|std)\\(\\)", features[,2]))

# subject and label should be skipped
names(merged_data)[-1:-2] <- features[,2]

data <- merged_data[, extraction]


# Step 3
# Uses descriptive activity names to name the activities in the data set

labels <- read.table("activity_labels.txt", stringsAsFactors = FALSE)
data$activity <- labels[data$activity, 2]


# Step 4
# Appropriately labels the data set with descriptive variable names

names(data) <- gsub("^t", "time-", names(data))
names(data) <- gsub("^f", "frequency-", names(data))
names(data) <- gsub("BodyBody", "Body", names(data))
names(data) <- gsub("-Body", "-body-", names(data))
names(data) <- gsub("Gravity", "gravity-", names(data))
names(data) <- gsub("Acc", "accelerometer-", names(data))
names(data) <- gsub("Gyro", "gyroscope-", names(data))
names(data) <- gsub("Jerk", "jerk-", names(data))
names(data) <- gsub("Mag", "magnitude-", names(data))
names(data) <- gsub("--", "-", names(data))


# Step 5
# From the data set in step 4, creates a second, independent tidy data set with
# the average of each variable for each activity and each subject.

tidy_data <- aggregate(. ~subject + activity, data, mean)

write.table(tidy_data, file="tidy_data.txt", row.names = FALSE)
