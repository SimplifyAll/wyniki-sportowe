#' Create all database tables
#'
#' Function \code{create_database} creates database containing tables: teams_names,
#' seasons, teams_seasons_statistics, games_story, bets_history.
#'
#' @usage create_database(connection)
#'
#' @param connection connection to the database
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' create_database(connection)
#' }
#'
#' @author Kacper Roszczyna, Dawid Stelmach, Piotr Smuda
#'
#' @export


create_database <- function(connection){
  create_teams_names(connection = connection)
  create_seasons(connection = connection)
  create_teams_seasons_statistics(connection = connection)
  create_games_story(connection = connection)
  create_bets_history(connection = connection)
}
