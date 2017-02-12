rm(list = ls())
library(dplyr)

## Isolate the features that have the word "mean" or "std" in them
dataNames <- read.csv("UCI HAR Dataset/features.txt", sep = " ", 
                                  header = FALSE, stringsAsFactors = FALSE)
dataNames <- dataNames$V2
relevantColInd <- grep("mean|std", ignore.case = TRUE, dataNames)


## Associate the acitivity with their labels
activityTable <- read.csv("UCI HAR Dataset/activity_labels.txt", sep = " ", 
                           header = FALSE, stringsAsFactors = TRUE)
colnames(activityTable) <- c("index", "label")
# Sort the levels of the activity
activityTable$label <- with(activityTable, factor(label, levels = label[index]))


## Read test data
testSubjectIDs <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep = " ", 
                            header = FALSE, stringsAsFactors = FALSE)
testData <- read.csv("UCI HAR Dataset/test/X_test.txt", sep = "", 
                                 header = FALSE, colClasses = "numeric")
testActivityIndex <- read.csv("UCI HAR Dataset/test/y_test.txt", sep = " ", 
                               header = FALSE, stringsAsFactors = FALSE)
testActivityLabel <- sapply(testActivityIndex$V1, function(x)
                                activityTable$label[x == activityTable$index])
testData <- testData[, relevantColInd]
colnames(testData) <- dataNames[relevantColInd]
testData <- cbind(subjectID = testSubjectIDs$V1, 
                  activityLabel = testActivityLabel, testData)
rm(list = c("testSubjectIDs", "testActivityIndex", "testActivityLabel"))


## Read training data
trainSubjectIDs <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep = " ", 
                            header = FALSE, stringsAsFactors = FALSE)
trainData <- read.csv("UCI HAR Dataset/train/X_train.txt", sep = "", 
                      header = FALSE, colClasses = "numeric")
trainActivityIndex <- read.csv("UCI HAR Dataset/train/y_train.txt", sep = " ", 
                               header = FALSE, stringsAsFactors = FALSE)
trainActivityLabel <- sapply(trainActivityIndex$V1, function(x)
                            activityTable$label[x == activityTable$index])
trainData <- trainData[, relevantColInd]
colnames(trainData) <- dataNames[relevantColInd]
trainData <- cbind(subjectID = trainSubjectIDs$V1, 
                  activityLabel = trainActivityLabel, trainData)
rm(list = c("trainSubjectIDs", "trainActivityIndex", "trainActivityLabel"))


## Join the training and test data and generate a summary grouped by 
## subjectID/activity
mergedData <- arrange(full_join(testData, trainData), subjectID, 
                                 activityLabel)
summarizedData <- aggregate(mergedData[, 3 : ncol(mergedData)], 
              by = list(mergedData$subjectID, mergedData$activityLabel), 
              FUN = mean)
summarizedData <- rename(summarizedData, subjectID = Group.1, 
                         activityLabel = Group.2)


## Write into .csv file
summarizedDataForWrite <- summarizedData
summarizedDataForWrite[, 3 : ncol(summarizedData)] <- 
    sapply(summarizedData[, 3 : ncol(summarizedData)], 
                                 function(x) sprintf("%.7e", x))
write.table(summarizedDataForWrite, file = "summary.txt", sep = " ", 
            quote = FALSE, row.names = FALSE, col.names = TRUE)