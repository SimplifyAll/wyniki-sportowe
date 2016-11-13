#' Read seasons table from database
#'
#' Function \code{read_seasons_table} read seasons data frame with seasons years.
#'
#' @usage read_seasons_table(connection)
#'
#' @param connection connection to the database
#'
#' @return data.frame
#'
#' @examples
#' \dontrun{
#' read_seasons_table(connection)
#' }
#'
#' @author Piotr Smuda
#'
#' @export

read_seasons_table <- function(connection){
   seasons <- dbReadTable(connection, "seasons")
   invisible(seasons)
}
