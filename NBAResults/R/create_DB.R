#' Create all database tables
#'
#' Function \code{create_DB} creates database containing tables: betting_firms, teams, seasons,
#' team_season_statistics, games, bets.
#' 
#' @usage create_DB(connection)
#'
#' @param connection connection to the database
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' create_DB(connection)}
#'
#' @author Kacper Roszczyna Dawid Stlemach
#'
#' @export


create_DB <- function(connection){
  create_betting_firms(connection = connection)
  create_teams(connection = connection)
  create_seasons(connection = connection)
  create_team_season_statistics(connection = connection)
  create_games(connection = connection)
  create_bets(connection = connection)
}
