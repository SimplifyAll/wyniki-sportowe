#' Adding team statistics to database
#'
#' Function \code{write_teams_seasons_statistics} adds team season statistics to the PostgreSQL database.
#'
#' @usage write_teams_seasons_statistics(connection, clean_up = FALSE)
#'
#' @param connection connection to the database
#' @param clean_up parameter if the data frame will be removed after adding to the database; default: FALSE
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' write_teams_seasons_statistics(connection, TRUE)
#' write_teams_seasons_statistics(connection, FALSE)
#' }
#'
#' @author Aliaksandr Panimash, Dawid Stelmach
#'
#' @export

write_teams_seasons_statistics <- function(connection, clean_up = FALSE){
   get_teams_seasons_statistics(connection)
   dbWriteTable(connection, "teams_seasons_statistics", value = teams_seasons_statistics,
                append = TRUE, row.names = FALSE)
   if(clean_up){
      rm(teams_seasons_statistics, envir = .GlobalEnv)
   }
}
