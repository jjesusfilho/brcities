#' Get state, cities and regions demographics from Sao Paulo.
#'
#' @param year vector with years you want to get the data
#' @param place  code, according to place data.
#' @param variable variable code according to variable data.
#'
#' @return a data frame with place code, place name, parent place,variable code,
#'      variable name, period that the data is available, unity, year, and variable name.
#'
#' @details all codes for the places and indicators (variables) are available at `sp_place`
#'      dataset. You can provide more than one year, place or variable. If you want
#'      either all years, all places or all variables, you can put "0" to one, and only
#'      one, of the three arguments.
#' @export
#'
#' @examples
#'
#' sp_indicators(2016:2017,place=1,variable=55)
#'
sp_indicators<-function(year,place,variable){

  purrr::pmap_dfr(list(a=place,b=variable,c=year),function(a,b,c) {

    jsonlite::fromJSON(paste0("http://api-imp.seade.gov.br/v1/dados/",a,"/",b,"/",c),flatten=TRUE) %>%
      magrittr::extract2(1) %>%
      dplyr::mutate(pop=readr::parse_number(.[[8]],
                                            locale=readr::locale("pt",decimal_mark = ",")),
                    ano=names(.)[8] %>%
                      stringr::str_replace("\\D*","")
      ) %>%
      dplyr::select(-8)
  })
}
