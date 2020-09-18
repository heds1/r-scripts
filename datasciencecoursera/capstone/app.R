library(shiny)
library(dplyr)
library(stringr)

# check whether this is local dev or production, set directories appropriately
base_dir <- ifelse(Sys.getenv("SHINY_DEV") == "True",
	"C:/Users/hls/code/datasciencecoursera/capstone/data/",
	"")

ngrams_reference <- read.csv(paste0(base_dir, "ngrams-reference.csv"))

# prepare input for prediction
prepare_input <- function(input) {

    input <- tolower(input)
    
    # split by spaces into constituent words
    split_input <- str_split(input, " ")

    # remove trailing or leading whitespace
    split_input[[1]] <- split_input[[1]][sapply(split_input[[1]], nchar) != 0]

    # get number of words in input
    num_words <- length(split_input[[1]])

    # trim input if more than 4 words
    if (num_words > 4) {
        split_input <- split_input[[1]][(num_words-3):num_words]
    }

    # get total string
    complete_input <- paste(unlist(split_input),collapse = " ")

    # return list of outputs
    return(list(
        complete_input = complete_input,
        split_input = split_input,
        num_words = num_words)
    )
}

# if there's no hits, just add the most common words
most_common <- ngrams_reference %>%
    arrange(desc(Count)) %>%
    filter(!duplicated(Tail)) %>%
    slice(1:5)

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

    # if we only have one word, then we've gone as far as we can
    if (input$num_words == 1) {

        # add most common to any hits so far
        hits_for_return <- c(hits_for_return, most_common$Tail)

        # remove duplicates
        hits_for_return <- hits_for_return[!duplicated(hits_for_return)]

        return(hits_for_return[1:5])

    }

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

            # add most common to any hits so far
            hits_for_return <- c(hits_for_return, most_common$Tail)

            # remove duplicates
            hits_for_return <- hits_for_return[!duplicated(hits_for_return)]

            return(hits_for_return[1:5])
        }

        # otherwise, increment to start looking at next word and repeat
        # (i.e., look for a shorter ngram)
        first_word_num <- first_word_num + 1

        # first just check if we have extra words to use...
        if (first_word_num > input$num_words) {
             # add most common to any hits so far
            hits_for_return <- c(hits_for_return, most_common$Tail)

            # remove duplicates
            hits_for_return <- hits_for_return[!duplicated(hits_for_return)]

            return(hits_for_return[1:5])
        }

    }
}

ui <- {
    tagList(
        includeCSS(paste0(base_dir, "style.css")),
        fluidPage(
            fluidRow(
                div(class = "col-sm-12",
                    tags$form(class = "well",
                        tabsetPanel(id = "home",
                            tabPanel(value = "intro",
                                h3("Word predictor"),
                                h3("Word predictor"),
                                hr(),
                                p("This app uses a simple text model to predict the next word in a provided sentence fragment."),
                                p("Simply type in the beginning of a sentence, and click the predict button to generate your prediction."),
                                div(
                                    p(style = "display:inline;", "Want to learn more? Check out the "),
                                    actionLink("go_to_documentation", "documentation.")
                                )
                            ),
                            tabPanel(value = "about",
                                h3("Documentation"),
                                h3("Documentation"),
                                div(
                                    p(style="display:inline", "This R Shiny app was created as a submission for the final project in the Johns Hopkins University "),
                                    a(href="https://www.coursera.org/specializations/jhu-data-science", "Data Science Specialization"),
                                    p(style="display:inline", " certificate.")
                                ),
                                hr(),
                                div(style="margin-bottom: 10px;",
                                    p(style="display:inline", "The data feeding into the prediction algorithm were sourced from Twitter, news websites and blog websites, and are available
                                    as a compressed file "),
                                    a(href="https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip", "here."),
                                    p(style="display:inline", "All source code for this application, including data processing steps, can be found on the author's "),
                                    a(href="https://github.com/heds1/datasciencecoursera/tree/master/capstone", "Github page.")
                                ),
                                div(
                                    p("The word prediction algorithm itself is remarkably simple. It utilises a dictionary of n-grams
                                    (of lengths 2 to 5) to predict the next word given an input of up to four words. Firstly, an exact match
                                    is looked for in the processed training dataset dictionary. If any matches are found, the predicted word 
                                    is directly based on the dictionary's actual next word for the given n-gram. Matches are ranked by simple
                                    frequency counts in the training dataset, smoothed with add-one smoothing."),
                                    p("If less than five matches are found, the length of the n-gram is reduced by one, and the dictionary is
                                    queried again. The same process is repeated until five matches have been found, or the entire dictionary has
                                    been traversed."),
                                    p('To summarise, the algorithm considers two factors: higher-order n-grams are weighted more heavily than
                                    lower-order n-grams, and higher-frequency matches are weighted more heavily than lower-frequency matches.')
                                ),
                                
                                actionLink("go_to_intro", "Go back home.")
                            )
                        )
                        
                    ),
                    tags$form(class = "well",
                        textInput("input_text",
                            label = NULL,
                            placeholder = "Enter your text here"),
                        actionButton('predict',
                            "Predict!"),
                        br(),
                        br(),
                        verbatimTextOutput("output_text")
                    )
                )
            )
        )
    )
}

server <- function(input, output, session) {

    # go to documentation panel
    observeEvent(input$go_to_documentation, {
        updateTabsetPanel(session, inputId = "home", selected = "about")
    })

    # go to home panel
    observeEvent(input$go_to_intro, {
        updateTabsetPanel(session, inputId = "home", selected = "intro")
    })

    predicted_text <- eventReactive(input$predict, {

        prepare_input(input$input_text)

    })

    output$output_text <- renderText({

        cleaned_input <- prepare_input(predicted_text())
        hits <-get_hits(cleaned_input)
        hits[1]
    })



}

shinyApp(ui, server)