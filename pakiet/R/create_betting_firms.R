#' Table with betting firms
#' 
#' Function \code{create_betting_firms} creates a table containing betting firms in a PostgreSQL database.
#'
#' @usage create_betting_firms(connection)
#'
#' @param connection connection to the database
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' create_betting_firms(connection)}
#'
#' @author XXXXXXXXX
#'
#' @export

create_betting_firms <- function(connection){
  sql_command <- "CREATE TABLE betting_firms (
  name varchar(64),
  CONSTRAINT betting_firms_pk PRIMARY KEY (name)
  )
  WITH (
  OIDS=FALSE
  );"
  dbSendQuery(conn = connection, statement = sql_command)
}
