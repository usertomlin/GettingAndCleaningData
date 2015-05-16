On this course project
==============

a. How to run the script 
--------------

1. Set the working directory to some directory like D:/Online Courses/Data Science/UCI HAR Dataset. For example, execute setwd("D:/Online Courses/Data Science/UCI HAR Dataset")

2. Run the R file with a line of script like source('D:/.../run_analysis.R')

3. The tidy data set created in step 5 of the instructions is subsequently created in the working directory, which is named "tidyDatasetToUpload.txt".


b. How the script works
--------------

See the scripts in run_analysis.R and follow the comments line by line. In short:

1. Temporary data frames are read from "X_test.txt", "y_train.txt", "features.txt", ... text files. 

2. The "selectFeatures" selects features for measurement from the 561 features. 

3. A temporary data frame "testFrame" is created with rbind and cbind commands, in which the rows are the training and the test examples, the last two columns are about the examples' activity labels and subject labels respectively, and other columns are features for measurement which are about mean and standard deviation. 

4. Select rows for different activities and subjects respectively, compute the means of the rows with the "apply(correspondingRows, 2, mean);" command, and finally create a tidy dataset to upload. 


c. A code book describing the variables
--------------

1. The first column: "activitiesAndsubjects":
The first 6 rows are the six activity labels: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
The remaining 6 rows are the 30 subject labels: 1, 2, ..., 30.

2. The remaining 79 columns:  
The original selected features for measurement, or the fearures with "mean" or "std" substrings. The feature names and descriptions of them are identical to those in the "features.txt"

