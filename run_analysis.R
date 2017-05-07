## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

install.packages("data.table")
install.packages("reshape2")

require("data.table");require("reshape2")


#Load activity labels
#Indicate the specific setwd("~/DATA SCIENCE/CURSO3 Getting and Cleaning Data/
#Semana4/data/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset")
act_labels <- read.table("activity_labels.txt")[,2]

# Load the data column names
features <- read.table("features.txt")[,2]

# Extract only the measurements on the mean and standard desviation for each measurement
extr_features <- grepl("mean|std", features) #it's converted a logical vector

# Load and process x_test and y_test data
x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subj_test <- read.table("./test/subject_test.txt")

names(x_test) = features # to add the functional names of variables. 
                         #It matches into features and x_test files.

# Extract only the measurements on the mean and standard desviation for each measurement.
# in the test data "x_test" 
x_test = x_test[, extr_features]

# Load activity labels
y_test[,2] = act_labels[y_test[,1]]
names(y_test) = c("ID_activity", "Activity")
names(subj_test) = "subject"

#Associate test data with subject id
test_data <- cbind(as.data.table(subj_test), y_test, x_test)

# Load training data
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subj_train <- read.table("./train/subject_train.txt")
#assignning the names of features to training data
names(x_train) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
x_train = x_train[ , extr_features]

#Load activity labels
y_train[,2] = act_labels[y_train[,1]]
names(y_train) = c("ID_activity", "Activity")
names(subj_train) = "subject"

#Associate training data with subject id
train_data <- cbind(as.data.table(subj_train), y_train, x_train)

# Merge training data and test data
dataset <-  rbind(test_data, train_data)

id_label <- c("subject", "ID_activity", "Activity")
data_label = setdiff(colnames(dataset), id_label)

melt_dataset= melt(dataset, id = id_label, measure.vars = data_label)

# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_dataset, subject + Activity ~ variable, mean)

# writing the result of tidy data
write.table(tidy_data, file = "./tidy_data.txt", row.name = FALSE)




