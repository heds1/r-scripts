setwd("//file/scanner/HStirrat_scanner/r_prog_wk4")
library(tidyverse)

df <- read.csv('outcome-of-care-measures.csv', colClasses = 'character')
df$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack <- as.numeric(df$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack)
df$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure <- as.numeric(df$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure)
df$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia <- as.numeric(df$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia)

best <- function(state, outcome) {

    if (!(state %in% df$State)) {
        stop('invalid state')
    }

    df <- df %>% 
        filter(
            State == state)

    if (outcome == 'heart attack') {
        outcome_measure <- 'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack'
        
    } else if (outcome == 'heart failure') {
        outcome_measure <- 'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure'
        
    } else if (outcome == 'pneumonia') {
        outcome_measure <- 'Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia'
        
    } else {
        stop('invalid outcome')
    }

    outcome_measure <- enquo(outcome_measure)

    df <- df %>%
        select(
            Hospital.Name, 
            !! outcome_measure)

    my_max <- min(df[,2], na.rm = TRUE)

    my_max_index <- which(df[, 2] == my_max)

    df <- df[my_max_index, ]

    df <- df %>%
        arrange(Hospital.Name)

    return(df$Hospital.Name[1])

}
# best('TX', 'heart attack')

# best('TX', 'heart failure')

# best('MD', 'heart attack')

# best('MD', 'pneumonia')

# best('BB', 'heart attack')

# best("NY", "hert attack") 


rankhospital <- function(state, outcome, num = 'best') {

    
    if (!(state %in% df$State)) {
        stop('invalid state')
    }

    df <- df %>% 
        filter(
            State == state)

    if (outcome == 'heart attack') {
        outcome_measure <- 'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack'
        
    } else if (outcome == 'heart failure') {
        outcome_measure <- 'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure'
        
    } else if (outcome == 'pneumonia') {
        outcome_measure <- 'Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia'
        
    } else {
        stop('invalid outcome')
    }

    outcome_measure <- sym(outcome_measure)

    df <- df %>%
        select(
            Hospital.Name, 
            !! outcome_measure)

    if (num == 'best') {
        df <- df %>%
            arrange(
                !! outcome_measure, Hospital.Name)
        df <- df[1,1]

    } else if (num == 'worst') {

        df <- df %>%
            drop_na() %>%
            arrange(desc(!! outcome_measure))
        df <- df[1,1]

    } else if (class(num) == 'numeric') {
        df <- df %>%
            arrange(
                !! outcome_measure, Hospital.Name) %>%
            slice(num)
        df <- df[1,1]
    }


    return(df)


}

#test <- rankhospital('TX', 'heart failure')
#rankhospital('TX', 'heart failure', 5)
rankhospital('TX', 'heart failure', 'worst')
rankhospital('TX', 'heart failure', 4)
rankhospital('MD', 'heart attack', 'worst')
rankhospital('MN', 'heart attack', 5000)





# my_sym <- 'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure'
# my_sym <- sym(my_sym)
# test %>% arrange(!! my_sym)




# my_var <- 'mpg'
# my_var <- enquo(my_var)
# mtcars %>%
#     arrange(!!my_var)

# my_var <- 'mpg'
# my_var <- sym(my_var)
# mtcars %>%
#     arrange(!!my_var) %>%
#     head()

# #        mpg cyl disp  hp drat    wt  qsec vs am gear carb
# # 1 10.4   8  472 205 2.93 5.250 17.98  0  0    3    4
# # 2 10.4   8  460 215 3.00 5.424 17.82  0  0    3    4
# # 3 13.3   8  350 245 3.73 3.840 15.41  0  0    3    4
# # 4 14.3   8  360 245 3.21 3.570 15.84  0  0    3    4
# # 5 14.7   8  440 230 3.23 5.345 17.42  0  0    3    4
# # 6 15.0   8  301 335 3.54 3.570 14.60  0  1    5    8