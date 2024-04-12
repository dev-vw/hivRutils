get_naomi_geographies <- function(iso3) {
  f_name <- paste0(iso3, ".geojson")
  
  file_exists <- grepl(f_name, list.files("data/geo-data/geojson/unclean/"), 
                       fixed = TRUE)
  
  if (!any(file_exists)) {
    download.file(paste0("https://naomi2023.azurewebsites.net/api/v1/boundaries?country=",
                         toupper(iso3)), 
                  paste0("data/geo-data/geojson/unclean/",
                         f_name))
  }
}

clean_downloaded_geojsons <- function() {
  geojson_files <- paste0("data/geo-data/geojson/unclean/", 
                          list.files("data/geo-data/geojson/unclean/", 
                                     pattern = "*.geojson$", 
                                     recursive = TRUE))
  
  sapply(geojson_files, function(geojson) {
    print(geojson)
    geojson_string <- readr::read_file(geojson)
    
    i <- regexpr("(?<=unclean/).{3}(?=.geojson)", 
                 geojson, 
                 perl = TRUE)
    
    iso3 <- tolower(substr(geojson, 
                           i, 
                           i + 2))
    
    out_path <- paste0("data/geo-data/geojson/clean/", iso3, ".geojson")
    
    file_exists <- grepl(paste0(iso3, ".geojson"), list.files("data/geo-data/geojson/clean/"), 
                         fixed = TRUE)
    
    if (!any(file_exists)) {
      out_string <- gsub("^.{0,7}", "", 
                         gsub(".{0,1}$", "", geojson_string))
      
      writeLines(out_string, 
                 file(out_path))
      
      close(file(out_path))
    }
  }) 
}
