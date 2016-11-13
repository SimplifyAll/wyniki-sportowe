#' Read teams_names table from database
#'
#' Function \code{read_teams_names_table} read teams_names data frame with all
#' NBA team names and their abbreviation.
#'
#' @usage read_teams_names_table(connection)
#'
#' @param connection connection to the database
#'
#' @return data.frame
#'
#' @examples
#' \dontrun{
#' read_teams_names_table(connection)
#' }
#'
#' @author Piotr Smuda
#'
#' @export

read_teams_names_table <- function(connection){
   teams_names <- dbReadTable(connection, "teams_names")
   invisible(teams_names)
}
