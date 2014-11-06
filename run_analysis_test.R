#
# Tests for Getting and Cleaning Data / Course Project
#

# Source the implementation
source("run_analysis.R")

# Contain tests in an anonymous function to avoid polluting the global environment
(function() {
  
  # Runs the specified test function and prints out the result
  run_test <- function(test) {
    result <- test()  
    
    if(identical(result$expected, result$observed)) {
      print(paste("PASS", result$test, collapse=" "))
    } else {
      print(paste("FAIL", result$test, collapse=" "))
      print(result[c("expected", "observed")])
    }
    
  }
  
  datadir <- "UCI HAR Dataset"
  test_set <- read_set(datadir, "test")
  train_set <- read_set(datadir, "train")
  merged_set <- merge_sets(list(train_set, test_set))
  
  # Define tests
  tests <- c(
    function () {
      list(
        test = "test set has 2947 rows",
        expected = 2947L,
        observed = nrow(test_set)
      )
    },
    function () {
      list(
        test = "training set has 7352 rows",
        expected = 7352L,
        observed = nrow(train_set)
      )
    },
    function () {
      list(
        test = "merged set has 2947 + 7352 = 10299 rows",
        expected = 10299L,
        observed = nrow(merged_set)
      )
    },
    function () {
      list(
        test = "test set has 563 columns",
        expected = 563L,
        observed = ncol(test_set)
      )
    },
    function () {
      list(
        test = "test set has a factor column called activity",
        expected = "factor",
        observed = class(test_set$activity)
      )
    },
    function () {
      list(
        test = "test set has a numeric column called subject_id",
        expected = "numeric",
        observed = class(test_set$subject_id)
      )
    },
    function () {
      list(
        test = "training set and test set have identical column names",
        expected = names(test_set),
        observed = names(train_set)
      )
    },
    function () {
      list(
        test = "merged set and test set have identical column names",
        expected = names(test_set),
        observed = names(merged_set)
      )
    }
  )
  
  # Run tests
  lapply(tests, run_test)
  
})()
