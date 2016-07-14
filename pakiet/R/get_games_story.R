#' Data frame with games history
#' 
#' Function \code{get_games_story} downloads game statistics from the basketball-reference.com website
#' and creates data frame with them for all NBA teams.
#' Data frame contains games history from 2011 to 2015.
#'
#' @usage get_games_story()
#'
#' @param
#'
#' @return ?????NULL????? TODO
#'
#' @example
#' \dontrun{
#' get_games_story()}
#'
#' @author XXXXXXXXX
#'
#' @export



get_games_story <- function()
{
  
  team_names <- get_team_names()
  
  team_story <- lapply(team_names$name, function (x) x=data.frame()) 
  names(team_story) <- team_names$name
  
  for ( i in 1:6)
  {
    year <- paste0("201", i)
    
    for(j in 1:length(team_names$shortcut)) 
    {
      team_names_tmp <- team_names$shortcut[j]
      if((i==1 | i==2) & j==3)
      {
        team_names_tmp <- "NJN"
      }
      if((i==1 | i==2 | i==3 | i==4) & j==4)
      {
        team_names_tmp <- "CHA"
      }
      if((i==1| i==2 | i==3) & j==19)
      {
        team_names_tmp <-"NOH"
      }
      
      html <- paste0( "http://www.basketball-reference.com/teams/", team_names_tmp, "/", year, "_games.html")
      URL <- getURL(html)
      team_story_tmp <- readHTMLTable(URL, h=T)
      team_story_tmp <- team_story_tmp$teams_games 
      nazwy <- names(team_story_tmp) 
      name <-c("G", "Date", "Time", "Box Score" , "", "Where", "Opponent", "Result",  "",
               "Tm", "Opp", "W", "L", "Streak" , "Notes" ) 
      names(team_story_tmp) <- name
      
      team_story_tmp <- data.frame(Opponent=team_story_tmp$Opponent, Date=team_story_tmp$Date, Tm=team_story_tmp$Tm,
                                   Opp=team_story_tmp$Opp, L=team_story_tmp$L, Result=team_story_tmp$Result,
                                   Where=team_story_tmp$Where, Year=year)
      team_story_tmp <- team_story_tmp[-c(21, 42, 63, 84),] 
      team_story[[j]]=rbind(team_story[[j]], team_story_tmp) 
    }
  }
  
  
  
  games_story <- data.frame()
  
  for(i in 1:(length(team_story)-1)) 
  {                                
    
    Host <- names(team_story[i])
    games_story_tmp <- data.frame(cbind(Host, as.data.frame(team_story[[i]])))
    
    Host_tmp <- ifelse(games_story_tmp$Where == "@", as.vector(games_story_tmp$Opponent), as.vector(games_story_tmp$Host))
    Opponent_tmp <- ifelse(games_story_tmp$Where == "@", as.vector(Host), as.vector(games_story_tmp$Opponent))
    
    Tm_tmp <- ifelse(games_story_tmp$Where == "@", as.vector(games_story_tmp$Opp), as.vector(games_story_tmp$Tm))
    Opp_tmp <- ifelse(games_story_tmp$Where == "@", as.vector(games_story_tmp$Tm), as.vector(games_story_tmp$Opp))
   
    games_story_tmp$Host <- Host_tmp
    games_story_tmp$Opponent <- Opponent_tmp
    games_story_tmp$Tm <- Tm_tmp
    games_story_tmp$Opp <- Opp_tmp 
    games_story_tmp$Result <- ifelse(as.numeric(games_story_tmp$Tm) > as.numeric(games_story_tmp$Opp), 1, 0)
    
    games_story <- rbind(games_story, games_story_tmp[, -8])
  }
  
  
  games_story[games_story$Host == "New Jersey Nets", 1] <- "Brooklyn Nets"
  games_story[games_story$Host == "Charlotte Bobcats", 1] <- "Charlotte Hornets"
  games_story[games_story$Host == "New Orleans Hornets", 1] <- "New Orleans Pelicans"
  
  games_story[games_story$Opponent == "New Jersey Nets", 2] <- "Brooklyn Nets"
  games_story[games_story$Opponent == "Charlotte Bobcats", 2] <- "Charlotte Hornets"
  games_story[games_story$Opponent == "New Orleans Hornets", 2] <- "New Orleans Pelicans"
  
  # Changing names for shortcuts
  Host <- unlist(sapply(games_story$Host, function(x) team_names[team_names$name==x,2]))
  names(Host)=NULL
  games_story$Host=as.vector(Host)
  
  Opponent_tmp=unlist(sapply(games_story$Opponent, function(x) team_names[team_names$name==x, 2]))
  names(Opponent_tmp)=NULL
  games_story$Opponent=as.vector(Opponent_tmp)
  

  games_story=games_story[order(games_story$Year), -6]
  
 
  games_story <- games_story[!duplicated(games_story), ]
  
  
  assign( "games_story" , games_story , env = .GlobalEnv )
}
