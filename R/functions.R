choose_next_length <- function() {
  word_length_frequencies |>
    # for now as we are just playing with words of max length 14
    dplyr::filter(if_any("word_length", \(x) x <= 14)) |>
    dplyr::slice_sample(n = 1, weight_by = pick("count_millions")) |>
    dplyr::pull("word_length")
}


next_letter <- function(l, cutoff = 0.001) {
  bigram_frequencies |>
    dplyr::filter(
      if_any("percentage", \(x) x >= cutoff) &
      if_any("bigram_1", \(b) b == l)
     ) |>
    dplyr::slice_sample(n = 1, weight_by = pick("count")) |>
    dplyr::pull("bigram_2")
}


construct_with_bigrams <- function(...) {
  len <- choose_next_length()
  l1 <- choose_a_letter(1)

  word <- seq(len - 1) |>
    purrr::reduce(\(x, y) paste0(x, next_letter(last(x), ...)), .init = l1)

  punct <- c(rep(" ", 68), rep(", ", 5), rep(" - ", 4), rep("; ", 2), ": ", "-")
  paste0(word, sample(punct, 1))
}


write_a_verse <- function(line_lengths, ...) {
  pnc <- \() sample(c(rep(",", 22), rep("", 3), rep("?", 2), "...", "!", ";"),1)
  purrr::map_chr(line_lengths, \(x) build_a_sentence(x, pnc(), ...)) |>
    stringr::str_flatten(collapse = "\n") |>
    stringr::str_replace("[[:punct:]]*$", ".")
}
