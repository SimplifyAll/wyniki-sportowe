#' Table with bets
#' 
#' Function \code{create_bets} creates a table containing bets in a PostgreSQL database.
#'
#' @usage create_bets(connection)
#'
#' @param connection connection to the database
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' create_bets(connection)}
#'
#' @author XXXXXXXXX
#'
#' @export
#' 
create_bets <-function(connection){
  sql_command <- "CREATE TABLE bets (
  team_1_chances      integer,
  team_2_chances      integer,
  bet_time            timestamp,
  bet_firm            varchar(64),
  game_id             integer,
  CONSTRAINT bets_pk PRIMARY KEY (game_id, bet_firm, bet_time)
  )
  WITH (
  OIDS=FALSE
  );"
  dbSendQuery(conn=connection, statement = sql_command)
  sql_command <- "ALTER TABLE bets
  ADD CONSTRAINT game_id_fkey FOREIGN KEY (game_id) REFERENCES games(id);"
  dbSendQuery(conn=connection, statement = sql_command)
  sql_command <- "ALTER TABLE bets
  ADD CONSTRAINT bet_firm_fkey FOREIGN KEY (bet_firm) REFERENCES betting_firms(name);"
  dbSendQuery(conn=connection, statement = sql_command)
}
