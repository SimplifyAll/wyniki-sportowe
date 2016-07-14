#' Databse connection
#' 
#' Function \code{connect} establishes a connection with a PostgreSQL database
#'
#' @usage connect(dbname, user, password, host, port=5432)
#'
#' @param dbname name of database
#' @param user name of user
#' @param password password of database
#' @param host name of host
#' @param port number of port
#'
#' @return connection to database |||| nie wiem jak to nazwać ||||
#'
#' @example
#' \dontrun{
#' connect(dbname, user, password, host, 5432)}
#'
#' @author XXXXXXXXX
#'
#' @export

connect <- function(dbname, user, password, host, port=5432){
  driver <- dbDriver("PostgreSQL")
  con <- dbConnect(driver, dbname=dbname, 
                   host= host, port=port,
                   user=user, password=password )
  return(con)
}

#connect <- function(){
#  pw <- {
#   "dataScience"
#  }
#  driver <- dbDriver("PostgreSQL")
#  con <- dbConnect(driver, dbname="basketball", 
#                   host= "localhost", port=5432,
#                   user="kndatascience", password=pw )
#  rm(pw)
#  return(con)
#}