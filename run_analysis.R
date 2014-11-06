# You should create one R script called run_analysis.R that does the following. 
library(data.table)
library(dplyr)

read_file <- function(filename) {
  # TODO: check out fread()
  read.table(filename) %>%
    tbl_dt()
}

# 1 Merges the training and the test sets to create one data set.

#
# Returns the specified data set ("test" or "train") from the specified directory
# as a single data table containing
# - measurements
# - activity labels; and
# - subject identifiers
#
read_set <- function(directory, set) {
  # Read the list of measurement labels corresponding to columns in the data set
  measurement_labels <- read.table(sprintf("%s/features.txt", directory))[,2]
  
  # Set up a lookup table of activity labels (activity_id -> activity)
  activity_labels <- read.table(sprintf("%s/activity_labels.txt", directory)) %>%
    tbl_dt %>%
    setNames(c("activity_id", "activity")) %>%
    setkey(activity_id)

  # Read activity and subject identifiers for this data set
  activity_ids <- read.table(sprintf("%s/%s/y_%s.txt", directory, set, set), colClasses = "numeric")
  subject_ids <- read.table(sprintf("%s/%s/subject_%s.txt", directory, set, set), colClasses = "numeric")
  
  measurements <- read.table(sprintf("%s/%s/X_%s.txt", directory, set, set), colClasses = "numeric") %>%
    setNames(measurement_labels) %>%
    tbl_dt %>%
    mutate(
      activity = activity_labels[activity_ids]$activity,
      subject_id = subject_ids
    )
}

# Returns the specified list of data sets, combined by rows into a single tbl_dt
merge_sets <- function(set_list) {
  tbl_dt(rbindlist(set_list))
}

# 2 Extracts only the measurements on the mean and standard deviation for each measurement. 

#This might work..
# select(s, grep("(mean|std)\\(\\)", feature_names)) %>%

# 3 Uses descriptive activity names to name the activities in the data set
# 4 Appropriately labels the data set with descriptive variable names. 
# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

