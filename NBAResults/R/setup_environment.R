#' Set up the environment
#'
#' Function \code{setup_environment} sets up whole work environment on PostgreSQL database.
#'
#' @usage setup_environment(dbname, host = 'services.mini.pw.edu.pl', port = 15432,
#' user, password, path, clean_up_teams_names = FALSE, clean_up_games_story = FALSE,
#' clean_up_team_season_stats = FALSE, clean_up_bets_history = FALSE)
#'
#' @param dbname name of database
#' @param host name of host; default: 'services.mini.pw.edu.pl'
#' @param port number of port; default: 15432
#' @param user name of user
#' @param password password of database
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
#' setup_environment(dbname, host, port, user, password, path)
#' }
#'
#' @author Kacper Roszczyna, Piotr Smuda
#'
#' @export

setup_environment <- function(dbname, host = 'services.mini.pw.edu.pl', port = 15432,
                              user, password, path, clean_up_teams_names = FALSE,
                              clean_up_games_story = FALSE, clean_up_team_season_stats = FALSE,
                              clean_up_bets_history = FALSE){
   con <- dbConnect(dbDriver("PostgreSQL"), dbname = dbname, host = host, port = port,
                    user = user, password = password)
   print("Created connection.")
   create_database(con)
   print("Database constructed.")
   write_database(con, path, clean_up_teams_names, clean_up_games_story,
                  clean_up_team_season_stats, clean_up_bets_history)
   print("Database written.")
   disconnect_database(con)
   print("Setup finished. Disconnecting from database.")
}
