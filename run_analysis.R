#
# LIBRARIES
#
library(data.table)
library(dplyr)

#
# FUNCTIONS
#

#
# read_set
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

#
# merge_sets
#
# Returns the specified list of data sets, combined by rows into a single tbl_dt.
merge_sets <- function(set_list) {
  tbl_dt(rbindlist(set_list))
}

#
# select_columns
#
# Selects the columns containing the mean and standard deviation for each measurement,
# while retaining the two key columns, activity and subject_id.
select_columns <- function (set) {
  select(
    set,
    grep("activity|subject_id|((mean|std)\\(\\))", names(set))
  )
}

#
# get_averages
#
# Returns the average for each variable in the specified set, grouped by the key columns, activity and subject_id
get_averages <- function (set) {
  set %>%
    group_by(activity, subject_id) %>%
    summarise_each(funs(mean))
}

# 
# EXECUTION
#

# From the specified data directory..
datadir <- "UCI HAR Dataset"

# 1) Get the two data sets with descriptive column names and activity labels applied
test_set <- read_set(datadir, "test")
train_set <- read_set(datadir, "train")

# 2) Merge the training and the test sets to create one data set
merged_set <- merge_sets(list(train_set, test_set))

# 3) Extract only the measurements on the mean and standard deviation for each measurement
selected_set <- select_columns(merged_set)

# 4) Create another data set with the average of each variable for each activity and each subject.
average_set <- get_averages(selected_set)

# 5) Write the average data set into a txt file
write.table(average_set, file = "averages.txt", row.names = FALSE)
