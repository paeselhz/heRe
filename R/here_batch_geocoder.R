here_batch_geocoder <-
  function(df, search_string = 'text', country = 'BRA', app_id, app_code){
    
    post_url <-
      paste0(
        "https://batch.geocoder.api.here.com/6.2/jobs",
        "?app_id=", app_id,
        "&app_code=", app_code, 
        "&indelim=%7C",
        "&outdelim=%7C",
        "&action=run",
        "&outcols=Latitude,Longitude,",
        "state,country",
        "&outputcombined=false"
      )
    
    df_search <-
      df %>% 
      select({{search_string}}) %>% 
      mutate(
        recId = stringr::str_pad(rank({{search_string}}), 5, pad = '0'),
        country = 'BRA'
      ) %>% 
      select(
        recId,
        searchText = {{search_string}},
        country
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
    
    while(here_get_job_status(request_id, app_id, app_code) != 'completed') {
      
      message('Waiting for job completion')
      
      Sys.sleep(5)
      
    }
    
    filename <- here_download_job(request_id, app_id, app_code)
    
    return_df <-
      df_search %>% 
      select(-country) %>% 
      mutate(
        recId = as.numeric(recId)
      ) %>% 
      left_join(
        read.table(filename, header = TRUE, sep = '|') %>% 
          filter(SeqNumber == 1),
        by = 'recId'
      )
    
    file.remove(filename)
    
    return(return_df)
      
    
  }