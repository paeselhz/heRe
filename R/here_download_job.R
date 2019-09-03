here_download_job <-
  function(job_id, app_id, app_code) {
    
    url <-
      paste0(
        "https://batch.geocoder.api.here.com/6.2/jobs/",
        job_id, "/result",
        "?app_id=", app_id,
        "&app_code=", app_code
      )
    
    download.file(url, destfile = 'temp.zip', method = 'curl')
    
    zip::unzip('temp.zip')
    
    file.remove('temp.zip')
    
    return(
      list.files(
        path = '.',
        pattern = 'result+.*\\.txt'
      )
    )
    
    
  }
