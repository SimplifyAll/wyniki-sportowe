#' Adding historical odds to database
#'
#' Function \code{write_odds} adds historical odds to the PostgreSQL database.
#'
#' @usage write_odds(connection, cleanUp)
#'
#' @param connection connection to the database
#' @param cleanUP parameter if the data frame will be removed after adding to the database
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' write_odds(connection, 1),
#' write_odds(connection, 0)}
#'
#' @author Aliaksandr Panimash, Dawid Stelmach, Ania Elsner
#'
#' @export

write_odds <- function(connection, cleanUp){
  get_odds()
  odds_history <- data.frame(id=t(t(c(1:nrow(odds_history)))),odds_history)
  dbWriteTable(connection, "odds", value = odds_history, append = TRUE, row.names = FALSE)
  if(cleanUp)
    rm(odds_history)
}
