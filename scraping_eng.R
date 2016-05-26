#Required libraries
library(rvest)
library(XML)
library(RCurl)
library(stringi)

#############################################################################################################################
# Below we have a function get_team_names. It creates a data frame called team_names which contains all data about the names of NBA
# teams, shortcuts and history of changes from 2009

get_team_names <- function(){
    
    # Here we create this data frame. It has 30 rows, each row relate to one team, and 5 columns which are referring
    # to the names and the shortcuts.
    team_names <- data.frame(name=rep("a",30), shortcut=rep('a',30), change_year=rep(NA,30), previous_name=rep(NA,30),
                             previous_shortcut=rep('a',30))
    
    # Names of the teams
    team_names$name <- c("Atlanta Hawks", "Boston Celtics", "Brooklyn Nets", "Charlotte Hornets", "Chicago Bulls",
                          "Cleveland Cavaliers", "Dallas Mavericks", "Denver Nuggets", "Detroit Pistons",
                          "Golden State Warriors", "Houston Rockets", "Indiana Pacers", "Los Angeles Clippers",
                          "Los Angeles Lakers", "Memphis Grizzlies", "Miami Heat", "Milwaukee Bucks",
                          "Minnesota Timberwolves", "New Orleans Pelicans", "New York Knicks", "Oklahoma City Thunder",
                          "Orlando Magic", "Philadelphia 76ers", "Phoenix Suns", "Portland Trail Blazers",
                          "Sacramento Kings", "San Antonio Spurs", "Toronto Raptors", "Utah Jazz", "Washington Wizards")
    # Shortcuts of the names
    team_names$shortcut <- c("ATL", "BOS", "BRK", "CHO", "CHI", "CLE", "DAL", "DEN", "DET", "GSW", "HOU", "IND", "LAC",
                          "LAL", "MEM", "MIA", "MIL", "MIN", "NOP", "NYK", "OKC", "ORL", "PHI", "PHO", "POR", "SAC",
                          "SAS", "TOR", "UTA", "WAS")
    # If there was a different name (only after 2009) we write a year of change, if not we have NA
    team_names$change_year <- c(NA, NA, 2013, 2015, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 2014,
                              NA, 2009, NA, NA, NA, NA, NA, NA, NA, NA, NA)
    # The same as a previous column but this one refers to the shortcuts
    team_names$previous_shortcut <- c(NA, NA, "NJN", "CHA", NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                                  "NOH", NA, "SEA", NA, NA, NA, NA, NA, NA, NA, NA, NA)
    # Also the same, but refers to the names
    team_names$previous_name <- c(NA, NA, "New Jersey Nets", "Charlotte Bobcats", NA, NA, NA, NA, NA, NA, NA, NA, NA,
                                  NA, NA, NA, NA, NA, "New Orleans Hornets", NA, "Seattle SuperSonics", NA, NA, NA, NA,
                                  NA, NA, NA, NA, NA)
    
    # Instead of returning a value we assign this data frame to the global enviroment.
    assign("team_names" , team_names, env = .GlobalEnv )
}
###############################################################################################################################
# Below we create a function called get_stats. Its goal is to webscrap data about statistics of the teams we downloaded in the
# previous function. Data will relate to 3 types of stats. Statistics which characterize a chosen team, second type describes 
# the statistics of all opponents of this chosen team and third expresses the miscellaneous stats. We are only including the period from
# 2011 to 2015. Thus each row will have the various stats of one team in one year e.g. the stats of Atlanta Hawks in 2012. We must 
# remeber that for each team we have 5 rows (5 different years). All of columns are defined in a specification.


