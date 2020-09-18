# complete.R


library(stringr)

complete <- function(directory, id = 1:332) {

    #mydf <- data.frame("id", "nobs")

    idz <- c()
    nobz <- c()

    for (i in id) {

        #print(i)

        id_ <- str_pad(i, 3, pad = "0")
        filename = paste0(directory, id_, ".csv")
        df <- read.csv(file = filename)

        # get index of non-NA sulfates and nitrates
        sulfates <- which(!is.na(df$sulfate))
        nitrates <- which(!is.na(df$nitrate))

        # get count of matches
        my_count <- min(
            length(sulfates %in% nitrates),
            length(nitrates %in% sulfates))

        idz <- c(idz, i)
        nobz <- c(nobz, my_count)

    }

    return(data.frame(id = idz, nobs = nobz))

}

# complete(
#     directory = "//file/scanner/HStirrat_scanner/specdata/",
#     id = 1)

complete(
    directory = "//file/scanner/HStirrat_scanner/specdata/",
    id = c(2, 4, 8, 10, 12))