
<!-- README.md is generated from README.Rmd. Please edit that file -->

# lettern

<!-- badges: start -->
<!-- badges: end -->

I was working on a project and I used `sample` to make a selection from
`letters` (the letters of the alphabet (lowercase)), and then I thought…

*What if* I had a weighted pool of letters such that `sample` would
return letters according to their frequency of use in English?

So then I looked up what those frequencies would be, and found several
resources, but [Peter Norvig’s
page](https://www.norvig.com/mayzner.html) seemed well-presented and
authoritative so I went with that. And then I thought…

*What if* I started making nonsense words by picking letters according
to their frequency and sticking them together to form a word of
arbitrary length? And then I thought…

*What if* I used Norvig’s data on the distribution of word lengths in
English to influence the length of the word? And then I thought…

*What if* I interfered with the letter choice function by making it
choose letters by their *position* in the word – taking a sample
weighted by Norvig’s data on likelihood to find a letter `a` in position
`n`? I actually wrote it so that it would combine the likelihoods for
position from the front and position from the back (eg for the 3rd
letter of a 7 letter word, it would combine letter frequencies for
positions 3 *and* -5).

But that produced some pretty awkward results. And then I thought…

*What if* I just picked the first letter of the word using that
function, and then used a separate process based on bigram frequency to
construct the rest of the word (where n \> 1)?

So I did. And then I thought…

*What if* I taught it to combine the words into sentences/lines, adding
more or less random punctuation, and then to combine sentences into
stanzas, and then into poems with multiple stanzas of various lengths,
and with some random variation in line length around a mean…?

But still I wanted my (my? They’re not mine) words to be less awkward
and have fewer improbable consonant combinations And then I thought..

*What if* I filtered out the most improbable bigrams (frequency \<
0.001, say) and only allowed the system to use the remaining
combinations. (This filter is configurable via the `cutoff` parameter in
several of the available functions.)

And then I stopped. And wrote a README.

## Installation

You can install the development version of `lettern` like so:

``` r
remotes::install_github("francisbarton/lettern")
# or
devtools::install_github("francisbarton/lettern")
```

## Functions

The package just consists of a series of nested functions, starting with
the simplest and expanding in scope to the more powerful.

Here are some things you can do with `lettern`.

1.  You can just ask it to give you a weighted sample of `n` letters:

``` r
sample_letters(3)
#> [1] "a" "e" "e"
```

or you can get it to choose a letter based on the frequencies at a
certain word position:

``` r
choose_a_letter(3)
#> [1] "d"
```

You can ask it to write you a whole sentence with a capital letter and a
full stop:

``` r
build_a_sentence(6, cutoff = 0.005)
#> [1] "T illenal pheanepeth rinchedma ade pesigmenui."
```

And you can ask for it to string these together to make a majestic poem
of pure gibberish:

``` r
write_a_poem(c(4, 4), cutoff = 0.01)
#> Pontht bl - cke angedex th at,
#> Re bsake apewhonor ico Dero argh aldrssease angenm,
#> Tid li ande anedcar naverede her: ser pem,
#> M - thin wh wedlond stenaime.
#> 
#> Owl presuga: stw lwalofesm atel thoe her...
#> Le sendan - alla bj chit iti!
#> Acalle: senan p ofonsth blyethec ofr anancu stsonthan,
#> A humen achit - heysn gn destcoudleq bes.
```

There are four datasets scraped from Norvig’s page that are available
via this package. Once you have loaded this package, you will be able to
load these data frames via:

``` r
library(lettern)
#' "[H]ere is the breakdown of mentions (in millions) by word length (looking like a Poisson distribution).
#' The average is 4.79 letters per word, and 80% are between 2 and 7 letters long"
data("word_length_frequencies")

#' Letter counts/frequencies overall
data("letter_frequencies_overall")

#' "Now we show the letter frequencies by position within word. That is, the frequencies for just the first letter in each word, just the second letter, and so on.
#' We also show frequencies for positions relative to the end of the word: "-1" means the last letter, "-2" means the second to last, and so on."
data("letter_frequencies_by_position")

#' "Now we turn to sequences of letters: consecutive letters anywhere within a word.
#' Below is a table of all 26 × 26 = 676 bigrams; in each cell the orange bar is proportional to the frequency, and if you hover you can see the exact counts and percentage.
#' There are only seven bigrams that do not occur among the 2.8 trillion mentions: JQ, QG, QK, QY, QZ, WQ, and WZ."
data("bigram_frequencies")
```

### That’s it

Have fun! And do suggest things to make this better - use issues, PRs or
just email me.

### PS

It’s not supposed to make English words, except by accident. It’s more
playful than that.

If I wanted that, I would just make a program to sample from wordlists.

It’s about exploring sampling probabilities and weightings. And about
seeing how we feel, how we respond to strange words, how we find certain
words familiar, cute, bizarre, evocative, irritating or hostile.

But I do want it to generate text that is somehow readable on the whole
(pronounceable is what I really mean), or at least mostly so.
