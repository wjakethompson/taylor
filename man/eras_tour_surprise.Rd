% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{eras_tour_surprise}
\alias{eras_tour_surprise}
\title{The Eras Tour Surprise Songs}
\format{
A \link[tibble:tibble-package]{tibble} with 262
rows and 9 variables:
\itemize{
\item \code{leg}: The leg of the tour (e.g., North America, South America, etc.).
\item \code{date}: The date of the show in ISO 8601 format (yyyy-mm-dd).
\item \code{city}: The location of the show. For US shows, the location is the city
and state. For international shows, the location is the city and country.
\item \code{night}: The show number within each city.
\item \code{dress}: The color of the dress Taylor wore on the given night.
\item \code{instrument}: The instrument used to play the song (guitar or piano).
\item \code{song}: The track name of the primary surprise song.
\item \code{mashup}: Additional songs included in a mashup with the primary song.
\item \code{guest}: The special guest (if any) that joined Taylor to play the song.
}
}
\usage{
eras_tour_surprise
}
\description{
A data set containing all of the surprise songs played on The Eras Tour
through the first North American leg of the tour.
}
\keyword{datasets}
