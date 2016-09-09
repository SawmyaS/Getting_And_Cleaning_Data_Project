run_analysis <- function(){
  
  #load training data
  subject_train <- read.table("Data/UCI HAR Dataset/train/subject_train.txt")
  X_train <- read.table("Data/UCI HAR Dataset/train/X_train.txt")
  Y_train <- read.table("Data/UCI HAR Dataset/train/Y_train.txt")
  
  #load test data
  subject_test <- read.table("Data/UCI HAR Dataset/test/subject_test.txt")
  X_test <- read.table("Data/UCI HAR Dataset/test/X_test.txt")
  Y_test <- read.table("Data/UCI HAR Dataset/test/Y_test.txt")
  
  #understand the structure of the data
  str(subject_train)
  str(X_train)
  str(Y_train)
  str(subject_test)
  str(X_test)
  str(Y_test)
  
  #1.Merge the training and the test sets to create one data set.
  #combine training and test data set
  subject <- rbind(subject_train,subject_test)
  X <- rbind(X_train,X_test)
  Y <- rbind(Y_train,Y_test)
  
  #assign names to the merged data set
  names(subject) <- c("subject")
  #load features
  features <- read.table("Data/UCI HAR Dataset/features.txt", col.names=c("featureId","featureLabel"))
  names(X) <- features$featureLabel
  names(Y) <- c("activity")
  
  #combine subject, X and Y to create one data set
  data <- cbind(subject, X, Y)
  
  #2.Extract only the measurements on the mean and standard deviation for each measurement.
  #subset Names of Features with mean() or std()
  sub_features <- features$featureLabel[grep("mean\\(\\)|std\\(\\)",features$featureLabel)]
  
  #subset the data by selected subset of names
  sub_names <- c("subject",as.character(sub_features),"activity")
  data <- subset(data,select=sub_names)
  
  #3.Use descriptive activity names to name the activities in the data set
  #load descriptive activity labels
  activity_labels <- read.table("Data/UCI HAR Dataset/activity_labels.txt", col.names=c("activityId", "activityLabel"))
  data$activity <- factor(data$activity,labels=as.character(activity_labels$activityLabel))

  #4.Appropriately label the data set with descriptive variable names.
  #understand the current variable names
  names(data)
  
  #names of features are updated using descriptive names
  names(data)<-gsub("^t", "time", names(data))
  names(data)<-gsub("^f", "frequency", names(data))
  names(data)<-gsub("Acc", "Accelerometer", names(data))
  names(data)<-gsub("Gyro", "Gyroscope", names(data))
  names(data)<-gsub("Mag", "Magnitude", names(data))
  names(data)<-gsub("BodyBody", "Body", names(data))
  
  #5.From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
  library(plyr)
  tidy_data <- aggregate(. ~subject + activity, data, mean)
  tidy_data <- tidy_data[order(tidy_data$subject,tidy_data$activity),]
  write.table(tidy_data, file = "tidydata.txt",row.name=FALSE)

}