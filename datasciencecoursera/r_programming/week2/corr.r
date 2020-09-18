
corr <- function(directory, threshold = 0) {

    correlations_ <- c()

    counts_of_complete <- complete(
        directory = "//file/scanner/HStirrat_scanner/specdata/")

    numbers_over_threshold <- counts_of_complete %>%
        filter(
            nobs >= threshold)

    for (i in numbers_over_threshold$id) {

        id_ <- str_pad(i, 3, pad = "0")
        filename = paste0(directory, id_, ".csv")
        df <- read.csv(file = filename)

        #correlations_ <- c(correlations_, cor(x = df$sulfate, y = df$nitrate, use = 'complete.obs'))
        correlations_ <- c(correlations_, cor(x = df$sulfate, y = df$nitrate, use = 'pairwise.complete.obs'))
    }

    return(correlations_)


}


cr <- corr(
    directory = "//file/scanner/HStirrat_scanner/specdata/",
    threshold = 150)