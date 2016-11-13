#' Table with games history
#' 
#' Function \code{create_games} creates a table containing games history in a PostgreSQL database.
#'
#' @usage create_games(connection)
#'
#' @param connection connection to the database
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' create_games(connection)}
#'
#' @author Kacper Roszczyna Dawid Stlemach
#'
#' @export

create_games <- function(connection){
  sql_command <- "CREATE TABLE games (
  id                        integer,
  team_1_id                 varchar(4) NOT NULL,
  team_2_id                 varchar(4) NOT NULL,
  game_date                 date,
  team_1_score              integer,
  team_2_score              integer,
  if_win                    integer,
  season                    varchar(4) NOT NULL,
  CONSTRAINT games_pk PRIMARY KEY (id)
  )
  WITH (
  OIDS=FALSE
  );"
  dbSendQuery(conn=connection, statement = sql_command)
  sql_command <- "ALTER TABLE games
  ADD CONSTRAINT team_1_name_fkey FOREIGN KEY (team_1_id) REFERENCES teams(id);"
  dbSendQuery(conn=connection, statement = sql_command)
  sql_command <- "ALTER TABLE games
  ADD CONSTRAINT team_2_name_fkey FOREIGN KEY (team_2_id) REFERENCES teams(id);"
  dbSendQuery(conn=connection, statement = sql_command)
  sql_command <- "ALTER TABLE games
  ADD CONSTRAINT season_fkey FOREIGN KEY (season) REFERENCES seasons(yearStart);"
  dbSendQuery(conn=connection, statement = sql_command)
}