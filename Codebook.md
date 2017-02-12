---
title: "Course Project for JHU Data Cleaning Course"
author: "Yap Ching Loong Ian"
date: "February 12, 2017"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown
This dataset contains a summary of 86 selected features (containing the term "mean" of "std") that were provided in the original dataset "UCI HAR Dataset". 
For further information about the definition of these features, refer to "features_info.txt" provided in the original data folder. 

The data from both the test and training set was combined and averages of the selected features by subject ID and activity type was calculated and written into a text file "summary.txt". The first 2 columns are the subjectID and activityLabel respectively. Together with the 86 selected features, this gives 88 columns. With 30 subjectIDs and 6 activity types, this gives a total of 30x6=180 rows in the data.

The analysis of the data can be done with the script "run_analysis.R" which should be placed in the same directory as the "UCI HAR Dataset" folder.