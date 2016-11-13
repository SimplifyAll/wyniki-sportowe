#' Database connection
#'
#' Function \code{connect_database} establishes a connection with a PostgreSQL database.
#'
#' @usage connect_database(dbname, host = 'services.mini.pw.edu.pl', port = 15432,
#' user, password)
#'
#' @param dbname name of database
#' @param host name of host; default: 'services.mini.pw.edu.pl'
#' @param port number of port; default: 15432
#' @param user name of user
#' @param password password of database
#'
#' @return connection to database
#'
#' @examples
#' \dontrun{
#' connect_database(dbname, 'services.mini.pw.edu.pl', 15432, user, password)
#' }
#'
#' @author Kacper Roszczyna, Dawid Stlemach
#'
#' @export

connect_database <- function(dbname, host = 'services.mini.pw.edu.pl',
                             port = 15432, user, password){
   driver <- dbDriver("PostgreSQL")
   con <- dbConnect(driver, dbname = dbname,
                   host = host, port = port,
                   user = user, password = password)
   return(con)
}
