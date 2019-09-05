#' Download Here Job by it's Id
#'
#' \code{here_download_job} Donwloads the job sent to run with the Batch Geocoding API (with `here_batch_geocoder`) and unzips it's files.
#'
#' This is a support function to the `here_batch_geocoder`, to download the jobs content
#' and extract from the zip file.
#'
#' @param job_id A string with the Job's unique Id.
#' @param here_id The developer application ID that uniquely identify the user
#' @param here_code The developer application Code that uniquely identify the user
#'
#' @return Given a valid job_id, here_id and here_code, it returns a string containing the Job's return file name.
here_download_job <-
  function(job_id, here_id, here_code) {

    `%>%` <- magrittr::`%>%`

    url <-
      paste0(
        "https://batch.geocoder.api.here.com/6.2/jobs/",
        job_id, "/result",
        "?app_id=", here_id,
        "&app_code=", here_code
      )

    download.file(url, destfile = 'temp.zip', method = 'curl')

    zip::unzip('temp.zip')

    file.remove('temp.zip')

    return(
      list.files(
        path = '.',
        pattern = 'result+.*\\.txt'
      )
    )

  }
