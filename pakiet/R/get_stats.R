#' Data frame with team statistics
#' 
#' Function \code{get_stats} downloads team statistics from the basketball-reference.com website
#' and creates data frame with them for all NBA teams.
#' Data frame contains statistics from 2011 to 2016.
#'
#' @usage get_stats()
#'
#' @param
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' get_stats()}
#'
#' @author XXXXXXXXX
#'
#' @export


get_stats<- function()
{
  

  team_stats <- data.frame(matrix(numeric(0),ncol=26)) 
  opponent_stats <- data.frame(matrix(numeric(0),ncol=26))
  miscellaneous_stats <- data.frame(matrix(numeric(0),ncol=26))
  
  
  for ( i in 1:6)    
  {
    
    Year=paste0("201",i) 
    html <- paste0("http://www.basketball-reference.com/leagues/NBA_",Year,".html")
    URL<-getURL(html)
    tables <- readHTMLTable(URL,h=T)
    
    
    team_tmp <- tables$team  
    team_tmp$Team <- gsub('\\*', '',team_tmp$Team)  
    team_tmp <- cbind(team_tmp,Year)  
    team_tmp <- team_tmp[1:30,2:27] 
   
    nazwy <- names(team_tmp) 
    names(team_stats) <- nazwy
    team_stats <- rbind(team_stats,team_tmp) 
    
    
    opponent_tmp <- tables$opponent
    opponent_tmp$Team <- gsub('\\*', '',opponent_tmp$Team)
    opponent_tmp <- cbind(opponent_tmp,Year) 
    opponent_tmp <- opponent_tmp[1:30,2:27]
    nazwy <- names(opponent_tmp)
    names(opponent_stats) <- nazwy
    opponent_stats <- rbind(opponent_stats,opponent_tmp)
    
    miscellaneous_tmp <- tables$misc
    miscellaneous_tmp$Team <- gsub('\\*', '',miscellaneous_tmp$Team)
    miscellaneous_tmp <- cbind(miscellaneous_tmp,Year) 
    miscellaneous_tmp <- miscellaneous_tmp[1:30,2:25]
    nazwy <- names(miscellaneous_tmp)
    names(miscellaneous_stats) <- nazwy
    miscellaneous_stats <- rbind(miscellaneous_stats,miscellaneous_tmp)
    
  }
  
 
  team_stats  <- team_stats[order(team_stats$Team,team_stats$Year),]
  opponent_stats <- opponent_stats[order(opponent_stats$Team,opponent_stats$Year),]
  miscellaneous_stats <- miscellaneous_stats[order(miscellaneous_stats$Team,miscellaneous_stats$Year),]
  
  stats <- cbind(team_stats[1:25],opponent_stats[4:25],miscellaneous_stats[2:24])
  
  stats$Team[stats$Team == "Charlotte Hornets"] <- "Charlotte Bobcats"
  stats$Team[stats$Team == "New Jersey Nets"] <- "Brooklyn Nets"
  stats$Team[stats$Team == "New Orleans Pelicans"] <- "New Orleans Hornets"
  stats <- stats[order(stats$Team,stats$Year),]
  

  colnames(stats)[26:47] <- paste0("O",names(stats[26:47]))
  
  
  stats$Team<-sapply(stats$Team, function(x) team_names[team_names$name==x,2])
  
  for (k in 1:length(names(stats)))
  {
    tmp <- names(stats)[k]
    if(!is.na(stri_extract_all_regex(tmp,"(.)+%$")==tmp) 
       | tmp=="FT/FGA" | tmp== "eFG%.1" | tmp =="FT/FGA.1")
      stats[,names(stats)==tmp]<- as.numeric(as.character(stats[,names(stats)==tmp])) 
  }
  stats$Team = as.character(stats$Team)
  stats$Team[16:20] = "CHO"
  stats$Team[91:95] = "NOP"
  stats$Attendance = as.numeric(gsub(",", "", stats$Attendance))
  
 
  assign( "stats" , stats , env = .GlobalEnv )
}