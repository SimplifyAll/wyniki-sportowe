druzyny<-data.frame(nazwa=rep("a",30),poprzed.naz=rep(NA,30),rok.zmian=rep(NA,30),skrot=rep('a',30))
druzyny$nazwa<-c("Atlanta Hawks","Boston Celtics","Brooklyn Nets","Charlotte Bobcats","Chicago Bulls",
                 "Cleveland Cavaleries","Dallas Mavericks","Denver Nuggets","Detroit Pistons",
                 "Golden State Warriors","Houston Rockets","Indiana Pacers","Los Angeles Clippers",
                 "Los Angeles Lakers","Memphis Grizzlies","Miami Heat","Milwaukee Bucks",
                 "Minnesota Timberwolves","New Orleans Pelicans",'New York Knicks',"Oklahoma City Thunder",
                 "Orlando Magic","Philadelphia 76ers","Phoenix Suns",'Portland Trail Blazers',
                 "Sacramento Kings","San Antonio Spurs","Toronto Raptors","Utah Jazz","Washington Wizards")
druzyny$poprzed.naz<-c(NA,NA,"New Jersey Nets","Charlotte Hornets",NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,
                        "New Orleans Hornets",NA,"Seattle SuperSonics",NA,NA,NA,NA,NA,NA,NA,NA,NA)
druzyny$rok.zmian<-c(NA,NA,2013,2015,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,2014,NA,2009,
                       NA,NA,NA,NA,NA,NA,NA,NA,NA)
druzyny$skrot<-c("ATL","BOS","NJN","CHA","CHI","CLE","DAL","DEN","DET","GSW","HOU","IND","LAC","LAL","MEM",
                 "MIA","MIL","MIN","NOH","NYK","OKC","ORL","PHI","PHO","POR","SAC","SAS","TOR","UTA","WAS")

