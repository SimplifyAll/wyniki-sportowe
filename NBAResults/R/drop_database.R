#' Dropping tables
#'
#' Function \code{drop_database} removes all tables from PostgreSQL database.
#'
#' @usage drop_database(connection)
#'
#' @param connection connection to the database
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' drop_database(connection)
#' }
#'
#' @author Kacper Roszczyna, Piotr Smuda
#'
#' @export

drop_database <- function(connection){
  sql_command <- "DROP TABLE IF EXISTS bets_history;"
  dbSendQuery(conn = connection, statement = sql_command)
  sql_command <- "DROP TABLE IF EXISTS games_story;"
  dbSendQuery(conn = connection, statement = sql_command)
  sql_command <- "DROP TABLE IF EXISTS teams_seasons_statistics;"
  dbSendQuery(conn = connection, statement = sql_command)
  sql_command <- "DROP TABLE IF EXISTS seasons;"
  dbSendQuery(conn = connection, statement = sql_command)
  sql_command <- "DROP TABLE IF EXISTS teams_names;"
  dbSendQuery(conn = connection, statement = sql_command)
}
