################### Skrypt scrapujący wszystkie potrzebne dane i statystyki ################################################

#Biblioteki koniecznie do działania programu
library(rvest)
library(XML)
library(RCurl)
library(stringi)
#############################################################################################################################

# Poniżej tworzymy data.frame team.names, w którym zawarta jest cała baza 
# nazw i skrótów drużyn oraz zmian historycznych tych nazw
get_team_names <- function(){
    team_names <- data.frame(name=rep("a",30), shortcut=rep('a',30), change_year=rep(NA,30), previous_name=rep(NA,30),
                             previous_shortcut=rep('a',30))
    
    team_names$name <- c("Atlanta Hawks", "Boston Celtics", "Brooklyn Nets", "Charlotte Hornets", "Chicago Bulls",
                          "Cleveland Cavaliers", "Dallas Mavericks", "Denver Nuggets", "Detroit Pistons",
                          "Golden State Warriors", "Houston Rockets", "Indiana Pacers", "Los Angeles Clippers",
                          "Los Angeles Lakers", "Memphis Grizzlies", "Miami Heat", "Milwaukee Bucks",
                          "Minnesota Timberwolves", "New Orleans Pelicans", "New York Knicks", "Oklahoma City Thunder",
                          "Orlando Magic", "Philadelphia 76ers", "Phoenix Suns", "Portland Trail Blazers",
                          "Sacramento Kings", "San Antonio Spurs", "Toronto Raptors", "Utah Jazz", "Washington Wizards")
    
    team_names$shortcut <- c("ATL", "BOS", "BRK", "CHO", "CHI", "CLE", "DAL", "DEN", "DET", "GSW", "HOU", "IND", "LAC",
                          "LAL", "MEM", "MIA", "MIL", "MIN", "NOP", "NYK", "OKC", "ORL", "PHI", "PHO", "POR", "SAC",
                          "SAS", "TOR", "UTA", "WAS")
    
    team_names$change_year <- c(NA, NA, 2013, 2015, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 2014,
                              NA, 2009, NA, NA, NA, NA, NA, NA, NA, NA, NA)
    
    team_names$previous_shortcut <- c(NA, NA, "NJN", "CHA", NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                                  "NOH", NA, "SEA", NA, NA, NA, NA, NA, NA, NA, NA, NA)
    
    team_names$previous_name <- c(NA, NA, "New Jersey Nets", "Charlotte Bobcats", NA, NA, NA, NA, NA, NA, NA, NA, NA,
                                  NA, NA, NA, NA, NA, "New Orleans Hornets", NA, "Seattle SuperSonics", NA, NA, NA, NA,
                                  NA, NA, NA, NA, NA)
    #return(team_names)
    assign("team_names" , team_names, env = .GlobalEnv )
}
###############################################################################################################################

