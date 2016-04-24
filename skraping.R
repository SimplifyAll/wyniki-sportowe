################### Skrypt scrapujący wszystkie potrzebne dane i statystyki ################################################

#Biblioteki koniecznie do działania programu
library(rvest)
library(XML)
library(RCurl)

#############################################################################################################################

# Poniżej tworzymy data.frame team.names, w którym zawarta jest cała baza 
# nazw i skrótów drużyn oraz zmian historycznych tych nazw

team.names <- data.frame(nazwa=rep("a",30), skrot=rep('a',30), rok.zmian=rep(NA,30), poprzed.nazwa=rep(NA,30),
                      poprzed.skrot=rep('a',30))

team.names$nazwa <- c("Atlanta Hawks", "Boston Celtics", "Brooklyn Nets", "Charlotte Hornets", "Chicago Bulls",
                   "Cleveland Cavaliers", "Dallas Mavericks", "Denver Nuggets", "Detroit Pistons",
                   "Golden State Warriors", "Houston Rockets", "Indiana Pacers", "Los Angeles Clippers",
                   "Los Angeles Lakers", "Memphis Grizzlies", "Miami Heat", "Milwaukee Bucks",
                   "Minnesota Timberwolves", "New Orleans Pelicans", "New York Knicks", "Oklahoma City Thunder",
                   "Orlando Magic", "Philadelphia 76ers", "Phoenix Suns", "Portland Trail Blazers",
                   "Sacramento Kings", "San Antonio Spurs", "Toronto Raptors", "Utah Jazz", "Washington Wizards")

team.names$skrot <- c("ATL", "BOS", "BRK", "CHO", "CHI", "CLE", "DAL", "DEN", "DET", "GSW", "HOU", "IND", "LAC",
                   "LAL", "MEM", "MIA", "MIL", "MIN", "NOP", "NYK", "OKC", "ORL", "PHI", "PHO", "POR", "SAC",
                   "SAS", "TOR", "UTA", "WAS")

team.names$rok.zmian <- c(NA, NA, 2013, 2015, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 2014,
                       NA, 2009, NA, NA, NA, NA, NA, NA, NA, NA, NA)

team.names$poprzed.skrot <- c(NA, NA, "NJN", "CHA", NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                           "NOH", NA, "SEA", NA, NA, NA, NA, NA, NA, NA, NA, NA)

team.names$poprzed.nazwa <- c(NA, NA, "New Jersey Nets", "Charlotte Bobcats", NA, NA, NA, NA, NA, NA, NA, NA, NA,
                           NA, NA, NA, NA, NA, "New Orleans Hornets", NA, "Seattle SuperSonics", NA, NA, NA, NA,
                           NA, NA, NA, NA, NA)

###############################################################################################################################

# Poniżej tworzymy data.frame, który jest stworzony z danych opisujących różne statystyki drużyn na przełomie lat 2012-2016
# Dla każdego roku na stronie mamy 3 tabele (Team Stats, Oponent Stats , Miscellaneous Stats) i tworzymy z nich jedną dużą,
# zawierającą wszystkie dane dla wszystkich lat.

#Te data.framy będę agregowały dane z wszystkich lat dla jednego typu statystyk (Team, Opponent lub Miscellaneous)
team.stats <- data.frame(matrix(numeric(0),ncol=26)) 
opponent.stats <- data.frame(matrix(numeric(0),ncol=26))
miscellaneous.stats <- data.frame(matrix(numeric(0),ncol=26))


