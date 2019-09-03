here_get_job_status <-
  function(job_id, app_id, app_code) {
    
    url <-
      paste0("https://batch.geocoder.api.here.com/6.2/jobs/",
             job_id,
             "?action=status",
             "&app_code=", app_code,
             "&app_id=", app_id)
    
    status <-
      httr::GET(url) %>% 
      httr::content() %>% 
      .$Response %>% 
      .$Status
    
    return(status)
    
  }
