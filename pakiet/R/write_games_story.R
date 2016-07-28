#' Adding games story to database
#'
#' Function \code{write_games_story} adds games story to the PostgreSQL database.
#'
#' @usage write_games_story(connection, cleanUp)
#'
#' @param connection connection to the database
#' @param cleanUP parameter if the data frame will be removed after adding to the database
#'
#' @return NULL
#'
#' @example
#' \dontrun{
#' write_games_story(connection, 1),
#' write_games_story(connection, 0)}
#'
#' @author Aliaksandr Panimash, Dawid Stelmach
#'
#' @export

write_games_story <- function(connection, cleanUp){
  write_games_story()
  games_story <- data.frame(id=t(t(c(1:nrow(games_story)))),games_story)
  dbWriteTable(connection, "games", value = games_story, append = TRUE, row.names = FALSE)
  if(cleanUp)
    rm(games_story)
}
