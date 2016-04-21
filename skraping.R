################### Skrypt scrapujący wszystkie potrzebne dane i statystyki ################################################

#Biblioteki koniecznie do działania programu
library(rvest)
library(XML)
library(RCurl)

#############################################################################################################################

# Poniżej tworzymy data.frame druzyny, w którym zawarta jest cała baza 
# nazw i skrótów drużyn oraz zmian historycznych tych nazw

druzyny <- data.frame( nazwa=rep("a",30) , skrot=rep('a',30) , rok.zmian=rep(NA,30) , poprzed.nazwa=rep(NA,30) ,
                       poprzed.skrot=rep('a',30) )

druzyny$nazwa <- c( "Atlanta Hawks" , "Boston Celtics" , "Brooklyn Nets" , "Charlotte Hornets" , "Chicago Bulls" ,
                    "Cleveland Cavaleries" , "Dallas Mavericks" , "Denver Nuggets" , "Detroit Pistons" ,
                    "Golden State Warriors" , "Houston Rockets" , "Indiana Pacers" , "Los Angeles Clippers" ,
                    "Los Angeles Lakers" , "Memphis Grizzlies" , "Miami Heat" , "Milwaukee Bucks" ,
                    "Minnesota Timberwolves" , "New Orleans Pelicans" , "New York Knicks" , "Oklahoma City Thunder" ,
                    "Orlando Magic" , "Philadelphia 76ers" , "Phoenix Suns" , "Portland Trail Blazers" ,
                    "Sacramento Kings" , "San Antonio Spurs" , "Toronto Raptors" , "Utah Jazz" , "Washington Wizards" )

druzyny$skrot <- c( "ATL" , "BOS" , "BRK" , "CHO" , "CHI" , "CLE" , "DAL" , "DEN" , "DET" , "GSW" , "HOU" , "IND", "LAC" ,
                    "LAL" , "MEM" , "MIA" , "MIL" , "MIN" , "NOP" , "NYK" , "OKC" , "ORL" , "PHI" , "PHO" , "POR" , "SAC" ,
                    "SAS" , "TOR" , "UTA" , "WAS" )

druzyny$rok.zmian <- c( NA , NA , 2013 , 2015 , NA , NA , NA , NA , NA , NA , NA , NA , NA , NA , NA , NA , NA , NA , 2014 ,
                        NA , 2009 , NA , NA , NA , NA , NA , NA , NA , NA , NA )

druzyny$poprzed.skrot <- c( NA , NA , "NJN" , "CHA" , NA , NA , NA , NA , NA , NA , NA , NA , NA , NA , NA , NA , NA , NA ,
                         "NOH" , NA , "SEA" , NA , NA , NA , NA , NA , NA , NA , NA , NA )

druzyny$poprzed.nazwa <- c( NA , NA , "New Jersey Nets" , "Charlotte Bobcats" , NA , NA , NA , NA , NA , NA , NA ,NA, NA ,
                            NA , NA , NA , NA , NA , "New Orleans Hornets", NA , "Seattle SuperSonics" , NA , NA , NA , NA ,
                            NA , NA , NA , NA , NA )

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
# Teraz przechodzimy do pobierania historii meczy dla każdej drużyny z lat 2012-2016
#pobieranie danych dla kazdej druzyny 

ramki=lapply(druzyny$nazwa,function (x) x=data.frame())
names(ramki)=druzyny$nazwa

for ( i in 2:6)
{
  
  rok=paste0("201",i)
  for(j in 1:length(druzyny$skrot))
  {
    druzyna=druzyny$skrot[j]
    if(i==2 & j==3)
    {
      druzyna="NJN"
    }
    if((i==5 | i==6) & j==4)
    {
      druzyna="CHO"
    }
    if((i==2 | i==3) & j==19)
    {
      druzyna="NOH"
    }
    
    html <- paste0( "http://www.basketball-reference.com/teams/",druzyna,"/",rok,"_games.html")
    URL <- getURL(html)
    ramka <- readHTMLTable(URL,h=T)
    ramka <- ramka$teams_games
    nazwy <- names(ramka)
    name <-c("G","Date","Time", "Box Score" ,"", "Where","Opponent", "Result", "",
              "Tm","Opp","W","L","Streak" ,"Notes" ) 
    names(ramka) <- name
    ramka <- data.frame(Opponent=ramka$Opponent,Tm=ramka$Tm,Opp=ramka$Opp,
                 L=ramka$L,Result=ramka$Result,Where=ramka$Where,rok=rok)
    ramka <- ramka[-c(21,42,63,84),]
    ramki[[j]]=rbind(ramki[[j]],ramka)
  }
}

 
