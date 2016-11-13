#' Table with bets
#'
#' Function \code{create_bets_history} creates a table containing bets in a PostgreSQL database.
#'
#' @usage create_bets_history(connection)
#'
#' @param connection connection to the database
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' create_bets_history(connection)}
#'
#' @author Kacper Roszczyna, Dawid Stelmach, Ania Elsner
#'
#' @export

create_bets_history <-function(connection){
  sql_command <- "CREATE TABLE bets_history (
  id                  integer,
  team_1_id           varchar(4) NOT NULL,
  team_2_id           varchar(4) NOT NULL,
  game_date           varchar(15),
  team_1_score        integer,
  team_2_score        integer,
  team_1_bets         real,
  team_2_bets         real,
  season              varchar(4) NOT NULL,
  CONSTRAINT bets_pk PRIMARY KEY (id)
  )
  WITH (
  OIDS=FALSE
  );"
  dbSendQuery(conn = connection, statement = sql_command)
  # sql_command <- "ALTER TABLE bets_history
  # ADD CONSTRAINT game_id_fkey FOREIGN KEY (id) REFERENCES games_story(id);"
  # dbSendQuery(conn = connection, statement = sql_command)
}
