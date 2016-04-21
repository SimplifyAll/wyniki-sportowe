library(rvest)
library(XML)
library(RCurl)

### pobieranie dla kazdego zespolu
druzyny<-data.frame(nazwa=rep("a",30),skrot=rep('a',30),rok.zmian=rep(NA,30),poprzed.nazwa=rep(NA,30),poprzed.skrot=rep('a',30))
druzyny$nazwa<-c("Atlanta Hawks","Boston Celtics","Brooklyn Nets","Charlotte Hornets","Chicago Bulls",
                 "Cleveland Cavaleries","Dallas Mavericks","Denver Nuggets","Detroit Pistons",
                 "Golden State Warriors","Houston Rockets","Indiana Pacers","Los Angeles Clippers",
                 "Los Angeles Lakers","Memphis Grizzlies","Miami Heat","Milwaukee Bucks",
                 "Minnesota Timberwolves","New Orleans Pelicans",'New York Knicks',"Oklahoma City Thunder",
                 "Orlando Magic","Philadelphia 76ers","Phoenix Suns",'Portland Trail Blazers',
                 "Sacramento Kings","San Antonio Spurs","Toronto Raptors","Utah Jazz","Washington Wizards")
druzyny$poprzed.skrot<-c(NA,NA,"NJN","CHA",NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,
                         "NOH",NA,"SEA",NA,NA,NA,NA,NA,NA,NA,NA,NA)
druzyny$poprzed.nazwa<-c(NA,NA,"New Jersey Nets","Charlotte Bobcats",NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,
                         "NOH",NA,"Seattle SuperSonics",NA,NA,NA,NA,NA,NA,NA,NA,NA)
druzyny$rok.zmian<-c(NA,NA,2013,2015,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,2014,NA,2009,
                     NA,NA,NA,NA,NA,NA,NA,NA,NA)
druzyny$skrot<-c("ATL","BOS","BRK","CHA","CHI","CLE","DAL","DEN","DET","GSW","HOU","IND","LAC","LAL","MEM",
                 "MIA","MIL","MIN","NOP","NYK","OKC","ORL","PHI","PHO","POR","SAC","SAS","TOR","UTA","WAS")


##Pobieranie historii 5 lat
#pobieramy dane z historii dla 2012-2016
team <- data.frame(matrix(numeric(0),ncol=27))
op <- data.frame(matrix(numeric(0),ncol=27))
mi <- data.frame(matrix(numeric(0),ncol=27))
for ( i in 2:6)
{
  rok=paste0("201",i)
  html <- paste0("http://www.basketball-reference.com/leagues/NBA_",rok,".html")
  URL<-getURL(html)
  tabele <- readHTMLTable(URL,h=T)
  
  team_stats <- tabele$team
  team_stats$Team <- gsub('\\*', '',team_stats$Team)
  team_stats <- cbind(team_stats,rok)
  nazwy <- names(team_stats)
  names(team) <- nazwy
  team <- rbind(team,team_stats)
 
  opponent <- tabele$opponent
  opponent$Team <- gsub('\\*', '',opponent$Team)
  opponent <- cbind(opponent,rok)
  nazwy <- names(opponent)
  names(op) <- nazwy
  op <- rbind(op,opponent)
  
  mis <- tabele$misc
  mis$Team <- gsub('\\*', '',mis$Team)
  mis <- cbind(mis,rok)
  nazwy <- names(mis)
  names(mi) <- nazwy
  mi<- rbind(mi,mis)
  
}

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

 