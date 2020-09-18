# pollutantmean

library(stringr)

pollutantmean <- function(directory, pollutant, id = 1:332) {

    vals <- c()

    for (i in id) {

        id_ <- str_pad(i, 3, pad = "0")
        filename = paste0(directory, id_, ".csv")
        df <- read.csv(file = filename)

        vals <- c(vals, df[,pollutant])

    }

    meancalc <- mean(vals, na.rm = TRUE)

    return (meancalc)
}


# pollutantmean(
#     directory = "//file/scanner/HStirrat_scanner/specdata/",
#     pollutant = 'nitrate',
#     id = 70:72)

pollutantmean("//file/scanner/HStirrat_scanner/specdata/", "sulfate", 1:10)

pollutantmean("//file/scanner/HStirrat_scanner/specdata/", "nitrate", 70:72)

pollutantmean("//file/scanner/HStirrat_scanner/specdata/", "sulfate", 34)

pollutantmean("//file/scanner/HStirrat_scanner/specdata/", "nitrate")

cc <- complete("//file/scanner/HStirrat_scanner/specdata/", c(6, 10, 20, 34, 100, 200, 310))
print(cc$nobs)

cc <- complete("//file/scanner/HStirrat_scanner/specdata/", 54)
print(cc$nobs)

RNGversion("3.5.1")  
set.seed(42)
cc <- complete("//file/scanner/HStirrat_scanner/specdata/", 332:1)
use <- sample(332, 10)
print(cc[use, "nobs"])

cr <- corr("//file/scanner/HStirrat_scanner/specdata/")                
cr <- sort(cr)   
RNGversion("3.5.1")
set.seed(868)                
out <- round(cr[sample(length(cr), 5)], 4)
print(out)

cr <- corr("//file/scanner/HStirrat_scanner/specdata/", 129)                
cr <- sort(cr)                
n <- length(cr)    
RNGversion("3.5.1")
set.seed(197)                
out <- c(n, round(cr[sample(n, 5)], 4))
print(out)

cr <- corr("//file/scanner/HStirrat_scanner/specdata/", 2000)                
n <- length(cr)                
cr <- corr("//file/scanner/HStirrat_scanner/specdata/", 1000)                
cr <- sort(cr)
print(c(n, round(cr, 4)))