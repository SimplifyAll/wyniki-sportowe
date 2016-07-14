#' Table with seasons
#' 
#' Function \code{create_seasons} creates a table containing seasons in a PostgreSQL database
#'
#' @usage create_seasons(connection)
#'
#' @param connection connection to the database.
#'
#' @return ?????NULL????? TODO
#'
#' @example
#' \dontrun{
#' create_seasons(connection)}
#'
#' @author XXXXXXXXX
#'
#' @export
#' 
create_seasons <- function(connection) {
  sql_command <- "CREATE TABLE seasons (
  yearStart varchar(4),
  CONSTRAINT seasons_pk PRIMARY KEY (yearStart)
  )
  WITH (
  OIDS=FALSE
  );"
  dbSendQuery(conn=connection, statement = sql_command)
}
