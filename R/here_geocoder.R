#' Geocoding with Here API
#'
#' \code{here_geocoder} Returns the latitude and longitude of a given address.
#'
#' This function works by verifying in the Here API the latitude and longitude
#' of a given address. The return is a list containing the latitude and longitude of the
#' searched address.
#'
#' @param src_address The address to be searched in the Here API
#' @param here_id The developer application ID that uniquely identify the user
#' @param here_code The developer application Code that uniquely identify the user
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
  function(src_address, here_id, here_code){

    `%>%` <- magrittr::`%>%`

    src_address <- iconv(src_address, from = 'latin1', to = 'ASCII//TRANSLIT')

    message(paste0('searching ', src_address))

    url <-
      paste0(
        'https://geocoder.api.here.com/6.2/geocode.json?',
        'app_id=', here_id,
        '&app_code=', here_code,
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

      message('loop')

    }

    answer <-
      httr::content(get_request_url) %>%
      .$Response %>%
      .$View %>%
      as.data.frame() %>%
      janitor::clean_names()

    if(nrow(answer) != 0) {

      answer <-
        answer%>%
        dplyr::select(
          latitude  = result_location_display_position_latitude,
          longitude = result_location_display_position_longitude
        )

      message('success')

    } else {

      answer <-
        data.frame(latitude = NA,
                   longitude = NA)

      message('empty answer')
    }

    return(as.list(answer))

  }

