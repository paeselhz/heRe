# heRe

<!-- badges: start -->
<!-- badges: end -->

The development of this package aims to provide R users with another interface for a geolocation service. Many services are available on the internet, such as Google Maps API, Location IQ, Bing Maps and many others. One key player in the geolocation services is [Here](here.com).

This company has been around with the geolocation markets since 1985, providing in-car navigation systems. Nowadays they allow developers and users to create a _freemium_ account, which licenses everybody that is registered in their developer platform to use 250k API requests per month.

Many of their services are focused on Geolocation, Geovisualization, Tracking and, Routing. My implementation of functions that allow R users to leverage their _REST API_, exclusively regarding geocoding services.

To get the *APP_ID* and *APP_CODE* that is required to authenticate users to use this platform, one must visit the [developers](developer.here.com) page, and follow the instructions there.

---

## Installation

This package is still in it's development stages, and can suffer many modifications:

``` r
#install.packages('devtools')
devtools::install_github("paeselhz/heRe")
```

---

## Example

Below are a couple of examples that leverage both main functionalities of their REST API:
  * Single API requests for geocoding, reverse geocoding and landmark searches;
  * Batch geocoding that allows users to send many requests with a single POST request;
  


