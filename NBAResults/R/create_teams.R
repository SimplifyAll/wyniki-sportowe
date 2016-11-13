#' Table with teams
#' 
#' Function \code{create_teams} creates a table containing teams in a PostgreSQL database.
#'
#' @usage create_teams(connection)
#'
#' @param connection connection to the database
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' create_teams(connection)}
#'
#' @author Kacper Roszczyna Dawid Stlemach
#'
#' @export

create_teams <- function(connection){
  sql_command <- "CREATE TABLE teams (
  current_name  varchar(30),
  id            varchar(4) NOT NULL,
  change_year   varchar(4),
  previous_name varchar(30),
  previous_abr  varchar(8),
  CONSTRAINT teams_pk PRIMARY KEY (id)
  )
  WITH (
  OIDS=FALSE
  );"
  dbSendQuery(conn=connection, statement = sql_command)
}