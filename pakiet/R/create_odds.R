#' Table with odds
#' 
#' Function \code{create_odds} creates a table containing odds in a PostgreSQL database.
#'
#' @usage create_odds(connection)
#'
#' @param connection connection to the database
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' create_odds(connection)}
#'
#' @author Kacper Roszczyna, Dawid Stlemach, Ania Elsner
#'
#' @export
#' 
create_bets <-function(connection){
  sql_command <- "CREATE TABLE odds (
  team_1_id           varchar(4) NOT NULL,
  team_2_id           varchar(4) NOT NULL,
  game_date           date,
  team_1_score        integer,
  team_2_score        integer,
  team_1_odds         integer,
  team_2_odds         integer,
  season              varchar(4) NOT NULL,
  game_id             integer,
  CONSTRAINT odds_pk PRIMARY KEY (game_id)
  )
  WITH (
  OIDS=FALSE
  );"
  dbSendQuery(conn=connection, statement = sql_command)
  sql_command <- "ALTER TABLE odds
  ADD CONSTRAINT game_id_fkey FOREIGN KEY (game_id) REFERENCES games(id);"
  dbSendQuery(conn=connection, statement = sql_command)
}
