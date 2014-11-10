library(data.table)
library(dplyr)

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

# Returns the specified list of data sets, combined by rows into a single tbl_dt.
merge_sets <- function(set_list) {
  tbl_dt(rbindlist(set_list))
}

# Selects the columns containing the mean and standard deviation for each measurement,
# while retaining the two key columns, activity and subject_id.
select_columns <- function (set) {
  select(
    set,
    grep("activity|subject_id|((mean|std)\\(\\))", names(set))
  )
}

# Returns the average for each variable in the specified set, grouped by the key columns, activity and subject_id
get_averages <- function (set) {
  set %>%
    group_by(activity, subject_id) %>%
    summarise_each(funs(mean))
}

# You should create one R script called run_analysis.R that does the following.
# 1 Merges the training and the test sets to create one data set.
# 2 Extracts only the measurements on the mean and standard deviation for each measurement.
# 3 Uses descriptive activity names to name the activities in the data set
# 4 Appropriately labels the data set with descriptive variable names.
# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
