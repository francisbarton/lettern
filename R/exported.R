#' Pull a weighted sample of n letters from the alphabet
#'
#' The `replace` parameter is fixed to TRUE, as this is what makes sense given
#'   the frequency-dependent nature of this particular sampling approach.
#'   This function returns a single letter based on a weighted sampling from all
#'   26 letters, based on their overall frequency in Norvig's corpus.
#'
#' @param n The number of letters to return.
#'
#' @return A vector of lower-case letters.
#' @export
#'
#' @examples sample_letters(3)
sample_letters <- function(n) {
  lettern::letter_frequencies_overall %>%
    dplyr::slice_sample(n = n, weight_by = .data$count, replace = TRUE) %>%
    dplyr::pull(.data$letter)
}

#' Choose a letter based on frequency (or frequency at position n within a word)
#'
#' @param n If n is a non-zero integer between -7 and 7 (position in word, from 1
#'   (first) to 7 (seventh) or from -1 (last) to -7 (seventh from last)), it
#'   returns a single letter based on letter frequencies at that position only.
#'
#' @return A lower-case letter (character string of `nchar` 1) between a and z.
#' @export
#'
#' @examples
#' choose_a_letter(3)
choose_a_letter <- function(n) {
  lettern::letter_frequencies_by_position %>%
    dplyr::filter(.data$position == n) %>%
    dplyr::slice_sample(n = 1, weight_by = .data$count) %>%
    dplyr::pull(.data$letter)
}



#' Build a full sentence of n nonsense "words"
#'
#' @param n The number of words to include in the sentence.
#' @param end The string to end the sentence with. Defaults to a full stop.
#' @param ... A place to pass on parameters such as `cutoff`, which affects
#'   the available frequencies of the bigrams used to build words.
#'
#' @return A single string of n words with an ending character such as a full stop.
#' @export
#'
#' @examples build_a_sentence(6, cutoff = 0.005)
build_a_sentence <- function(n, end = ".", ...) {

  # Create a chance of a random word being sentence-cased
  # (Will happen ~ once every 10 times this function is called)
  w <- sample(10 * n, 1)

  out <- replicate(n, construct_with_bigrams(...))
  out[1] <- stringr::str_to_sentence(out[1])
  if (w <= n) {
    out[w] <- stringr::str_to_sentence(out[w])
  }
  out[n] <- stringr::str_replace(out[n], "[^[:alnum:]]+$", end)
  stringr::str_c(out, collapse = "")
}


#' Writes a poem of pure gibberish
#'
#' @param lines The number of lines per stanza. A single integer returns a single
#'   stanza of this many lines. A vector of multiple integers, of length n, will
#'   return a poem of n stanzas, with lengths as given in the vector.
#' @param mean_line_length Line lengths will be generated at random from a normal
#'   distribution around this mean, with SD equal to 1 by default.
#' @param ... A place to pass on parameters such as `cutoff`, which affects
#'   the available frequencies of the bigrams used to build words.
#' @param cat Boolean. Whether to spew the poem straight to stdout via `cat()`
#'   (TRUE, default), or return it invisibly (you'll want to pipe it to an
#'   object or some other function, presumably).
#'
#' @return A beautiful poem (character strings concatenated with line breaks)
#' @export
#'
#' @examples write_a_poem(c(4, 4), cutoff = 0.01)
write_a_poem <- function(lines, mean_line_length = 7, cat = TRUE, ...) {

  line_lengths <- lines %>%
    purrr::map(~ round(sample(rnorm(100, mean_line_length), .)))

  poem <- line_lengths %>%
    purrr::map(write_a_verse, ...) %>%
    stringr::str_c(collapse = "\n\n")

  if (cat) cat(poem) else poem
  # else invisible(poem)
}
