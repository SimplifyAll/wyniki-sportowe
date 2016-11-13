#' Read bets_history table from database
#'
#' Function \code{read_bets_history_table} read bets_history data frame with all
#' all best of NBA teams games from seasons in seasons table.
#'
#' @usage read_bets_history_table(connection)
#'
#' @param connection connection to the database
#'
#' @return data.frame
#'
#' @examples
#' \dontrun{
#' read_bets_history_table(connection)
#' }
#'
#' @author Piotr Smuda
#'
#' @export

read_bets_history_table <- function(connection){
   bets_history <- dbReadTable(connection, "bets_history")
   invisible(bets_history)
}
