#' Adding historical odds to database
#'
#' Function \code{write_bets_history} adds historical odds to the PostgreSQL database.
#'
#' @usage write_bets_history(connection, clean_up = FALSE)
#'
#' @param connection connection to the database
#' @param path where phantomjs.exe file is contained
#' @param clean_up parameter if the data frame will be removed after adding to the database; default: FALSE
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' write_bets_history(connection, getwd(), TRUE)
#' write_bets_history(connection, getwd(), FALSE)
#' }
#'
#' @author Aliaksandr Panimash, Dawid Stelmach, Ania Elsner
#'
#' @export

write_bets_history <- function(connection, path, clean_up = FALSE){
   get_bets_history(connection, path)
   bets_history <- data.frame(id = t(t(c(1:nrow(bets_history)))), bets_history)
   dbWriteTable(connection, "bets_history", value = bets_history, append = TRUE,
               row.names = FALSE)
   if(clean_up){
      rm(bets_history, envir = .GlobalEnv)
   }
}
