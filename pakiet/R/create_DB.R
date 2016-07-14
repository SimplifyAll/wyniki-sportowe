#' Create all database tables
#'
#' Function \code{create_DB} creates database containint tables:create_betting_firms,create_teams,create_seasons,
#' create_team_season_statistics,create_games,create_bets
#' 
#' @usage create_DB(connection)
#'
#' @param connection connection to the database.
#'
#' @return 
#'
#' @example
#' \dontrun{
#' create_DB(connection)}
#'
#' @author XXXXXXXXX
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
