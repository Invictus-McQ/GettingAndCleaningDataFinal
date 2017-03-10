##Assignment Requirements:
## Create one R script called run_analysis.R that does the following:
### 1. Merges the training and the test sets to create one data set.
### 2. Extracts only the measurements on the mean and standard deviation for each measurement.
### 3. Uses descriptive activity names to name the activities in the data set
### 4. Appropriately labels the data set with descriptive activity names.
### 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Part 1
##Load packages and setwd
if (!require("data.table")) {
  install.packages("data.table")
}
if (!require("reshape2")) {
  install.packages("reshape2")
}
if (!require("plyr")) {
  install.packages("plyr")
}
require("data.table")
require("reshape2")
require("plyr")

setwd("~")

#Part 2 
###Files and Directories, Load raw data
uci_dir <- "./UCI HAR Dataset"
x_train_fil <- paste(uci_dir, "/train/X_train.txt", sep = "")
y_train_fil <- paste(uci_dir, "/train/y_train.txt", sep = "")
x_test_fil  <- paste(uci_dir, "/test/X_test.txt", sep = "")
y_test_fil  <- paste(uci_dir, "/test/y_test.txt", sep = "")
feat_fil <- paste(uci_dir, "/features.txt", sep = "")
acty_labels_fil <- paste(uci_dir, "/activity_labels.txt", sep = "")
subj_train_fil <- paste(uci_dir, "/train/subject_train.txt", sep = "")
subj_test_fil <- paste(uci_dir, "/test/subject_test.txt", sep = "")
#### data column names
feat <- read.table(feat_fil, colClasses = c("character"))
####activity labels
acty_lab <- read.table(acty_labels_fil, col.names = c("ActivityId", "Activity"))
####X_test & y_test data
x_test <- read.table(x_test_fil)
y_test <- read.table(y_test_fil)
subj_test <- read.table(subj_test_fil)
#### X_train & y_train data
x_train <- read.table(x_train_fil)
y_train <- read.table(y_train_fil)
subj_train <- read.table(subj_train_fil)
#Part 3
### 1. "Merge the training and the test sets to create one data set."
#### Binding data by columns
test_data <- cbind(as.data.table(subj_test), y_test, x_test)
train_sens_data <- cbind(cbind(x_train, subj_train), y_train)
test_sens_data <- cbind(cbind(x_test, subj_test), y_test)
#### Binding data by rows
sens_data <- rbind(train_sens_data, test_sens_data)
#### Label columns
sens_labels <- rbind(rbind(feat, c(562, "Subject")), c(563, "ActivityId"))[,2]
names(sens_data) <- sens_labels
###
### 2. "Extract only the measurements on the mean and standard deviation for each measurement."
tidy_data <- sens_data[,grepl("mean|std|Subject|ActivityId", names(sens_data))]
###
###  3. "Use descriptive activity names to name the activities in the data set"
tidy_data <- join(tidy_data, acty_lab, by = "ActivityId", match = "first")
tidy_data <- tidy_data[,-1]
###
### 4. "Appropriately label the data set with descriptive names."
#### Cleanup the column names
names(tidy_data) <- gsub('\\(|\\)',"",names(tidy_data), perl = TRUE) #Remove the parentheses
names(tidy_data) <- make.names(names(tidy_data))
names(tidy_data) <- gsub('Acc',"Acceleration",names(tidy_data))
names(tidy_data) <- gsub('GyroJerk',"AngularAcceleration",names(tidy_data))
names(tidy_data) <- gsub('Gyro',"AngularSpeed",names(tidy_data))
names(tidy_data) <- gsub('Mag',"Magnitude",names(tidy_data))
names(tidy_data) <- gsub('^t',"TimeDomain.",names(tidy_data))
names(tidy_data) <- gsub('^f',"FrequencyDomain.",names(tidy_data))
names(tidy_data) <- gsub('\\.mean',".Mean",names(tidy_data))
names(tidy_data) <- gsub('\\.std',".StandardDeviation",names(tidy_data))
names(tidy_data) <- gsub('Freq\\.',"Frequency.",names(tidy_data))
names(tidy_data) <- gsub('Freq$',"Frequency",names(tidy_data))
###
### 5. "Create a second, independent tidy data set with the average of each variable for each activity and each subject."
tidy_set_2 = ddply(tidy_data, c("Subject","Activity"), numcolwise(mean))

## Part 4 Output data to .txt files
write.table(tidy_data, file = "tidy_set_1.txt")
write.csv(tidy_data, file = "tidy_set_1.csv")
write.table(tidy_set_2, file = "tidy_set_2.txt")
write.csv(tidy_set_2, file = "tidy_set_2.csv")


## Project submission 
write.table(tidy_set_2, file = "tidy_set_2_row_names_false.txt", row.name=FALSE)

##Extract the variable names
DataCols <- colnames(tidy_data)
write.table(DataCols, file = "tidy_data_column_names.txt")
write.csv(DataCols, file = "tidy_data_column_names.csv")
