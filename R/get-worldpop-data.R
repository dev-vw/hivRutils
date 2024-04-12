#' Download constrained or unconstrained gender and age segregated 
#' pop data from World Pop
#'
#' @param start_age int
#' @param end_age int
#' @param iso3 string; ISO3 code of the country to download, lowercase
#' @param destdir string; name of destination directory after data/ (with no end slash "/")
#' @param timeout numeric; defaults to 500 (unconstrained will need 2000+)
#' @param is_constrained logical; defaults to TRUE
#' 
#' @return 
#' @export
#'
#' @examples
#' 
#' This downloads the constrained tifs for South Africa (ages 15-49)
#' download_tifs(15, 45, "zaf", timeout = 1000)
#' 
#' Assumes the following file structure under root project directory:
#' - data/pop-data/<ISO3>-pop/m_pop 
#' - data/pop-data/<ISO3>-pop/f_pop 
download_tifs <- function(start_age, 
                          end_age, 
                          iso3,
                          timeout = 500, 
                          is_constrained = TRUE) {
  # set download timeout for large files, 500 seconds default
  options(timeout = timeout)
  
  ages <- seq(start_age, end_age, by = 5)
  
  destdir <- paste0(iso3, "-pop")
  
  # dest_path <- paste0("data/pop-data/", destdir, "/%s")
  dest_path <- paste0("data/pop-data/", destdir)
  
  if (is_constrained) {
    rooturl <- "https://data.worldpop.org/GIS/AgeSex_structures/Global_2000_2020_Constrained/2020/"
    
    m_fnames <- sapply(ages, function(age) paste0(iso3, "_m_", age, "_2020_constrained.tif"))
    f_fnames <- sapply(ages, function(age) paste0(iso3, "_f_", age, "_2020_constrained.tif"))
    
    fnames <- c(m_fnames, f_fnames)
  } else {
    rooturl <- "https://data.worldpop.org/GIS/AgeSex_structures/Global_2000_2020/2020/"
    
    m_fnames <- sapply(ages, function(age) paste0(iso3, "_m_", age, "_2020.tif"))
    f_fnames <- sapply(ages, function(age) paste0(iso3, "_f_", age, "_2020.tif"))
    
    fnames <- c(m_fnames, f_fnames)
  }
  
  lapply(fnames, function(f) {
    src_f <- sprintf(
      paste0(rooturl,
             toupper(iso3),
             "//%s"),
      f)
    
    if (grepl("_m_", f)) {
      f <- paste0("m_pop/", f)
    } else if (grepl("_f_", f)) {
      f <- paste0("f_pop/", f)
    }
    
    dest_f <- sprintf(paste0(dest_path, "/%s"), f)
    
    file_exists <- grepl(sub(".+//", "", src_f), list.files(dest_path, recursive = TRUE), fixed = TRUE)
    
    if (!any(file_exists)) {
      download.file(src_f, dest_f)
    }
  })
}





