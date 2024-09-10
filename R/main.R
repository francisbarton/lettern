#' Pull a weighted sample of n letters from the alphabet
#'
#' The `replace` parameter is fixed to TRUE, as this is what makes sense given
#'   the frequency-dependent nature of this particular sampling approach.
#'   This function returns a single letter based on a weighted sampling from all
#'   26 letters, based on their overall frequency in Norvig's corpus.
#'
#' @param n The number of letters to return.
#' @returns A vector of lower-case letters.
#' @examples sample_letters(3)
#' @export
sample_letters <- function(n) {
  letter_frequencies_overall |>
    dplyr::slice_sample(n = n, weight_by = pick("count"), replace = TRUE) |>
    dplyr::pull("letter")
}

#' Choose a letter based on frequency (or frequency at position n within a word)
#'
#' @param n If n is a non-zero integer between -7 and 7 (position in word, from
#'  1 (first) to 7 (seventh) or from -1 (last) to -7 (seventh from last)), it
#'  returns a single letter based on letter frequencies at that position only.
#' @returns A lower-case letter (character string of `nchar` 1) between a and z
#' @examples choose_a_letter(3)
#' @export
choose_a_letter <- function(n) {
  letter_frequencies_by_position |>
    dplyr::filter(if_any("position", \(x) x == n)) |>
    dplyr::slice_sample(n = 1, weight_by = pick("count")) |>
    dplyr::pull("letter")
}



#' Build a beautiful sentence of sheer nonsense
#'
#' @param n The number of words to include in the sentence.
#' @param end The string to end the sentence with. Defaults to a full stop.
#' @param ... A place to pass on parameters such as `cutoff`, which affects
#'  the available frequencies of the bigrams used to build words.
#' @returns A single string of n words with an ending character such as a full
#'  stop.
#' @examples build_a_sentence(6, cutoff = 0.005)
#' @export
build_a_sentence <- function(n, end = ".", ...) {

  # Create a chance of a random word being sentence-cased
  # (Will happen ~ once every 10 times this function is called)
  w <- sample(10 * n, 1)

  out <- replicate(n, construct_with_bigrams(...))
  out[[1]] <- stringr::str_to_sentence(out[[1]])
  if (w <= n) out[[w]] <- stringr::str_to_sentence(out[[w]])
  out[[n]] <- stringr::str_replace(out[[n]], "[^[:alnum:]]*$", end)
  stringr::str_flatten(out)
}


#' Writes a poem of pure gibberish
#'
#' @param lines The number of lines per stanza. A single integer returns a
#'  single stanza of this many lines. A vector of multiple integers, of length
#'  `n`, will return a poem of n stanzas, with lengths as given in the vector.
#' @param mean_line_length Line lengths will be generated at random from a
#'  normal distribution around this mean, with SD equal to 1 by default.
#' @param ... A place to pass on parameters such as `cutoff`, which affects the
#'  available frequencies of the bigrams used to build words.
#' @param cat Boolean. Whether to spew the poem straight to stdout via `cat()`
#'  (TRUE, default), or return it invisibly (you'll want to pipe it to an
#'  object or some other function, presumably).
#'
#' @returns A beautiful poem
#' @examples write_a_poem(c(4, 4), cutoff = 0.01)
#' @export
write_a_poem <- function(lines, mean_line_length = 7, cat = TRUE, ...) {
  poem <- lines |>
    purrr::map(\(x) round(sample(rnorm(100, mean_line_length), x))) |>
    purrr::map_chr(\(x) write_a_verse(x, ...)) |>
    stringr::str_flatten(collapse = "\n\n")

  if (cat) cat(poem) else invisible(poem)
}
