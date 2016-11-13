#' Adding seasons to database
#'
#' Function \code{write_seasons} adds seasons to the PostgreSQL database.
#'
#' @usage write_seasons(connection)
#'
#' @param connection connection to the database
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' write_seasons(connection)
#' }
#'
#' @author Aliaksandr Panimash, Dawid Stelmach
#'
#' @export


write_seasons <- function(connection){
   dbWriteTable(connection, "seasons",
               value = data.frame(season = as.character(c(2011:2016))),
               append = TRUE, row.names = FALSE)
}
