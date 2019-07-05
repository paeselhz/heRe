#' Geocoding with Here API
#'
#' \code{here_geocoder} Returns the latitude and longitude of a given address.
#'
#' This function works by verifying in the Here API the latitude and longitude
#' of a given address. The return is a list containing the latitude and longitude of the
#' searched address.
#'
#' @param src_address The address to be searched in the Here API
#' @param app_id The developer application ID that uniquely identify the user
#' @param app_code The developer application Code that uniquely identify the user
#'
#' @return Given a valid app_id, and app_code, the script returns a list containing
#' the latitude and longitude of the given address;
#'
#' @examples
#'
#' \dontrun{
#' here_geocoder("27 King's College Cir, Toronto, ON M5S, Canada", '<YOUR_APP_ID>', '<YOUR_APP_CODE>')
#' }
here_geocoder <-
  function(src_address, app_id, app_code){

    `%>%` <- magrittr::`%>%`

    url <-
      paste0(
        'https://geocoder.api.here.com/6.2/geocode.json?',
        'app_id=', app_id,
        '&app_code=', app_code,
        '&searchtext=', gsub(' ', '+', src_address)
      )

    get_request_url <-
      httr::GET(url)

    while(
      httr::status_code(get_request_url) != 200
    ){

      get_request_url <-
        httr::GET(url)

      Sys.sleep(2)

    }

    answer <-
      httr::content(get_request_url) %>%
      .$Response %>%
      .$View %>%
      as.data.frame() %>%
      janitor::clean_names() %>%
      dplyr::select(
        latitude  = result_location_display_position_latitude,
        longitude = result_location_display_position_longitude
      )

    return(as.list(answer))

  }