# Getting and Cleaning Data Course Project
The goal is to prepare tidy data that can be used for later analysis.

## Prerequisites
### R Libraries
* data.table v1.9.4
* dplyr v0.3.0.2

### Source data set
* Download the [source data set]; _Human Activity Recognition Using Smartphones Dataset_, Version 1.0
* Unzip the package contents into this directory, resulting in a subdirectory called `UCI HAR Dataset`

## The source data
The [source data set] (_Human Activity Recognition Using Smartphones Dataset_) contains accelerometer and gyroscope sensor signals collected from experiments where 30 volunteers performed six different activities while wearing a smartphone on the waist.

Full description of the source data is provided with the source data set, including details on feature selection and calculation in `features_info.txt`.

## What the script does
1. Reads and merges the training and the test set to create one data set with descriptive column names and activity labels applied,
2. Extracts only the measurements on the mean and standard deviation for each measurement,
3. Creates another data set with the average of each variable for each activity and each subject; AND
4. Writes the resultant data set into a txt file, `averages.txt`


## The resultant data ('Code Book')
The first row of `averages.txt` is a header with column names. Each subsequent row contains one record of space-separated values.

Each record in the resultant data set represents a summary (average values) of measurements from a specific activity performed by a specific test subject. For example, the average measurements from test subject 1 walking is one record (row) in the file.

Each record contains:

An activity label string (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING).

A numeric subject id (1-30).

Average standard deviation (_std_) and mean (_mean_) for the following 3-axial (X, Y, Z)  gyroscope (_Gyro_) and accelerometer (_Acc_) features in the frequency (_f_) and time (_t_) domains:
- fBodyAcc
- fBodyAccJerk
- fBodyGyro
- tBodyAcc
- tBodyAccJerk
- tBodyGyro
- tBodyGyroJerk
- tGravityAcc

Average standard deviation (_std_) and mean (_mean_) for the following gyroscope (_Gyro_) and accelerometer (_Acc_) magnitude features in the frequency (_f_) and time (_t_) domains:
- fBodyAccMag
- fBodyBodyAccJerkMag
- fBodyBodyGyroJerkMag
- fBodyBodyGyroMag
- tBodyAccJerkMag
- tBodyAccMag
- tBodyGyroJerkMag
- tBodyGyroMag
- tGravityAccMag

`features_info.txt` in the [source data set] describes these features in detail.

### Units and values
As per the source data set,
- accelerometer (_Acc_) feature values are in standard gravity units 'g'
- gyroscope (_Gyro_) feature values are in radians / second
- values are normalized and bounded within [-1,1]

### Column names
- The key (_group-by_) columns are _activity_ and _subject_id_
- Pattern for 3-axial feature column names: `<feature>-<mean() or std()>-<X,Y,Z>`
- Pattern for other feature column names: `<feature>-<mean() or std()>`

#### Examples
The columns containing average data for the 3-axial _fBodyAcc_ feature are:
- fBodyAcc-mean()-X
- fBodyAcc-mean()-Y
- fBodyAcc-mean()-Z
- fBodyAcc-std()-Z
- fBodyAcc-std()-Z
- fBodyAcc-std()-Z

The columns containing average data for the _fBodyAccMag_ feature are:
- fBodyAccMag-mean()
- fBodyAccMag-std()


[source data set]: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "Human Activity Recognition Using Smartphones Dataset"
