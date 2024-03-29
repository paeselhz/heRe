% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/here_download_job.R
\name{here_download_job}
\alias{here_download_job}
\title{Download Here Job by it's Id}
\usage{
here_download_job(job_id, here_id, here_code)
}
\arguments{
\item{job_id}{A string with the Job's unique Id.}

\item{here_id}{The developer application ID that uniquely identify the user}

\item{here_code}{The developer application Code that uniquely identify the user}
}
\value{
Given a valid job_id, here_id and here_code, it returns a string containing the Job's return file name.
}
\description{
\code{here_download_job} Donwloads the job sent to run with the Batch Geocoding API (with `here_batch_geocoder`) and unzips it's files.
}
\details{
This is a support function to the `here_batch_geocoder`, to download the jobs content
and extract from the zip file.
}
