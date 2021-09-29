# final version 2021-09-29

# load data
# filenames are hardcoded for Windows environment to simplify 

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
data_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
act_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
data_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
act_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
act_lbls <- read.table("./UCI HAR Dataset/activity_labels.txt")

#rename columns for X_test and X_train datasets. This step can be ommited
names(data_test) <- features$V2
names(data_train) <- features$V2
names(subject_test) <- "subject"
names(subject_train) <- "subject"


# add descriptive activity label to activity number for train and test
# add label 'test/train' to identify rows in combined dataset

for (i in 1:nrow(act_test)){
  act_test[i,2] = act_lbls[act_test[i,1],2]
  act_test[i,3] = "test"
}

for (i in 1:nrow(act_train)){
  act_train[i,2] = act_lbls[act_train[i,1],2]
  act_train[i,3] = "train"
}

# add column names to activity sets
names(act_test) <- c("activity","actname","dataset")
names(act_train) <- c("activity","actname","dataset")

#select only mean and stdev columns from X data sets. Looking for "std(" to exclude stdFreq()
col_msd <- grep("mean\\(|std\\(",features$V2)
test  <- cbind(act_test, subject_test, data_test[,col_msd])
train <- cbind(act_train,subject_train, data_train[,col_msd])

final <- rbind(test,train)
for (i in c("activity","actname","dataset","subject")){
  final[,i] <- factor(final[,i])
}

# clean unnecesary dataframes to release memory
rm("subject_train", "data_train","act_train","subject_test","data_test","act_test","features","act_lbls","test","train")

#calculate mean for each activity and each subject
final_agg <- aggregate.data.frame(final[,5:length(final)], list(activity = final$actname, subject =  final$subject), mean)