for ( i in 2:6)    # Pętla ta ściąga w kolejnych iteracjach, ściąga dane z kolejnych lat. Od 2012 do 2016.
{
    # Ściągnięcie tabel z jednego sezonu i przypisanie je do zmiennej tabele
    Year=paste0("201",i) 
    html <- paste0("http://www.basketball-reference.com/leagues/NBA_",Year,".html")
    URL<-getURL(html)
    tabele <- readHTMLTable(URL,h=T)
    
    # Dopisanie danych do tabeli team.stats
    team.tmp <- tabele$team  # Przypisanie danych dotyczących Team Stats do pomocniczej zmiennej team.tmp
    team.tmp$Team <- gsub('\\*', '',team.tmp$Team)  # Usunięcie gwiazdek z nazw zespołów
    team.tmp <- cbind(team.tmp,Year) # Dodanie na koniec kolumny, określającej rok
    team.tmp <- team.tmp[1:30,2:27] # 1:30 ponieważ chcemy pozbyć się wiersza 'average', 2:26 by usunąć 1 niepotrzebną kolumnę
    nazwy <- names(team.tmp) 
    names(team.stats) <- nazwy
    team.stats <- rbind(team.stats,team.tmp) # Dopisanie kolejnych rekordów do tabeli team.stats
    
    # Dopisanie danych do tabeli opponent.stats, analogiczne jak wyżej
    opponent.tmp <- tabele$opponent
    opponent.tmp$Team <- gsub('\\*', '',opponent.tmp$Team)
    opponent.tmp <- cbind(opponent.tmp,Year) 
    opponent.tmp <- opponent.tmp[1:30,2:27]
    nazwy <- names(opponent.tmp)
    names(opponent.stats) <- nazwy
    opponent.stats <- rbind(opponent.stats,opponent.tmp)
    
    # Dopisanie danych do tabeli miscellaneous.stats, analogiczne jak wyżej
    miscellaneous.tmp <- tabele$misc
    miscellaneous.tmp$Team <- gsub('\\*', '',miscellaneous.tmp$Team)
    miscellaneous.tmp <- cbind(miscellaneous.tmp,Year) 
    miscellaneous.tmp <- miscellaneous.tmp[1:30,2:25]
    nazwy <- names(miscellaneous.tmp)
    names(miscellaneous.stats) <- nazwy
    miscellaneous.stats <- rbind(miscellaneous.stats,miscellaneous.tmp)
    
}

# W tym momencie mamy 3 data.framy zawierające nieuporządkowane dane z 5 lat, dla danego typu statystyk

# Aby móc przyłączyć te tabele do siebie, dane wiersze muszą odpowiadać konkretnej drużynie w konkretnym roku
# Dlatego poniżej sortujemy wg 2 czynników, najpierw alfabetyczna nazwa, potem rok. Sortownie typu a1 a2 b1 b2.

team.stats  <- team.stats[order(team.stats$Team,team.stats$Year),]
opponent.stats <- opponent.stats[order(opponent.stats$Team,opponent.stats$Year),]
miscellaneous.stats <- miscellaneous.stats[order(miscellaneous.stats$Team,miscellaneous.stats$Year),]

# Złaczamy 3 tabele w jedną
stats <- cbind(team.stats[1:25],opponent.stats[4:25],miscellaneous.stats[2:24])

# Zmieniamy stare nazwy drużyn by nie było niespójności
stats$Team[stats$Team == "Charlotte Hornets"] <- "Charlotte Bobcats"
stats$Team[stats$Team == "New Jersey Nets"] <- "Brooklyn Nets"
stats$Team[stats$Team == "New Orleans Pelicans"] <- "New Orleans Hornets"
stats <- stats[order(stats$Team,stats$Year),]

# Dane z Opponent Stats mają takie same nazwy jak z Team Stats, dlatego odróżnimy je poprzez dodanie O z przodu
colnames(stats)[26:47] <- paste0("O",names(stats[26:47]))

# Data.frame stats jest już gotowy

#############################################################################################################################
# Teraz przechodzimy do pobierania historii meczy dla każdej drużyny z 5 lat 

# Wpierw tworzymy listę team.story która, będzie się składała z 30 data.frameów odpowiadających 30 drużynom
# Do każdej drużyny ściagamy historię meczy z 5 lat

team.story <- lapply(team.names$nazwa, function (x) x=data.frame()) # Tworzenie listy
names(team.story) <- team.names$nazwa # Przypianie nazw drużyn dla data.frameów

for ( i in 1:5) # Pętla ściagająca historie z 5 lat i wrzucająca to do team.story
{
    year <- paste0("201", i)
    
    for(j in 1:length(team.names$skrot)) # Pętla rozwiącująca problem zmian nazw drużyn.
    {
        team.names.tmp <- team.names$skrot[j]
        if((i==1 | i==2) & j==3)
        {
            team.names.tmp <- "NJN"
        }
        if((i==1 | i==2 | i==3 | i==4) & j==4)
        {
            team.names.tmp <- "CHA"
        }
        if((i==1| i==2 | i==3) & j==19)
        {
            team.names.tmp <-"NOH"
        }
        
        html <- paste0( "http://www.basketball-reference.com/teams/", team.names.tmp, "/", year, "_games.html")
        URL <- getURL(html)
        team.story.tmp <- readHTMLTable(URL, h=T)
        team.story.tmp <- team.story.tmp$teams_games # Wyciągnięcie potrzebnych nam danych
        nazwy <- names(team.story.tmp) # Poniżej linijki uściślające nazwy
        name <-c("G", "Date", "Time", "Box Score" , "", "Where", "Opponent", "Result",  "",
                 "Tm", "Opp", "W", "L", "Streak" , "Notes" ) 
        names(team.story.tmp) <- name
        # Tworzenie ostatecznej tabeli dla danego zespołu dla danego roku
        team.story.tmp <- data.frame(Opponent=team.story.tmp$Opponent, Date=team.story.tmp$Date, Tm=team.story.tmp$Tm,
                                     Opp=team.story.tmp$Opp, L=team.story.tmp$L, Result=team.story.tmp$Result,
                                     Where=team.story.tmp$Where, Year=year)
        team.story.tmp <- team.story.tmp[-c(21, 42, 63, 84),] # Wyrzucenie niepotrzebnych danych
        team.story[[j]]=rbind(team.story[[j]], team.story.tmp) # Dopisanie rekordów to istniejącej tabeli
    }
}