get_stats<- function(){
    # Poniżej tworzymy data.frame, który jest stworzony z danych opisujących różne statystyki drużyn na przełomie lat 2012-2016
    # Dla każdego roku na stronie mamy 3 tabele (Team Stats, Oponent Stats , Miscellaneous Stats) i tworzymy z nich jedną dużą,
    # zawierającą wszystkie dane dla wszystkich lat.
    
    #Te data.framy będę agregowały dane z wszystkich lat dla jednego typu statystyk (Team, Opponent lub Miscellaneous)
    team_stats <- data.frame(matrix(numeric(0),ncol=26)) 
    opponent_stats <- data.frame(matrix(numeric(0),ncol=26))
    miscellaneous_stats <- data.frame(matrix(numeric(0),ncol=26))
    
    
    for ( i in 1:5)    # Pętla ta ściąga w kolejnych iteracjach, ściąga dane z kolejnych lat. Od 2011 do 2015.
    {
        # Ściągnięcie tabel z jednego sezonu i przypisanie je do zmiennej tabele
        Year=paste0("201",i) 
        html <- paste0("http://www.basketball-reference.com/leagues/NBA_",Year,".html")
        URL<-getURL(html)
        tabele <- readHTMLTable(URL,h=T)
        
        # Dopisanie danych do tabeli team.stats
        team_tmp <- tabele$team  # Przypisanie danych dotyczących Team Stats do pomocniczej zmiennej team.tmp
        team_tmp$Team <- gsub('\\*', '',team_tmp$Team)  # Usunięcie gwiazdek z nazw zespołów
        team_tmp <- cbind(team_tmp,Year) # Dodanie na koniec kolumny, określającej rok
        team_tmp <- team_tmp[1:30,2:27] # 1:30 ponieważ chcemy pozbyć się wiersza 'average', 2:26 by usunąć 1 niepotrzebną kolumnę
        nazwy <- names(team_tmp) 
        names(team_stats) <- nazwy
        team_stats <- rbind(team_stats,team_tmp) # Dopisanie kolejnych rekordów do tabeli team.stats
        
        # Dopisanie danych do tabeli opponent.stats, analogiczne jak wyżej
        opponent_tmp <- tabele$opponent
        opponent_tmp$Team <- gsub('\\*', '',opponent_tmp$Team)
        opponent_tmp <- cbind(opponent_tmp,Year) 
        opponent_tmp <- opponent_tmp[1:30,2:27]
        nazwy <- names(opponent_tmp)
        names(opponent_stats) <- nazwy
        opponent_stats <- rbind(opponent_stats,opponent_tmp)
        
        # Dopisanie danych do tabeli miscellaneous.stats, analogiczne jak wyżej
        miscellaneous_tmp <- tabele$misc
        miscellaneous_tmp$Team <- gsub('\\*', '',miscellaneous_tmp$Team)
        miscellaneous_tmp <- cbind(miscellaneous_tmp,Year) 
        miscellaneous_tmp <- miscellaneous_tmp[1:30,2:25]
        nazwy <- names(miscellaneous_tmp)
        names(miscellaneous_stats) <- nazwy
        miscellaneous_stats <- rbind(miscellaneous_stats,miscellaneous_tmp)
        
    }
    
    # W tym momencie mamy 3 data.framy zawierające nieuporządkowane dane z 5 lat, dla danego typu statystyk
    
    # Aby móc przyłączyć te tabele do siebie, dane wiersze muszą odpowiadać konkretnej drużynie w konkretnym roku
    # Dlatego poniżej sortujemy wg 2 czynników, najpierw alfabetyczna nazwa, potem rok. Sortownie typu a1 a2 b1 b2.
    
    team_stats  <- team_stats[order(team_stats$Team,team_stats$Year),]
    opponent_stats <- opponent_stats[order(opponent_stats$Team,opponent_stats$Year),]
    miscellaneous_stats <- miscellaneous_stats[order(miscellaneous_stats$Team,miscellaneous_stats$Year),]
    
    # Złaczamy 3 tabele w jedną
    stats <- cbind(team_stats[1:25],opponent_stats[4:25],miscellaneous_stats[2:24])
    
    # Zmieniamy stare nazwy drużyn by nie było niespójności
    stats$Team[stats$Team == "Charlotte Hornets"] <- "Charlotte Bobcats"
    stats$Team[stats$Team == "New Jersey Nets"] <- "Brooklyn Nets"
    stats$Team[stats$Team == "New Orleans Pelicans"] <- "New Orleans Hornets"
    stats <- stats[order(stats$Team,stats$Year),]
    
    # Dane z Opponent Stats mają takie same nazwy jak z Team Stats, dlatego odróżnimy je poprzez dodanie O z przodu
    colnames(stats)[26:47] <- paste0("O",names(stats[26:47]))
    
    # Zamiana nazw na skróty
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
    
    # Data.frame stats jest już gotowy
    assign( "stats" , stats , env = .GlobalEnv )
}
#############################################################################################################################

