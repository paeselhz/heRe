#' Batch Geocoding with Here API
#'
#' \code{here_batch_geocoder} Returns a data.frame containing the latitude and longitude of a list of addresses.
#' This should only be used to search large volumes of data with Here Geolocation Services.
#'
#' This function is used by passing a data.frame, that contains a column with the text to be searched in the Here API,
#' and a column with the Country which this address/text refers to. It also leverages two other functions from this (heRe) package:
#' `here_get_job_status` and `here_download_job`. This process occurs to allow the user to upload a data.frame with many observations
#' to be fulfilled by latitude and longitude data from the Here API, and return a data.frame containing the searchText,
#' and the latitude and longitude pair.
#'
#' @param df A data.frame containing the columns of the searchText and the Country where this address is located - data.frame/tibble
#' @param search_var The column which contains the address/text to be searched by the Here API
#' @param country The column which contains the country where this address is located
#' @param here_id The developer application ID that uniquely identify the user
#' @param here_code The developer application Code that uniquely identify the user
#'
#' @return Given a valid app_id, and app_code, the script returns a data.frame containing
#' the searched text/address, and the latitude and longitude, if it found any.
#'
#' @examples
#'
#' \dontrun{
#'
#' df <-
#'   data.frame(address = c("27 King's College Cir, Toronto", "Avenida Joao Pessoa, Porto Alegre"),
#'              country = c("CAN", "BRA"))
#'
#' here_batch_geocoder(df, search_var = address, country = country, '<YOUR_APP_ID>', '<YOUR_APP_CODE>')
#' }
here_batch_geocoder <-
  function(df, search_var, country, here_id, here_code){

    `%>%` <- magrittr::`%>%`

    post_url <-
      paste0(
        "https://batch.geocoder.api.here.com/6.2/jobs",
        "?app_id=", here_id,
        "&app_code=", here_code,
        "&indelim=%7C",
        "&outdelim=%7C",
        "&action=run",
        "&outcols=Latitude,Longitude,",
        "state,country",
        "&outputcombined=false"
      )

    df_search <-
      df %>%
      dplyr::select({{search_var}}, {{country}}) %>%
      dplyr::mutate(
        recId = stringr::str_pad(rank({{search_var}}), 5, pad = '0')
      ) %>%
      dplyr::select(
        recId,
        searchText = {{search_var}},
        country = {{country}}
      )

    tmp <- tempfile()

    write.table(
      df_search,
      tmp,
      sep = '|',
      na = '',
      row.names = FALSE,
      quote = FALSE
    )

    post_body <-
      readr::read_file(tmp)

    post_req <-
      httr::POST(
        url = post_url,
        body = post_body
      )

    request_id <-
      httr::content(post_req) %>%
      .$Response %>%
      .$MetaInfo %>%
      .$RequestId

    while(here_get_job_status(request_id, here_id, here_code) != 'completed') {

      message('Waiting for job completion')

      Sys.sleep(5)

    }

    filename <- here_download_job(request_id, here_id, here_code)

    return_df <-
      df_search %>%
      dplyr::select(-country) %>%
      dplyr::mutate(
        recId = as.numeric(recId)
      ) %>%
      dplyr::left_join(
        read.table(filename, header = TRUE, sep = '|') %>%
          dplyr::filter(SeqNumber == 1),
        by = 'recId'
      ) %>%
      dplyr::select(
        searchText,
        latitude,
        longitude,
        country
      )

    file.remove(filename)

    return(return_df)

  }
