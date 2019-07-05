#' Reverse Geocoding with Here API
#'
#' \code{here_reverse_geocoder} Returns address information of a given latitude and longitude.
#'
#' This function works by verifying in the Here API the address of a given latitude and
#' longitude. The return is a list containing multiple informations about the address
#' label, country, state, city, district, street, house_number and postal code.#'
#'
#' @param lat The latitude to be searched using the Here API - numeric
#' @param lon The longitude to be searched using the Here API - numeric
#' @param app_id The developer application ID that uniquely identify the user
#' @param app_code The developer application Code that uniquely identify the user
#'
#' @return Given a valid app_id, and app_code, the script returns a list containing
#' the label, country, state, city, district, street, house_number and postal code of a given
#' latityde and longitude pair;
#'
#' @examples
#'
#' \dontrun{
#' here_reverse_geocoder(43.643513, -79.378262, '<YOUR_APP_ID>', '<YOUR_APP_CODE>')
#' }
here_reverse_geocoder <-
  function(lat, lon, app_id, app_code){

    `%>%`  <- magrittr::`%>%`

    url <-
      paste0(
        'https://reverse.geocoder.api.here.com/6.2/reversegeocode.json?',
        'app_id=', app_id,
        '&app_code=', app_code,
        '&mode=retrieveAddresses',
        '&maxresults=1',
        '&prox=', lat, ',', lon,',250'
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
        label        = result_location_address_label,
        country      = result_location_address_country,
        state        = result_location_address_state,
        city         = result_location_address_city,
        district     = result_location_address_district,
        street       = result_location_address_street,
        house_number = result_location_address_house_number,
        postal_code  = result_location_address_postal_code
      )

    return(as.list(answer))

  }

