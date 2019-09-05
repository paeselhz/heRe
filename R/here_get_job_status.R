#' Get Here Job Status by it's Id
#'
#' \code{here_get_job_status} Returns the status of a job sent to run with the Batch Geocoding API (with `here_batch_geocoder`)
#'
#' This is a support function to the `here_batch_geocoder`, to ensure that the job sent
#' has completed before trying to download it.
#'
#' @param job_id A string with the Job's unique Id.
#' @param here_id The developer application ID that uniquely identify the user
#' @param here_code The developer application Code that uniquely identify the user
#'
#' @return Given a valid job_id, here_id and here_code, it returns a string containing the Job's status.
here_get_job_status <-
  function(job_id, here_id, here_code) {

    `%>%` <- magrittr::`%>%`

    url <-
      paste0("https://batch.geocoder.api.here.com/6.2/jobs/",
             job_id,
             "?action=status",
             "&app_code=", here_code,
             "&app_id=", here_id)

    status <-
      httr::GET(url) %>%
      httr::content() %>%
      .$Response %>%
      .$Status

    return(status)

  }
