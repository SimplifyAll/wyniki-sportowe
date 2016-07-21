#' Adding team names to database
#'
#' Function \code{write_teams} adds team names to the PostgreSQL database.
#'
#' @usage write_teams(connection, cleanUp)
#'
#' @param connection connection to the database
#' @param cleanUP parameter if the data frame will be removed after adding to the database
#'
#' @return ?????NULL????? TODO
#'
#' @example
#' \dontrun{
#' write_teams(connection, 1),
#' write_teams(connection, 0)}
#'
#' @author XXXXXXXXX
#'
#' @export

write_teams <- function(connection, cleanUp){
  get_team_names()
  dbWriteTable(connection, "teams", 
               value = team_names, append = TRUE, row.names = FALSE)
  if(cleanUp)
    rm(team_names)
}