get_stats<- function(){

# At a website we are webscraping, statistics are written down for all of the teams, for one year, in 3 tables
# (the same as we have chosen). By that I mean that one link contains 3 tables of statistics for one year fo every
# team.

    
    # There we create empty 3 data frames to which we will be adding statistics of one type.
    team_stats <- data.frame(matrix(numeric(0),ncol=26)) 
    opponent_stats <- data.frame(matrix(numeric(0),ncol=26))
    miscellaneous_stats <- data.frame(matrix(numeric(0),ncol=26))
    
    
    for ( i in 1:5)    # Each iteration get data from one year (from 2011 to 2015)
    {
        # Downloading data from one year and assigning it to the variable tables
        Year=paste0("201",i) 
        html <- paste0("http://www.basketball-reference.com/leagues/NBA_",Year,".html")
        URL<-getURL(html)
        tables <- readHTMLTable(URL,h=T)
        
        # Those commands responds for adding values from tables to team_stats
        team_tmp <- tables$team  # Assignig data to a temporary variable team_tmp
        team_tmp$Team <- gsub('\\*', '',team_tmp$Team)  # In some of the names there is "*", this line delete this
        team_tmp <- cbind(team_tmp,Year) # This line adds variable Year 
        team_tmp <- team_tmp[1:30,2:27] # We skip 31 row because it contains unwanted information about average stats of every team
                                        # Also we want to skip first column which contains unwanted information.
        nazwy <- names(team_tmp) # Passing of the names
        names(team_stats) <- nazwy
        team_stats <- rbind(team_stats,team_tmp) # Adding data to the data frame team_stats
        
        # Those lines are analogical as those above but they add to the opponent_stats
        opponent_tmp <- tables$opponent
        opponent_tmp$Team <- gsub('\\*', '',opponent_tmp$Team)
        opponent_tmp <- cbind(opponent_tmp,Year) 
        opponent_tmp <- opponent_tmp[1:30,2:27]
        nazwy <- names(opponent_tmp)
        names(opponent_stats) <- nazwy
        opponent_stats <- rbind(opponent_stats,opponent_tmp)
        
        # Those lines are analogical as those above but they add to the miscellaneous_stats
        miscellaneous_tmp <- tables$misc
        miscellaneous_tmp$Team <- gsub('\\*', '',miscellaneous_tmp$Team)
        miscellaneous_tmp <- cbind(miscellaneous_tmp,Year) 
        miscellaneous_tmp <- miscellaneous_tmp[1:30,2:25]
        nazwy <- names(miscellaneous_tmp)
        names(miscellaneous_stats) <- nazwy
        miscellaneous_stats <- rbind(miscellaneous_stats,miscellaneous_tmp)
        
    }
    
    # At that moment we have 3 data frames with unstructed data from 5 years. Each data frame refers to the different type
    
    # If we want to join those data frames together, each row has to respond to the same team and year
    # That's why we are sorting them firstly by the name, and the second factor is year
    team_stats  <- team_stats[order(team_stats$Team,team_stats$Year),]
    opponent_stats <- opponent_stats[order(opponent_stats$Team,opponent_stats$Year),]
    miscellaneous_stats <- miscellaneous_stats[order(miscellaneous_stats$Team,miscellaneous_stats$Year),]
    
    # Now we can join everything in one data frame called stats (we miss some columns for example in miscellaneous we miss 
    # 1 columns which contain the name of a team which is already described in the team_stats)
    stats <- cbind(team_stats[1:25],opponent_stats[4:25],miscellaneous_stats[2:24])
    
    # For fear that we could misunderstand some data, we change the old names of teams for the actual ones 
    stats$Team[stats$Team == "Charlotte Hornets"] <- "Charlotte Bobcats"
    stats$Team[stats$Team == "New Jersey Nets"] <- "Brooklyn Nets"
    stats$Team[stats$Team == "New Orleans Pelicans"] <- "New Orleans Hornets"
    stats <- stats[order(stats$Team,stats$Year),]
    
    # The names of columns from opponent stats have the same names as those from team stats. We are going to differ them by adding O
    # in front of each name
    colnames(stats)[26:47] <- paste0("O",names(stats[26:47]))
    
    # Changing the names for the shortcuts
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
    
    # Now we can assign the prepared data frame to the global enviroment
    assign( "stats" , stats , env = .GlobalEnv )
}
#############################################################################################################################
# Below we have a function get_games_story which is webscraping the results of every game and other data related to those games.

