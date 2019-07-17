
lat <- '-29.17345'
lon <- '-51.1743'

app_id <-   'xT6vodxSMGk4BJDYCQKX'
app_code <- '4sc_r39j3p-uW1NHdCuSnQ'

radius <- 5000

`%>%`  <- magrittr::`%>%`

url <- paste0(
  'https://reverse.geocoder.api.here.com/6.2/reversegeocode.json?',
  'prox=',lat, ',', lon, ',', radius,
  '&mode=retrieveLandmarks',
  '&app_id=', app_id,
  '&app_code=', app_code,
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
