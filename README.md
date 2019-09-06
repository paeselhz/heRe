# heRe

<!-- badges: start -->
<!-- badges: end -->

The development of this package aims to provide R users with another interface for a geolocation service. Many services are available on the internet, such as Google Maps API, Location IQ, Bing Maps and many others. One key player in the geolocation services is [Here](http://here.com).

This company has been around with the geolocation markets since 1985, providing in-car navigation systems. Nowadays they allow developers and users to create a _freemium_ account, which licenses everybody that is registered in their developer platform to use 250k API requests per month.

Many of their services are focused on Geolocation, Geovisualization, Tracking and, Routing. My implementation of functions that allow R users to leverage their _REST API_, exclusively regarding geocoding services.

To get the *APP_ID* and *APP_CODE* that is required to authenticate users to use this platform, one must visit the [developers](http://developer.here.com) page, and follow the instructions there.

---

## Installation

This package is still in it's early stages, and can suffer many modifications:

``` r
#install.packages('devtools')
devtools::install_github("paeselhz/heRe")
```

---

## Examples

Below are a couple of examples that leverage both main functionalities of their REST API:
  * Single API requests for geocoding, reverse geocoding and landmark searches;
  * Batch geocoding that allows users to send many requests with a single POST request;
  
### `here_geocoder`

This function allow users to send their request (it can be any sort of string that contains an address, zip code, neighbour or other geolocation reference), and the return is a list containing the latitude and longitude of the searched place.

Example:

``` r
heRe::here_geocoder(
  src_address = "770 Don Mills Rd, North York, ON M3C 1T3, Canada", 
  here_id = "<YOUR_HERE_ID>",
  here_code = "<YOUR_HERE_CODE>"
)
```

### `here_reverse_geocoder`

This function allow users to reverse geocoding their latitude and longitude information, and the return is the closest match of Street, House Number, District, City, State and Country.

Example:

``` r
heRe::here_reverse_geocoder(
  lat = '40.133234',
  lon = '11.542268',
  here_id = "<YOUR_HERE_ID>",
  here_code = "<YOUR_HERE_CODE>"
)
```

### `here_reverse_geocoder_landmarks`

This function returns the top 10 closest landmarks of a given latitude and longitude. The user can also specify the radius of this search. The return is a data.frame containing the 10 (or less) returns.

Example:

``` r
heRe::here_reverse_geocoder_landmarks(
  lat = '43.6784393',
  lon = '-79.410179',
  radius = 5000,
  here_id = "<YOUR_HERE_ID>",
  here_code = "<YOUR_HERE_CODE>"
)
```

### `here_batch_geocoder`

This function allow the user to run multiple geocoding searchers with a single POST request. It sends the searched string/address and returns a data.frame contaning the same string/address and it's latitude and longitude information.

``` r
here_batch_geocoder(
  df = data.frame(
    src_var = c("Queen St W, Toronto, ON",
                "King St W, Toronto, ON"),
    country_var = "CAN"
  ),
  search_var = src_var,
  country = country_var,
  here_id = "<YOUR_HERE_ID>",
  here_code = "<YOUR_HERE_CODE>"
)
```

---

