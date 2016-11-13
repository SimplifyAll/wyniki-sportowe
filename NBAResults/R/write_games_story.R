#' Adding games story to database
#'
#' Function \code{write_games_story} adds games story to the PostgreSQL database.
#'
#' @usage write_games_story(connection, clean_up = FALSE)
#'
#' @param connection connection to the database
#' @param clean_up parameter if the data frame will be removed after adding to the database; default: FALSE
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' write_games_story(connection, TRUE)
#' write_games_story(connection, FALSE)
#' }
#'
#' @author Aliaksandr Panimash, Dawid Stelmach
#'
#' @export

write_games_story <- function(connection, clean_up = FALSE){
   get_games_story(connection)
   games_story <- data.frame(id = t(t(c(1:nrow(games_story)))), games_story)
   dbWriteTable(connection, "games_story", value = games_story, append = TRUE,
               row.names = FALSE)
   if(clean_up){
      rm(games_story, envir = .GlobalEnv)
   }
}
