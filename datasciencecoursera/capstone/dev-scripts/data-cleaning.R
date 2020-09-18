library(readr)
library(dplyr)
library(stringi)
library(quanteda)
library(tidyr)
library(stringr)

base_dir <- "C:/Users/hls/code/datasciencecoursera/capstone/"

# combine data into one df for cleaning purposes

dat_twitter <- data.frame(
    Text = read_lines(paste0(base_dir, "/data/en_US.twitter.txt")),
    Source = "twitter")
dat_blogs <- data.frame(
    Text = read_lines(paste0(base_dir, "/data/en_US.blogs.txt")),
    Source = "blogs")
dat_news <- data.frame(
    Text = read_lines(paste0(base_dir, "/data/en_US.news.txt")),
    Source = "news")

df <- bind_rows(dat_twitter, dat_blogs, dat_news) %>%
    # convert all to lowercase
    mutate(Text = tolower(Text)) %>%

    # convert non-ascii chr
    mutate(Text = stri_trans_general(Text, "latin-ascii")) %>%

    # remove URLs
    mutate(Text = gsub("\\s?(http)\\S*\\s?", " ", Text, ignore.case = TRUE)) %>%

    # remove .com (sometimes no URL is given)
    mutate(Text = gsub("\\s?\\S*(.com)\\S*\\s?", " ", Text, ignore.case = TRUE)) %>%

    # remove bit.ly URLs
    mutate(Text = gsub("\\s?\\S*(bit.ly)\\S*\\s?", " ", Text, ignore.case = TRUE)) %>%

    # remove extra whitespace
    mutate(Text = gsub("\\s+", " ", Text)) 

# just so i don't have to process again...
write.csv(df, paste0(base_dir, "data/processed-data.csv"), row.names = FALSE)
 
rm(dat_twitter, dat_blogs, dat_news)

# https://www.r-bloggers.com/advancing-text-mining-with-r-and-quanteda/

# subset data for testing
test_df <- test[1:1000000,]

# create corpus
test_corpus <- corpus(test_df, text_field = 'Text')

# create tokens
tokens_ <- tokens(test_corpus,
    remove_numbers = TRUE,
    remove_punct = TRUE,
    remove_symbols = TRUE,
    remove_url = TRUE,
    what = "word",
    split_hyphens = TRUE,
    include_docvars = TRUE)

# https://tutorials.quanteda.io/basic-operations/tokens/tokens_ngrams/



# here we generate ngrams (length 2:3), their associated document-frequency
# matrix (dfm), and summarise them. Look at Markov chain... really just bigrams
# and trigrams
get_tail <- function(x) {

    # get number of words in ngram
    num_words <- length(x)
    
    # return the final word (the predicted word)
    return(paste(x[[num_words]], collapse = " "))
}

get_head <- function(x) {

        # get number of words in ngram
    num_words <- length(x)

    # every word but the last is the head--get number of head words
    num_heads <- num_words - 1

    # instantiate vector of head words
    this_head <- c()

    # gather all head words
    for (i in 1:num_heads) {
        this_head <- c(this_head, x[[i]])
    }

    return(paste(this_head, collapse = " "))
}

if (exists('feature_count_list')) rm(feature_count_list)
feature_count_list <- list()

if (exists('dfm_summary')) rm(dfm_summary)

for (i in 2:5) {

    # generate ngrams of length i
    these_ngrams <- tokens_ngrams(tokens_, i)

    # construct dfm
    this_dfm <- dfm(these_ngrams, tolower=TRUE, stem=TRUE)

    # trim dfm by removing ngrams appearing fewer than 3 times
    this_dfm_trimmed <- dfm_trim(this_dfm,
        min_termfreq = 3,
        termfreq_type = "count")

    # # append dfm to dfm_list
    # dfm_list[[i]] <- this_dfm_trimmed

    # get ngram counts
    ngrams <- topfeatures(this_dfm_trimmed, length(this_dfm_trimmed))

    # split ngrams up into words
    ngrams_split <- str_split(names(ngrams), "_")

    # get heads
    my_heads <- unlist(lapply(ngrams_split, get_head))
    
    # get tails
    my_tails <- unlist(lapply(ngrams_split, get_tail))

    # create df of heads, tails and counts
    ngrams_split_df <- data.frame(
        Head = my_heads,
        Tail = my_tails,
        Count = ngrams,
        Length = i,
        check.names = FALSE)

    # append to master dataframe
    if (!exists("ngrams_reference")) {
        ngrams_reference <- ngrams_split_df
    } else {
        ngrams_reference <- bind_rows(ngrams_reference, ngrams_split_df)
    }

    # construct summary dataframe listing the top ten ngrams for length i
    this_summary_df <- data.frame(
        ngram = names(topfeatures(this_dfm_trimmed, 10)),
        count = topfeatures(this_dfm_trimmed, 10),
        length = i)
    
    # append summary to single df
    if (!exists('dfm_summary')) {
        dfm_summary <- this_summary_df
    } else {
        dfm_summary <- bind_rows(dfm_summary, this_summary_df)
    }
}

