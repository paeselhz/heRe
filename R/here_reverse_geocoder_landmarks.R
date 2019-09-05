#' Reverse Geocoding with Here API - Gather Landmarks data
#'
#' \code{here_reverse_geocoder_landmarks} Returns address information of the top 10 closest landmarks of a given latitude and longitude.
#'
#' This function works by verifying in the Here API the top 10 closest landmarks of a given latitude and
#' longitude. The return is a data.frame containing multiple informations about the landmarks distance to the given point,
#' and each landmarks name, address, country, state, city, district, street and postal code.
#'
#' @param lat The latitude to be searched using the Here API - numeric
#' @param lon The longitude to be searched using the Here API - numeric
#' @param radius The search radius in meters to be used by the Here API - numeric
#' @param here_id The developer application ID that uniquely identify the user
#' @param here_code The developer application Code that uniquely identify the user
#'
#' @return Given a valid app_id, and app_code, the script returns a data.frame containing
#' the closest landmarks, its distance to the given point, and each landmarks name, address,
#' country, state, city, district, street and postal code;
#'
#' @examples
#'
#' \dontrun{
#' here_reverse_geocoder_landmarks(43.643513, -79.378262, 5000, '<YOUR_APP_ID>', '<YOUR_APP_CODE>')
#' }
here_reverse_geocoder_landmarks <-
  function(lat, lon, radius, here_id, here_code) {

    `%>%`  <- magrittr::`%>%`

    url <- paste0(
      'https://reverse.geocoder.api.here.com/6.2/reversegeocode.json?',
      'prox=',lat, ',', lon, ',', radius,
      '&mode=retrieveLandmarks',
      '&app_id=', here_id,
      '&app_code=', here_code,
      '&gen=9'
    )

    get_request_url <-
      httr::GET(url)

    answer <-
      httr::content(get_request_url) %>%
      .$Response %>%
      .$View %>%
      purrr::flatten() %>%
      .$Result %>%
      tibble::enframe() %>%
      dplyr::mutate(
        distance                     = lapply(value, function(x) x$Distance),
        match_level                  = lapply(value, function(x) x$MatchLevel),
        location_type                = lapply(value, function(x) x$Location$LocationType),
        location_name                = lapply(value, function(x) x$Location$Name),
        location_address             = lapply(value, function(x) x$Location$Address$Label),
        location_address_country     = lapply(value, function(x) x$Location$Address$Country),
        location_address_state       = lapply(value, function(x) x$Location$Address$State),
        location_address_city        = lapply(value, function(x) x$Location$Address$City),
        location_address_district    = lapply(value, function(x) x$Location$Address$District),
        location_address_street      = lapply(value, function(x) x$Location$Address$Street),
        location_address_postal_code = lapply(value, function(x) x$Location$Address$PostalCode)
      ) %>%
      dplyr::select(-name, -value)

    return(as.data.frame(answer))

  }