get_games_story <- function(){
    
    # We start with accesing the names from the earlier written function
    team_names <- get_team_names()
   
    # At first we create a list which will contain 30 data frames. Each one refers to one team. To every
    # data frame we download history of games from 2011 to 2016.
    team_story <- lapply(team_names$name, function (x) x=data.frame()) # Creating the list
    names(team_story) <- team_names$name # Assignig the names of the teams to the data frames
    
    for ( i in 1:6) # Each iteration downloads data from one year and adds to the team_story
    {
        year <- paste0("201", i)
        
        for(j in 1:length(team_names$shortcut)) # A loop which solves a problem with a historical names
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
            
            # Downloading 
            html <- paste0( "http://www.basketball-reference.com/teams/", team_names_tmp, "/", year, "_games.html")
            URL <- getURL(html)
            team_story_tmp <- readHTMLTable(URL, h=T)
            team_story_tmp <- team_story_tmp$teams_games # Getting data we need from what we downloaded
            nazwy <- names(team_story_tmp) # Precising the names
            name <-c("G", "Date", "Time", "Box Score" , "", "Where", "Opponent", "Result",  "",
                     "Tm", "Opp", "W", "L", "Streak" , "Notes" ) 
            names(team_story_tmp) <- name
            # Creating a final version for given team and year
            team_story_tmp <- data.frame(Opponent=team_story_tmp$Opponent, Date=team_story_tmp$Date, Tm=team_story_tmp$Tm,
                                         Opp=team_story_tmp$Opp, L=team_story_tmp$L, Result=team_story_tmp$Result,
                                         Where=team_story_tmp$Where, Year=year)
            team_story_tmp <- team_story_tmp[-c(21, 42, 63, 84),] # Deleting unwated information
            team_story[[j]]=rbind(team_story[[j]], team_story_tmp) # Adding data to team_story
        }
    }
    
    
    # Now we wanna join all of the results in one big frame with the history of the games by using a new variable
    # HOST, which desribes who is a host (if away, then there is an indicator @). We are going to assign it to a new
    # data frame games_story
    games_story <- data.frame()
    
    for(i in 1:(length(team_story)-1)) # loop by every element of team_story without last (we don't need last, we have all before)
    {                                
        
        Host <- names(team_story[i])
        games_story_tmp <- data.frame(cbind(Host, as.data.frame(team_story[[i]])))
        
        Host_tmp <- ifelse(games_story_tmp$Where == "@", as.vector(games_story_tmp$Opponent), as.vector(games_story_tmp$Host))
        Opponent_tmp <- ifelse(games_story_tmp$Where == "@", as.vector(Host), as.vector(games_story_tmp$Opponent))
        
        Tm_tmp <- ifelse(games_story_tmp$Where == "@", as.vector(games_story_tmp$Opp), as.vector(games_story_tmp$Tm))
        Opp_tmp <- ifelse(games_story_tmp$Where == "@", as.vector(games_story_tmp$Tm), as.vector(games_story_tmp$Opp))
        
        # Assignig the values of matches
        games_story_tmp$Host <- Host_tmp
        games_story_tmp$Opponent <- Opponent_tmp
        games_story_tmp$Tm <- Tm_tmp
        games_story_tmp$Opp <- Opp_tmp 
        games_story_tmp$Result <- ifelse(as.numeric(games_story_tmp$Tm) > as.numeric(games_story_tmp$Opp), 1, 0)
        
        games_story <- rbind(games_story, games_story_tmp[, -8])
    }
    
    # Changing of old names
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
    
    # Sorting by date
    games_story=games_story[order(games_story$Year), -6]
   
    # Deleting duplicated data
    games_story <- games_story[!duplicated(games_story), ]
    
    # Assigning a final data frame to the global enviroment
    assign( "games_story" , games_story , env = .GlobalEnv )
}

