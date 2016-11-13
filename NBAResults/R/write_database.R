#' Write all database tables
#'
#' Function \code{write_database} writes database containing tables: teams_names,
#' seasons, teams_seasons_statistics, games_story, bets_history.
#'
#' @usage write_database(connection, path = getwd(), clean_up_teams_names = FALSE,
#' clean_up_teams_names = FALSE, clean_up_games_story = FALSE,
#' clean_up_team_season_stats = FALSE, clean_up_bets_history = FALSE)
#'
#' @param connection connection to the database
#' @param path where phantomjs.exe file is contained
#' @param clean_up_teams_names parameter if the teams_names data frame will
#' be removed after adding to the database; default: FALSE
#' @param clean_up_games_story parameter if the games_story data frame will
#' be removed after adding to the database; default: FALSE
#' @param clean_up_team_season_stats parameter if the team_season_stats data
#' frame will be removed after adding to the database; default: FALSE
#' @param clean_up_bets_history parameter if the bets_history data frame will
#' be removed after adding to the database; default: FALSE
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' write_database(connection)
#' }
#'
#' @author Piotr Smuda
#'
#' @export


write_database <- function(connection, path = getwd(), clean_up_teams_names = FALSE,
                           clean_up_games_story = FALSE, clean_up_team_season_stats = FALSE,
                           clean_up_bets_history = FALSE){
   write_teams_names(connection, clean_up_teams_names)
   print("Table teams_names written.")
   write_seasons(connection)
   print("Table seasons written.")
   write_games_story(connection, clean_up_games_story)
   print("Table games_story written.")
   write_teams_seasons_statistics(connection, clean_up_team_season_stats)
   print("Table teams_seasons_statistics written.")
   write_bets_history(connection, path, clean_up_bets_history)
   print("Table bets_history written.")
}
