

#setwd("D:/Online Courses/Data Science/Getting and Cleaning Data/workspace");
#setwd("D:/Online Courses/Data Science/UCI HAR Dataset");


#read data for training and testing from files
X_test_temp = read.table("test/X_test.txt");
y_test_temp = read.table("test/y_test.txt");
X_train_temp = read.table("train/X_train.txt");
y_train_temp = read.table("train/y_train.txt");
features = read.table("features.txt");

subject_train = read.table("train/subject_train.txt");
subject_test = read.table("test/subject_test.txt");
colnames(subject_train) = c("subject_label")
colnames(subject_test) = c("subject_label");



#set a few variables
numFeatures = nrow(features);
numRows_train = nrow(y_train_temp);
numRows_test = nrow(y_test_temp);

#Select the features and then "Extracts only the measurements on the mean and 
#standard deviation for each measurement." later 
selectFeatures <- function(){
  
  features$V2 = as.character(features$V2)
  for (i in 1:numFeatures) {
    featureString = features[i,2];
    if (length(grep("mean",featureString)) > 0){
    } else if (length(grep("std", featureString)) > 0) {
    } else {
      features[i, 2] = "";
    }
  }
  featuresForMeasurement = features[ features$V2 != "", 2];
}

#get the selected features
featuresForMeasurement = selectFeatures();

#remove unused features based on featuresForMeasurement
colnames(X_train_temp) = features$V2
X_train = X_train_temp[, featuresForMeasurement];
colnames(X_test_temp) = features$V2
X_test = X_test_temp[, featuresForMeasurement];

#create y_test by y_test_temp and activity_labels
#create y_train by y_test_temp and activity_labels
activity_labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING");
y_test = y_test_temp;
y_test_temp[, 1] = as.numeric(y_test_temp[, 1]);
for (i in 1:numRows_test){
  y_test[i, 1] = activity_labels[y_test_temp[i, 1]];
}
colnames(y_test) = c("activity_label");

y_train_temp[, 1] = as.numeric(y_train_temp[, 1]);
y_train = y_train_temp;
for (i in 1:numRows_train){
  y_train[i, 1] = activity_labels[y_train_temp[i, 1]];
}
colnames(y_train) = c("activity_label");



#get a data frame for the test data
testFrame = cbind(X_test, y_test);
testFrame = cbind(testFrame, subject_test)

#get a data frame for the training data
trainFrame = cbind(X_train, y_train);
trainFrame = cbind(trainFrame, subject_train)

#a temporary data frame about detailed information of all traininig and test examples; each row is about one example
tempDataFrame = rbind(trainFrame, testFrame);

# Calculate the number of rows in the tidy dataset to upload
# The rows are for each activity and each subject;
s_train = unique(subject_train[, 1]);
s_test = unique(subject_test[, 1]);
subject_labels = as.character(unique(c(s_train, s_test)));
numRows = length(activity_labels) + length(subject_labels);
activitiesAndsubjects = c(activity_labels, subject_labels);

#In "tidyDatasetToUpload", the first column is about activity and subject names, 
#and the last two columns about activity and subject names respectively do not exist in tidyDatasetToUpload,
#so the final number of columns will be ncol(tempDataFrame) + 1 - 2

#the tidy dataset to be saved to a text file and then uploaded
tidyDatasetToUpload = as.data.frame(matrix(0, ncol = (ncol(tempDataFrame) - 2), nrow = numRows));
itsNCol = ncol(tidyDatasetToUpload);

colnames(tidyDatasetToUpload) = colnames(tempDataFrame)[1:ncol(tidyDatasetToUpload)];


for (i in 1: numRows){
  if (i <= length(activity_labels)){
    activity = activitiesAndsubjects[i];
    correspondingRows = tempDataFrame[tempDataFrame$activity_label == activity, ];
    correspondingRows = correspondingRows[, 1:itsNCol]
    
  } else {
    subject = activitiesAndsubjects[i];
    correspondingRows = tempDataFrame[tempDataFrame$subject_label == subject, ];
    correspondingRows = correspondingRows[, 1:itsNCol];
  }
  meanOfRows = apply(correspondingRows, 2, mean);
  tidyDatasetToUpload[i, ] = meanOfRows;
}

tidyDatasetToUpload = cbind(activitiesAndsubjects, tidyDatasetToUpload);

write.table(tidyDatasetToUpload, file = "tidyDatasetToUpload.txt", row.name=FALSE);