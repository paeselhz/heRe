% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/here_reverse_geocoder.R
\name{here_reverse_geocoder}
\alias{here_reverse_geocoder}
\title{Reverse Geocoding with Here API}
\usage{
here_reverse_geocoder(lat, lon, here_id, here_code)
}
\arguments{
\item{lat}{The latitude to be searched using the Here API - numeric}

\item{lon}{The longitude to be searched using the Here API - numeric}

\item{here_id}{The developer application ID that uniquely identify the user}

\item{here_code}{The developer application Code that uniquely identify the user}
}
\value{
Given a valid app_id, and app_code, the script returns a list containing
the label, country, state, city, district, street, house_number and postal code of a given
latityde and longitude pair;
}
\description{
\code{here_reverse_geocoder} Returns address information of a given latitude and longitude.
}
\details{
This function works by verifying in the Here API the address of a given latitude and
longitude. The return is a list containing multiple informations about the address
label, country, state, city, district, street, house_number and postal code.
}
\examples{

\dontrun{
here_reverse_geocoder(43.643513, -79.378262, '<YOUR_APP_ID>', '<YOUR_APP_CODE>')
}
}
