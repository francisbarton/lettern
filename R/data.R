#' Word length frequencies in English, from Peter Norvig's analysis
#'
#' From Norvig:
#'   "Here is the breakdown of mentions (in millions) by word length
#'   (looking like a Poisson distribution).
#    The average is 4.79 letters per word, and 80% are between 2 and
#    7 letters long."
#'
#' @format A data frame with 23 rows and 3 variables:
#' \describe{
#'   \item{\code{word_length}}{double. Word length.}
#'   \item{\code{count_millions}}{double. Count of words of this length within corpus (in millions).}
#'   \item{\code{percentage}}{double. Percentage of words of this length within corpus.}
#' }
#' @source \url{https://www.norvig.com/mayzner.html}
"word_length_frequencies"


#' Letter counts/frequencies overall
#'
#' DATASET_DESCRIPTION
#'
#' @format A data frame with 26 rows and 3 variables:
#' \describe{
#'   \item{\code{letter}}{character. The 26 letters of the English alphabet (lower case).}
#'   \item{\code{count}}{double. Overall count of this letter within corpus.}
#'   \item{\code{percentage}}{double. Overall percentage of this letter within corpus.}
#' }
#' @source \url{https://www.norvig.com/mayzner.html}
"letter_frequencies_overall"




#' Letter counts/frequencies by position
#'
#' From Norvig: "Now we show the letter frequencies by position within word.
#'   That is, the frequencies for just the first letter in each word, just the
#'   second letter, and so on.
#'   We also show frequencies for positions relative to the end of the word:
#'   "-1" means the last letter, "-2" means the second to last, and so on."
#'
#' @format A data frame with 364 rows and 4 variables:
#' \describe{
#'   \item{\code{position}}{integer. Letter's position within a word.}
#'   \item{\code{letter}}{character. The 26 letters of the English alphabet (lower case).}
#'   \item{\code{count}}{double. Overall count of this letter within corpus, at this position within a word.}
#'   \item{\code{percentage}}{double. Overall percentage of this letter within corpus, at this position within a word.}
#' }
#' @source \url{https://www.norvig.com/mayzner.html}
"letter_frequencies_by_position"



#' Bigram frequencies
#'
#' The count and proportion of all 676 bigrams (pairs of consecutive letters)
#'   within Norvig's corpus.
#'
#' @format A data frame with 676 rows and 4 variables:
#' \describe{
#'   \item{\code{bigram_1}}{character. The first letter of the bigram.}
#'   \item{\code{bigram_2}}{character. The second letter of the bigram.}
#'   \item{\code{count}}{double. Overall count of this bigram within corpus.}
#'   \item{\code{percentage}}{double. Overall percentage of this bigram within corpus.}
#' }
#' @source \url{https://www.norvig.com/mayzner.html}
"bigram_frequencies"
