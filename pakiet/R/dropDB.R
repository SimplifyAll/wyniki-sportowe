#' Droping tables
#' 
#' Function \code{dropDB} removes all tables from PostgreSQL database.
#'
#' @usage dropDB(connection)
#'
#' @param connection connection to the database
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' dropDB(connection)}
#'
#' @author XXXXXXXXX
#'
#' @export

dropDB <- function(connection){
  sql_command <- "DROP TABLE IF EXISTS bets;"
  dbSendQuery(conn=connection, statement=sql_command)
  sql_command <- "DROP TABLE IF EXISTS betting_firms;"
  dbSendQuery(conn=connection, statement=sql_command)
  sql_command <- "DROP TABLE IF EXISTS games;"
  dbSendQuery(conn=connection, statement=sql_command)
  sql_command <- "DROP TABLE IF EXISTS team_season_statistics;"
  dbSendQuery(conn=connection, statement=sql_command)
  sql_command <- "DROP TABLE IF EXISTS seasons;"
  dbSendQuery(conn=connection, statement=sql_command)
  sql_command <- "DROP TABLE IF EXISTS teams;"
  dbSendQuery(conn=connection, statement=sql_command)
}
