#' Addig team statistics to database
#'
#' Function \code{write_team_season_stats} adds team season statistics to the PostgreSQL database.
#'
#' @usage write_team_season_stats(connection, cleanUp)
#'
#' @param connection connection to the database.
#' @param cleanUP parameter if the data frame will be removed after adding to the database
#'
#' @return ?????NULL????? TODO
#'
#' @example
#' \dontrun{
#' write_team_season_stats(connection, 1),
#' write_team_season_stats(connection, 0)}
#'
#' @author XXXXXXXXX
#'
#' @export

write_team_season_stats <- function(connection, cleanUp){
  get_stats()
  dbWriteTable(connection, "team_season_statistics", value = stats, append = TRUE, row.names = FALSE)
  if(cleanUp)
    rm(stats)
}
