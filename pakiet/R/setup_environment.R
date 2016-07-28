#' Set up the environment
#' 
#' Function \code{setup_environment} sets up whole work environment on PostgreSQL database.
#'
#' @usage setup_environment()
#'
#' @param
#'
#' @return NULL
#'
#' @example
#' \dontrun{
#' setup_environment()}
#'
#' @author Kacper Roszczyna
#'
#' @export

setup_environment <- function(){
  con = setup_environment()
  print("Created Connection")
  create_DB(connection = con)
  print("Database Constructed")
  write_teams(connection = con, FALSE)
  print("Teams inserted")
  write_seasons(connection = con)
  print("Seasons inserted")
  write_games_story(connection = con, FALSE)
  print("Games inserted")
  write_team_season_stats(connection = con, FALSE)
  print("Statistics Inserted")
  disconnect(connection = con)
  print("Setup Finished disconnecting from DB")
}

