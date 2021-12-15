choose_next_length <- function() {
  lettern::word_length_frequencies %>%
    # for now as we are just playing with words of max length 14
    dplyr::filter(.data$word_length < 15) %>%
    dplyr::slice_sample(n = 1, weight_by = .data$count_millions) %>%
    dplyr::pull(.data$word_length)
}


# make_a_word <- function() {
#   len <- choose_next_length()
#   m <- seq(round(len / 2))
#   n <- seq(-1, (len - length(m)) * -1)
#
#   utils::head(c(m, n), len) %>%
#     purrr::map_chr(choose_a_letter) %>%
#     stringr::str_c(collapse = "") %>%
#     paste0(., " ")
# }

next_letter <- function(x, cutoff = 0.001) {
  lettern::bigram_frequencies %>%
    dplyr::filter(.data$percentage >= cutoff) %>%
    dplyr::filter(.data$bigram_1 == x) %>%
    dplyr::slice_sample(n = 1, weight_by = .data$count) %>%
    dplyr::pull(.data$bigram_2)
}

construct_with_bigrams <- function(...) {
  len <- choose_next_length()
  word <- choose_a_letter(1)

  while (length(word) < len) {
    word <- c(word, next_letter(dplyr::last(word), ...))
  }

  random_punc <- c(
    rep(" ", 68),
    rep(", ", 5),
    rep(" - ", 4),
    rep("; ", 2),
    rep(": ", 1)
  ) %>%
    sample(1)

  # return
  stringr::str_c(word, collapse = "") %>%
    paste0(., random_punc)
}


write_a_verse <- function(line_lengths, ...) {
  end_punc <- function() {
    sample(c(
      rep(",", 22),
      rep("", 3),
      rep("?", 2),
      "...",
      "!",
      ";"
    ), 1)
  }

  c(
    purrr::map_chr(
      utils::head(line_lengths, -1), ~ build_a_sentence(., end = end_punc(), ...)
  ),
    build_a_sentence(utils::tail(line_lengths, 1), ...)
    ) %>%
    utils::tail(length(line_lengths)) %>%
    stringr::str_c(collapse = "\n")
}