# Łączenie wszystkich ramek z historią meczów konkretnych drużyn do jednej wielkiej tabeli z historią meczy, 
# Przy użyciu nowej zmiennej HOST, ktora opisuje gospodarza meczu (indykator "" jak w domu,jak na wyjedzie- @),
# Rowniez jak mamy zamianę druzyn, to musimy  wyniki pozamieniac miejscami, i Result: W->L lub w drugą stronę

games.story <- data.frame()
for(i in 1:(length(team.story)-1))
{ 
    
    Host <- names(team.story[i])
    games.story.tmp <- data.frame(cbind(Host, as.data.frame(team.story[[i]])))
    
    Host.tmp <- ifelse(games.story.tmp$Where == "@", as.vector(games.story.tmp$Opponent), as.vector(games.story.tmp$Host))
    Opponent.tmp <- ifelse(games.story.tmp$Where == "@", as.vector(Host), as.vector(games.story.tmp$Opponent))
    
    Tm.tmp <- ifelse(games.story.tmp$Where == "@", as.vector(games.story.tmp$Opp), as.vector(games.story.tmp$Tm))
    Opp.tmp <- ifelse(games.story.tmp$Where == "@", as.vector(games.story.tmp$Tm), as.vector(games.story.tmp$Opp))
    
    # Przypisanie wartości meczy
    games.story.tmp$Host <- Host.tmp
    games.story.tmp$Opponent <- Opponent.tmp
    games.story.tmp$Tm <- Tm.tmp
    games.story.tmp$Opp <- Opp.tmp 
    games.story.tmp$Result <- ifelse(as.numeric(games.story.tmp$Tm) > as.numeric(games.story.tmp$Opp), "W", "L")
    
    games.story <- rbind(games.story, games.story.tmp[, -8])
}

# Zamiana starych nazw na nowe
games.story[games.story$Host == "New Jersey Nets", 1] <- "Brooklyn Nets"
games.story[games.story$Host == "Charlotte Bobcats", 1] <- "Charlotte Hornets"
games.story[games.story$Host == "New Orleans Hornets", 1] <- "New Orleans Pelicans"

games.story[games.story$Opponent == "New Jersey Nets", 2] <- "Brooklyn Nets"
games.story[games.story$Opponent == "Charlotte Bobcats", 2] <- "Charlotte Hornets"
games.story[games.story$Opponent == "New Orleans Hornets", 2] <- "New Orleans Pelicans"

# Zamiana nazw na skroty
Host <- unlist(sapply(games.story$Host, function(x) team.names[team.names$nazwa==x,2]))
names(Host)=NULL
games.story$Host=as.vector(Host)

Opponent.tmp=unlist(sapply(games.story$Opponent, function(x) team.names[team.names$nazwa==x, 2]))
names(Opponent.tmp)=NULL
games.story$Opponent=as.vector(Opponent.tmp)

# Sortowanie
games.story=games.story[order(new$Year), -6]

# Testy 
# new[new$Year=="2014" & (new$Opponent=="Utah Jazz" | new$Host=="Utah Jazz") &
#  (new$Opponent=="Atlanta Hawks" | new$Host=="Atlanta Hawks"),]
# moja=ramki$`Atlanta Hawks`
# moja[moja$Year==2014 & moja$Opponent=="Utah Jazz",] 

# Czy nazwy maja tyle samo unikalnych nazw
# setdiff(unique(new$Host),unique(team.names$nazwa))
# length(unique(team.names$skrot))
# length(unique(new$Host)))
