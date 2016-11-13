#' Adding team names to database
#'
#' Function \code{write_teams_names} adds team names to the PostgreSQL database.
#'
#' @usage write_teams_names(connection, clean_up = FALSE)
#'
#' @param connection connection to the database
#' @param clean_up parameter if the data frame will be removed after adding to the database; default: FALSE
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' write_teams_names(connection, TRUE)
#' write_teams_names(connection, FALSE)
#' }
#'
#' @author Aliaksandr Panimash, Dawid Stelmach
#'
#' @export

write_teams_names <- function(connection, clean_up = FALSE){
   get_teams_names()
   dbWriteTable(connection, "teams_names", value = teams_names, append = TRUE,
                row.names = FALSE)
   if(clean_up){
      rm(teams_names, envir = .GlobalEnv)
   }
}