# write so we don't have to do this again
write.csv(ngrams_reference, paste0(base_dir, "data/ngrams-reference.csv"), row.names = FALSE)


library(stringr)
library(dplyr)
base_dir <- "C:/Users/hls/code/datasciencecoursera/capstone/"
ngrams_reference <- read.csv(paste0(base_dir, "data/ngrams-reference.csv"))

# prepare input for prediction
prepare_input <- function(input) {

    input <- tolower(input)
    
    # split by spaces into constituent words
    split_input <- str_split(input, " ")

    # get number of words in input
    num_words <- length(split_input[[1]])

    # get total string
    complete_input <- paste(unlist(split_input),collapse = " ")

    # return list of outputs
    return(list(
        complete_input = complete_input,
        split_input = split_input,
        num_words = num_words)
    )

}


# predict
get_hits <- function(input) {

    hits_df <- ngrams_reference %>%
        filter(Head == input$complete_input)

    # instantiate vector of hits to return
    hits_for_return <- c()

    # check for complete match first, returning top 5 matches
    if (nrow(hits_df) > 0) {

        hits_df <- hits_df %>%
            arrange(desc(Count))

        # get predicted word(s)
        hits_vector <- hits_df$Tail

        hits_for_return <- c(hits_for_return, hits_vector)

        # if we have five matches, return
        if (length(hits_for_return) > 4) {
            return(hits_for_return[1:5])
        } 

    } 
    # if we have got to this point, we haven't got five matches! so let's check
    # shorter ngrams

    # get first word to construct ngram out of--start from 2 because the first
    # attempt starts from 1
    first_word_num <- 2

    # repeat until we have five hits
    while(nrow(hits_df) < 5) {

        # get all word indices except for first word
        word_indices <- first_word_num:input$num_words

        # instantiate word string
        words <- c()

        # get all words
        for (word in word_indices) {
            words <- c(words, input$split_input[[1]][[word]])
        }

        # collapse into single string
        words <- paste(words, collapse = " ")

        # look for matches
        hits_df <- ngrams_reference %>%
            filter(Head == words)

        # return hits if there are any
        if (nrow(hits_df) > 0) {

            hits_df <- hits_df %>%
                arrange(desc(Count))

            # get predicted word(s)
            hits_vector <- hits_df$Tail

            # concatenate these onto original hits
            hits_for_return <- c(hits_for_return, hits_vector)

            # remove duplicates
            hits_for_return <- hits_for_return[!duplicated(hits_for_return)]

            if (length(hits_for_return) > 4) {
                return(hits_for_return[1:5])
            } 

        }

        # if we've tried all available ngrams, return (otherwise our while
        # loop will keep running!)
        if (first_word_num == 4) {
            return(hits_for_return)
        }

        # otherwise, increment to start looking at next word and repeat
        # (i.e., look for a shorter ngram)
        first_word_num <- first_word_num + 1

    }
}


predict_word <- function(provided_string) {
    cleaned_input <- prepare_input(provided_string)
    get_hits(cleaned_input)
}


predict_word("hello how are")
predict_word("thank you so much")



# ggplot(dfm_summary, aes(x = ngram, y = count)) +
#     geom_col() +
#     coord_flip() +
#     facet_wrap(~ length, scales = "free")



# topfeatures(all_ngrams[[1]])

#  textstat_collocations(toks_news_cap, min_count = 10, tolower = FALSE)

# tstat_col_cap <- textstat_collocations(tokens_, min_count = 10, tolower = FALSE)

# head(ngrams[[6]], 30)
# tail(ngrams[[6]], 30)

# # should actually keep stopwords
# mydfm <- dfm(ngrams,
#     tolower = TRUE,
#     stem = TRUE)

# head(dfm_sort(mydfm, decreasing = TRUE, margin = "both"),
#      n = 10,
#      nf = 10)

# topfeatures(mydfm, n = 10)



# # mydfm <- dfm(ngrams,
# #     tolower = TRUE,
# #     stem = TRUE,
# #     remove = stopwords("english"))


# library(stringr)

# test <- dfm_list[[2]]@Dimnames$features[1:10]

# bigram_split <- str_split(dfm_list[[2]]@Dimnames$features, "_")

# bigram <- 

# test <- topfeatures(dfm_list[[2]], length(dfm_list[[2]]))

# library(tidyr)
# t2 <- data.frame(
#     bigram = names(test),
#     count = test) %>%
#     separate(
#         col = bigram,
#         into = c("Lead", "Trail"),
#         sep = "_" )