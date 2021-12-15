norvig_url <- "https://www.norvig.com/mayzner.html"
norvig <- rvest::read_html(norvig_url)


# Word length frequencies -------------------------------------------------

word_length_frequencies <- norvig %>%
  rvest::html_element("body") %>%
  rvest::html_element("div") %>%
  rvest::html_elements("pre") %>%
  magrittr::extract(2) %>%
  rvest::html_text2() %>%
  stringr::str_split("\n") %>%
  magrittr::extract2(1) %>%
  stringr::str_squish() %>%
  utils::tail(-2) %>%
  utils::head(-1) %>%
  stringr::str_split(" ", simplify = TRUE) %>%
  dplyr::as_tibble(.name_repair = "universal") %>%
  dplyr::select(
    word_length = 1,
    count_millions = 2,
    percentage = 4
  ) %>%
  dplyr::mutate(across(percentage, ~ stringr::str_remove(., "%$"))) %>%
  dplyr::mutate(across(everything(), as.numeric))


# Overall letter frequencies ----------------------------------------------

letter_frequencies_overall <- norvig %>%
  rvest::html_element("body") %>%
  rvest::html_elements("span") %>%
  rvest::html_attr("title") %>%
  magrittr::extract(which(!is.na(.))) %>%
  utils::head(26) %>%
  stringr::str_split("[:punct:]{1}[\\s|\\n]{1}", simplify = TRUE) %>%
  dplyr::as_tibble(.name_repair = "unique") %>%
  dplyr::select(
    letter = 1,
    count = 3,
    percentage = 2
  ) %>%
  dplyr::mutate(across(count, ~ stringr::str_remove_all(., ","))) %>%
  dplyr::mutate(across(percentage, ~ stringr::str_remove(., "%$"))) %>%
  dplyr::mutate(across(count:percentage, as.numeric))





# Letter frequencies by position ------------------------------------------

# "Now we show the letter frequencies by position within word. That is, the frequencies for just the first letter in each word, just the second letter, and so on.
# We also show frequencies for positions relative to the end of the word: "-1" means the last letter, "-2" means the second to last, and so on."

letter_frequencies_by_position <- norvig %>%
  rvest::html_element("body") %>%
  rvest::html_elements("p") %>%
  magrittr::extract(4) %>%
  rvest::html_elements("span") %>%
  rvest::html_attr("title") %>%
  magrittr::extract(which(!is.na(.))) %>%
  stringr::str_split("[:punct:]{1} ", simplify = TRUE) %>%
  dplyr::as_tibble(.name_repair = "unique") %>%
  dplyr::bind_cols(position = rep(c(1:7, -7:-1), each = 26)) %>%
  dplyr::select(
    position,
    letter = 1,
    count = 3,
    percentage = 2
  ) %>%
  dplyr::mutate(across(percentage, ~ stringr::str_remove(., "%$"))) %>%
  dplyr::mutate(across(count, ~ stringr::str_remove_all(., ","))) %>%
  dplyr::mutate(across(count:percentage, as.numeric))


# Bigram frequencies ------------------------------------------------------

# "Now we turn to sequences of letters: consecutive letters anywhere within a word.
# Below is a table of all 26 × 26 = 676 bigrams; in each cell the orange bar is proportional to the frequency, and if you hover you can see the exact counts and percentage.
# There are only seven bigrams that do not occur among the 2.8 trillion mentions: JQ, QG, QK, QY, QZ, WQ, and WZ."

bigram_frequencies <- norvig %>%
  rvest::html_element("body") %>%
  rvest::html_elements("div") %>%
  magrittr::extract(3) %>%
  rvest::html_children() %>%
  magrittr::extract(6) %>%
  rvest::html_elements("tr") %>%
  tail(-1) %>%
  rvest::html_elements("td") %>%
  rvest::html_attr(., name = "title") %>%
  stringr::str_split("[:punct:]{1} ", simplify = TRUE) %>%
  dplyr::as_tibble(.name_repair = "unique") %>%
  dplyr::select(
    bigram = 1,
    count = 3,
    percentage = 2
  ) %>%
  dplyr::mutate(across(percentage, ~ stringr::str_remove(., "%$"))) %>%
  dplyr::mutate(across(count, ~ stringr::str_remove_all(., ","))) %>%
  dplyr::mutate(across(count:percentage, as.numeric)) %>%
  dplyr::mutate(across(bigram, tolower)) %>%
  tidyr::separate(col = bigram, into = c("bigram_1", "bigram_2"), sep = 1, remove = TRUE) %>%
  dplyr::arrange(bigram_1, bigram_2)

usethis::use_data(word_length_frequencies, letter_frequencies_overall, letter_frequencies_by_position, bigram_frequencies, overwrite = TRUE)
