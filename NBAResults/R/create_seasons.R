#' Table with seasons
#'
#' Function \code{create_seasons} creates a table containing seasons in a PostgreSQL database.
#'
#' @usage create_seasons(connection)
#'
#' @param connection connection to the database
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' create_seasons(connection)
#' }
#'
#' @author Kacper Roszczyna, Dawid Stelmach
#'
#' @export
#'
create_seasons <- function(connection){
  sql_command <- "CREATE TABLE seasons (
  year_start varchar(4),
  CONSTRAINT seasons_pk PRIMARY KEY (year_start)
  )
  WITH (
  OIDS=FALSE
  );"
  dbSendQuery(conn = connection, statement = sql_command)
}
