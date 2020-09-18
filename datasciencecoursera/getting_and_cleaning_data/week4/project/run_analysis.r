# load dpylr for data work
library(dplyr)

# create temp file
temp <- tempfile()

# download zip file, store in temp
download.file(
    "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
    temp)

# read in features
features <- read.table(unz(temp, 'UCI HAR Dataset/features.txt'))

# read in activity labels
activity_labels <- read.table(unz(temp, 'UCI HAR Dataset/activity_labels.txt'))

# loop over 'test' and 'train' to read in the data and prepare for merging
for (i in c('test', 'train')) {

    # read in data
    assign(
        x = paste0(i, '_set_data'),
        read.table(
            unz(temp, paste0('UCI HAR Dataset/', i, '/X_', i, '.txt'))))

    # read in activity labels, set variable name to 'Activity'
    assign(
        x = paste0(i, '_set_activity_labels'),
        read.table(
            unz(temp, paste0('UCI HAR Dataset/', i, '/y_', i, '.txt')),
            col.names = 'Activity'))

    # read in subjects, set variable name to 'Subject'
    assign(
        x = paste0(i, '_set_subjects'),
        read.table(
            unz(temp, paste0('UCI HAR Dataset/', i, '/subject_', i, '.txt')),
            col.names = 'Subject'))

    # generate vector of data generated in this loop
    this_data <- c(
        paste0(i, '_set_data'),
        paste0(i, '_set_activity_labels'),
        paste0(i, '_set_subjects'))

    # merge dataset, activity labels and subjects
    assign(
        x = paste0(i, '_df'),
        bind_cols(mget(this_data)))
}

# check that the test and training datasets had unique subjects, 30 in total
length(
    sort(
        c(
            setdiff(unique(test_df$Subject), unique(train_df$Subject)),
            setdiff(unique(train_df$Subject), unique(test_df$Subject))))
    ) == 30
# [1] TRUE

# unlink temp file
unlink(temp)


# --- 1. Merge the training and the test sets to create one data set ---

# merge the datasets
df <- bind_rows(test_df,train_df)


# --- 2. Extract only the measurements on the mean and standard deviation for
# each measurement --- 

# link feature names with the dataset (don't overwrite Subject or Activity). I
# have no idea why these need to be coerced to chr, but they do
colnames(df)[1:length(features$V2)] <- as.character(features$V2)

# get vectors containing column indices of mean and sd variables. need to set
# fixed = TRUE to remove meanFreq() variables. I interpret the question to not
# be looking for meanFreq() variables. also need to get the Activity and Subject
# columns.
my_means <- grep('mean()', fixed = TRUE, names(df))
my_sds <- grep('std()', fixed = TRUE, names(df))
my_activity_col <- grep('Activity', names(df))
my_subject_col <- grep('Subject', names(df))
my_cols <- c(my_means, my_sds, my_activity_col, my_subject_col)

# select only those columns relating to mean or sd
df <- df[, my_cols]


# --- 3. Use descriptive activity names to name the activities in the data set ---

# make named vector of activities
activity_vec <- activity_labels$V1
names(activity_vec) <- activity_labels$V2

# match with df to populate Activity variable with descriptive names
df$Activity <- names(activity_vec)[match(df$Activity, activity_vec)]

# convert to lowercase
df$Activity <- tolower(df$Activity)


# --- 4. Appropriately label the data set with descriptive variable names ---

# store variable names in vector
var_names <- names(df)

# change 't' to 'TimeDomain'
var_names <- sub('^t', 'TimeDomain', var_names)

# change 'f' to 'FrequencyDomain'
var_names <- sub('^f', 'FrequencyDomain', var_names)

# change 'BodyAcc' to 'BodyAcceleration'
var_names <- sub('BodyAcc', 'BodyAcceleration', var_names)

# change 'GravityAcc' to 'GravityAcceleration'
var_names <- sub('GravityAcc', 'GravityAcceleration', var_names)

# add 'Mean' to front
var_names[which(grepl('mean', var_names))] <- paste0('Mean', var_names[which(grepl('mean', var_names))])

# remove 'mean'
var_names <- sub('-mean\\(\\)', '', var_names)

# add 'StandardDeviation' to front
var_names[which(grepl('std', var_names))] <- paste0('StandardDeviation', var_names[which(grepl('std', var_names))])

# remove 'std'
var_names <- sub('-std\\(\\)', '', var_names)

# be more specific about x, y and z plantes
var_names <- sub('-X', 'InTheXPlane', var_names)
var_names <- sub('-Y', 'InTheYPlane', var_names)
var_names <- sub('-Z', 'InTheZPlane', var_names)

# change 'Mag' to 'Magnitude'
var_names <- sub('Mag', 'Magnitude', var_names)

colnames(df) <- var_names


# --- 5. From the data set in step 4, create a second, independent tidy data set
# with the average of each variable for each activity and each subject ---
tidy_df <- df %>%
    group_by(Activity,Subject) %>%
    summarise_all(list(mean = mean))

# write table
write.table(tidy_df, row.names=FALSE)