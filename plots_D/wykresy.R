library(plyr)
library(dplyr)
library(reshape2)
library(ggplot2)
library(stringi)
library(ggmap)

year = 2014
#wykres 1
#ilość zdobytych punktów za dwa i trzy w sezonie zasadniczym z podziałem na konferencje
#
#przygotowanie tabeli
threeVStwo <- function(year) {
  x1 <- plyr::rename(team_stats, c("X2P"="twoP", "X3P"="threeP"))
  x1 <- x1 %>%
    full_join(team_names, by = c("Team" = "shortage")) %>%
    filter(Year == year) %>%
    select(Team, twoP, threeP, Possition, Conference) %>%
    arrange(desc(Conference), Possition)
  
  tmp.tab <- as.character(x1$Team)
  x1<-melt(x1,id.vars=c("Team", "Possition", "Conference")) %>%
    arrange(desc(variable))
  
  x1$Team <- factor(x1$Team, levels = tmp.tab, ordered = TRUE)
  
  #tworzenie wykresóW
  ggplot(x1, aes(x=Team, y=as.numeric(as.character(value)), fill=variable, alpha=Conference)) +
    geom_bar(stat="identity", colour="black") + 
    scale_alpha_manual(values=c(0.4, 1)) +
    ggtitle(paste0('3P and 2P in ',year,' season')) +
    xlab('Teams') + ylab('Points') +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}


#wykres 2
#wykres wstęgowy pokazujący średnią liczbę zdobytych punktów w danym miesiącu przez drużyny w zadanych sezonach
#
#

avgPointsMonth <- function(year) {
  x2.host <- games_story %>%
    filter(Year == year) %>%
    group_by(Host, Month) %>%  
    summarise(Mean_Points = mean(as.numeric(Tm))) %>%
    mutate(freq=n()) %>%
    rename(Team = Host)
  
  x2.opp <- games_story %>%
    filter(Year == year) %>%
    group_by(Opponent, Month) %>%  
    summarise(Mean_Points = mean(as.numeric(Opp))) %>%
    mutate(freq=n()) %>%
    rename(Team = Opponent)
  
  x2 <- rbind(x2.host, x2.opp) %>%
    group_by(Team, Month) %>%
    summarise(Points = weighted.mean(Mean_Points, freq))
  
  g1 <- ggplot(x2) +
    geom_line(aes(x = Month, y = Points, group = Team, colour = Team)) +
    geom_point(aes(x = Month, y = Points, group = Team, colour = Team))
  g1
}


 #wykres 3
#ilość punktów w poszczególnych miastach
pointsMap <- function(year) {
  usa_center = as.numeric(geocode("United States"))
  USAMap = ggmap(get_googlemap(center = usa_center, scale = 2, zoom = 4), extent = "normal")
  
  coordinates <- team_names %>%
    select(City, lon, lat)
  
  games_agr <- games_story %>%
    filter(Year == year) %>%
    group_by(City) %>%
    mutate(Points = as.numeric(Tm) + as.numeric(Opp), Game_Number = n()) %>%
    group_by(City, Game_Number) %>%
    summarise(Points = sum(Points)) %>%
    full_join(coordinates) %>%
    mutate(freq = n(), avgPoints = Points/Game_Number)
  
  
  USAMap +
    geom_point(data = games_agr, aes(x=lon, y=lat, colour = avgPoints, size = Game_Number), alpha = 0.6) +
    scale_color_gradient(low = 'green', high = 'red')
}

