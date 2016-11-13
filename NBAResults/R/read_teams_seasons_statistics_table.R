#' Read teams_seasons_statistics table from database
#'
#' Function \code{read_teams_seasons_statistics_table} read teams_seasons_statistics
#' data frame with all NBA teams seasons statistics from seasons in seasons table.
#'
#' @usage read_teams_seasons_statistics_table(connection)
#'
#' @param connection connection to the database
#'
#' @return data.frame
#'
#' @examples
#' \dontrun{
#' read_teams_seasons_statistics_table(connection)
#' }
#'
#' @author Piotr Smuda
#'
#' @export

read_teams_seasons_statistics_table <- function(connection){
   teams_seasons_statistics <- dbReadTable(connection, "teams_seasons_statistics")
   invisible(teams_seasons_statistics)
}
