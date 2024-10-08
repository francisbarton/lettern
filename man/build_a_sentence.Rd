% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/main.R
\name{build_a_sentence}
\alias{build_a_sentence}
\title{Build a beautiful sentence of sheer nonsense}
\usage{
build_a_sentence(n, end = ".", ...)
}
\arguments{
\item{n}{The number of words to include in the sentence.}

\item{end}{The string to end the sentence with. Defaults to a full stop.}

\item{...}{A place to pass on parameters such as \code{cutoff}, which affects
the available frequencies of the bigrams used to build words.}
}
\value{
A single string of n words with an ending character such as a full
stop.
}
\description{
Build a beautiful sentence of sheer nonsense
}
\examples{
build_a_sentence(6, cutoff = 0.005)
}
