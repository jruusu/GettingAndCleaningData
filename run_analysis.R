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
# The keys in the resultant data table are: activity, subject_id
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
    ) %>%
    setkey(activity, subject_id)
}

# Returns the specified list of data sets, combined by rows into a single tbl_dt,
# retaining keys of the first data set in list
merge_sets <- function(set_list) {
  keys <- key(first(set_list))
  tbl_dt(rbindlist(set_list)) %>%
    setkeyv(keys)
}

# 2 Extracts only the measurements on the mean and standard deviation for each measurement,
# while retaining the two key columns, activity and subject_id.
select_columns <- function (set) {
  select(
    set,
    grep("activity|subject_id|((mean|std)\\(\\))", names(set))
  )
}

# 3 Uses descriptive activity names to name the activities in the data set
# 4 Appropriately labels the data set with descriptive variable names. 

# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# Returns the average for each variable in the specified set, grouped by the key columns, activity and subject_id
get_averages <- function (set) {
  set %>%
    group_by(activity, subject_id) %>%
    summarise_each(funs(mean))
}
