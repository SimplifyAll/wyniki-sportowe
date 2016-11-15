#' Read all database tables
#'
#' Function \code{read_database} reads all database tables: teams_names,
#' seasons, teams_seasons_statistics, games_story, bets_history.
#'
#' @usage read_database(connection)
#'
#' @param connection connection to the database
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' read_database(connection)
#' }
#'
#' @author Piotr Smuda
#'
#' @export


read_database <- function(connection){
   assign("teams_names", read_teams_names_table(connection), env = .GlobalEnv)
   assign("seasons", read_seasons_table(connection), env = .GlobalEnv)
   assign("games_story", read_games_story_table(connection), env = .GlobalEnv)
   assign("teams_seasons_statistics", read_teams_seasons_statistics_table(connection),
          env = .GlobalEnv)
   assign("bets_history", read_bets_history_table(connection), env = .GlobalEnv)
}
