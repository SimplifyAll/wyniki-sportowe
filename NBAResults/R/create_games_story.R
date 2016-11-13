#' Table with games history
#'
#' Function \code{create_games_story} creates a table containing games history in a PostgreSQL database.
#'
#' @usage create_games_story(connection)
#'
#' @param connection connection to the database
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' create_games_story(connection)
#' }
#'
#' @author Kacper Roszczyna, Dawid Stelmach
#'
#' @export

create_games_story <- function(connection){
  sql_command <- "CREATE TABLE games_story (
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
  dbSendQuery(conn = connection, statement = sql_command)
  sql_command <- "ALTER TABLE games_story
  ADD CONSTRAINT team_1_name_fkey FOREIGN KEY (team_1_id) REFERENCES teams_names(id);"
  dbSendQuery(conn = connection, statement = sql_command)
  sql_command <- "ALTER TABLE games_story
  ADD CONSTRAINT team_2_name_fkey FOREIGN KEY (team_2_id) REFERENCES teams_names(id);"
  dbSendQuery(conn = connection, statement = sql_command)
  sql_command <- "ALTER TABLE games_story
  ADD CONSTRAINT season_fkey FOREIGN KEY (season) REFERENCES seasons(year_start);"
  dbSendQuery(conn = connection, statement = sql_command)
}