get_games_story <- function(){
    # Teraz przechodzimy do pobierania historii meczy dla każdej drużyny z 5 lat + 2016 rok jako informacja o rozkładzie meczy
    # w sezonie 2015/2016
    team_names <- get_team_names()
    # Wpierw tworzymy listę team.story która, będzie się składała z 30 data.frameów odpowiadających 30 drużynom
    # Do każdej drużyny ściagamy historię meczy z 5 lat
    
    team_story <- lapply(team_names$name, function (x) x=data.frame()) # Tworzenie listy
    names(team_story) <- team_names$name # Przypianie nazw drużyn dla data.frameów
    
    for ( i in 1:6) # Pętla ściagająca historie z 5 lat i wrzucająca to do team.story
    {
        year <- paste0("201", i)
        
        for(j in 1:length(team_names$shortcut)) # Pętla rozwiącująca problem zmian nazw drużyn.
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
            team_story_tmp <- team_story_tmp$teams_games # Wyciągnięcie potrzebnych nam danych
            nazwy <- names(team_story_tmp) # Poniżej linijki uściślające nazwy
            name <-c("G", "Date", "Time", "Box Score" , "", "Where", "Opponent", "Result",  "",
                     "Tm", "Opp", "W", "L", "Streak" , "Notes" ) 
            names(team_story_tmp) <- name
            # Tworzenie ostatecznej tabeli dla danego zespołu dla danego roku
            team_story_tmp <- data.frame(Opponent=team_story_tmp$Opponent, Date=team_story_tmp$Date, Tm=team_story_tmp$Tm,
                                         Opp=team_story_tmp$Opp, L=team_story_tmp$L, Result=team_story_tmp$Result,
                                         Where=team_story_tmp$Where, Year=year)
            team_story_tmp <- team_story_tmp[-c(21, 42, 63, 84),] # Wyrzucenie niepotrzebnych danych
            team_story[[j]]=rbind(team_story[[j]], team_story_tmp) # Dopisanie rekordów to istniejącej tabeli
        }
    }
    
    
    # Łączenie wszystkich ramek z historią meczów konkretnych drużyn do jednej wielkiej tabeli z historią meczy, 
    # Przy użyciu nowej zmiennej HOST, ktora opisuje gospodarza meczu (indykator "" jak w domu,jak na wyjedzie- @),
    # Rowniez jak mamy zamianę druzyn, to musimy  wyniki pozamieniac miejscami, i Result: W->L lub w drugą stronę
    
    games_story <- data.frame()
    for(i in 1:(length(team_story)-1))
    { 
        
        Host <- names(team_story[i])
        games_story_tmp <- data.frame(cbind(Host, as.data.frame(team_story[[i]])))
        
        Host_tmp <- ifelse(games_story_tmp$Where == "@", as.vector(games_story_tmp$Opponent), as.vector(games_story_tmp$Host))
        Opponent_tmp <- ifelse(games_story_tmp$Where == "@", as.vector(Host), as.vector(games_story_tmp$Opponent))
        
        Tm_tmp <- ifelse(games_story_tmp$Where == "@", as.vector(games_story_tmp$Opp), as.vector(games_story_tmp$Tm))
        Opp_tmp <- ifelse(games_story_tmp$Where == "@", as.vector(games_story_tmp$Tm), as.vector(games_story_tmp$Opp))
        
        # Przypisanie wartości meczy
        games_story_tmp$Host <- Host_tmp
        games_story_tmp$Opponent <- Opponent_tmp
        games_story_tmp$Tm <- Tm_tmp
        games_story_tmp$Opp <- Opp_tmp 
        games_story_tmp$Result <- ifelse(as.numeric(games_story_tmp$Tm) > as.numeric(games_story_tmp$Opp), 1, 0)
        
        games_story <- rbind(games_story, games_story_tmp[, -8])
    }
    
    # Zamiana starych nazw na nowe
    games_story[games_story$Host == "New Jersey Nets", 1] <- "Brooklyn Nets"
    games_story[games_story$Host == "Charlotte Bobcats", 1] <- "Charlotte Hornets"
    games_story[games_story$Host == "New Orleans Hornets", 1] <- "New Orleans Pelicans"
    
    games_story[games_story$Opponent == "New Jersey Nets", 2] <- "Brooklyn Nets"
    games_story[games_story$Opponent == "Charlotte Bobcats", 2] <- "Charlotte Hornets"
    games_story[games_story$Opponent == "New Orleans Hornets", 2] <- "New Orleans Pelicans"
    
    # Zamiana nazw na skroty
    Host <- unlist(sapply(games_story$Host, function(x) team_names[team_names$name==x,2]))
    names(Host)=NULL
    games_story$Host=as.vector(Host)
    
    Opponent_tmp=unlist(sapply(games_story$Opponent, function(x) team_names[team_names$name==x, 2]))
    names(Opponent_tmp)=NULL
    games_story$Opponent=as.vector(Opponent_tmp)
    
    # Sortowanie
    games_story=games_story[order(games_story$Year), -6]
    # Usunięcie replikowanych danych
    
    games_story <- games_story[!duplicated(games_story), ]
    
    assign( "games_story" , games_story , env = .GlobalEnv )
}

# Testy 
# new[new$Year=="2014" & (new$Opponent=="Utah Jazz" | new$Host=="Utah Jazz") &
#  (new$Opponent=="Atlanta Hawks" | new$Host=="Atlanta Hawks"),]
# moja=ramki$`Atlanta Hawks`
# moja[moja$Year==2014 & moja$Opponent=="Utah Jazz",] 

# Czy nazwy maja tyle samo unikalnych nazw
# setdiff(unique(new$Host),unique(team.names$nazwa))
# length(unique(team.names$skrot))
# length(unique(new$Host)))
