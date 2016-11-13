#' Read games_story table from database
#'
#' Function \code{read_games_story_table} read games_story data frame with all
#' story of NBA teams games from seasons in seasons table.
#'
#' @usage read_games_story_table(connection)
#'
#' @param connection connection to the database
#'
#' @return data.frame
#'
#' @examples
#' \dontrun{
#' read_games_story_table(connection)
#' }
#'
#' @author Piotr Smuda
#'
#' @export

read_games_story_table <- function(connection){
   games_story <- dbReadTable(connection, "games_story")
   invisible(games_story)
}
