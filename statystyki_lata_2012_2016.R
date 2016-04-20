install.packages('rvest')
install.packages('XML')
install.packages('RCurl')
install.packages('stringi')

library(rvest)
library(XML)
library(RCurl)
library(stringi)


team <- data.frame(matrix(numeric(0),ncol=26))
op <- data.frame(matrix(numeric(0),ncol=26))
mi <- data.frame(matrix(numeric(0),ncol=26))

for ( i in 2:6)
{
    rok=paste0("201",i)
    html <- paste0("http://www.basketball-reference.com/leagues/NBA_",rok,".html")
    URL<-getURL(html)
    tabele <- readHTMLTable(URL,h=T)
    
    team_stats <- tabele$team
    team_stats$Team <- gsub('\\*', '',team_stats$Team)
    team_stats <- cbind(team_stats,rok)
    team_stats <- team_stats[1:30,2:27]
    nazwy <- names(team_stats)
    names(team) <- nazwy
    team <- rbind(team,team_stats)
    
    opponent <- tabele$opponent
    opponent$Team <- gsub('\\*', '',opponent$Team)
    opponent <- cbind(opponent,rok)
    opponent <- opponent[1:30,2:27]
    nazwy <- names(opponent)
    names(op) <- nazwy
    op <- rbind(op,opponent)
    
    mis <- tabele$misc
    mis$Team <- gsub('\\*', '',mis$Team)
    mis <- cbind(mis,rok)
    mis <- mis[1:30,2:25]
    nazwy <- names(mis)
    names(mi) <- nazwy
    mi <- rbind(mi,mis)
    
}

team  <- team[order(team$Team,team$rok),]
op <- op[order(op$Team,op$rok),]
mi <- mi[order(mi$Team,mi$rok),]
all <- cbind(team[1:25],op[2:25],mi[2:24])
all$Team[all$Team=="Charlotte Hornets"] <- "Charlotte Bobcats"
all$Team[all$Team=="New Jersey Nets"] <- "Brooklyn Nets"
all$Team[all$Team=="New Orleans Pelicans"] <- "New Orleans Hornets"
all <- all[order(all$Team,all$rok),]
