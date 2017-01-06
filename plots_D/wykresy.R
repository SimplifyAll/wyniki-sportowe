#library(plyr)
library(dplyr)
library(reshape2)
library(ggplot2)
library(stringi)
library(OpenStreetMap)
library(plotly)
#library(ggmap)

year = 2014
#wykres 1
#ilość zdobytych punktów za dwa i trzy w sezonie zasadniczym z podziałem na konferencje
#
#przygotowanie tabeli
threeVStwo <- function(year) {
  x1 <- teams_seasons_statistics %>%
    full_join(teams_names, by = c("team_id" = "id")) %>%
    filter(season == year) %>%
    select(team_id, total_2ps, total_3ps, Possition, Conference) %>%
    mutate(total_2ps = total_2ps - total_3ps) %>%
    arrange(desc(Conference), Possition)
  
  teams_levels <- as.character(x1$team_id)
  x1<-melt(x1,id.vars=c("team_id", "Possition", "Conference")) %>%
    arrange(desc(variable))
  
  x1$team_id <- factor(x1$team_id, levels = teams_levels, ordered = TRUE)
  
  #tworzenie wykresóW
  plot <- ggplot(x1, aes(x=team_id, y=as.numeric(as.character(value)), fill=variable, alpha=Conference)) +
    geom_bar(stat="identity", colour="black") + 
    scale_alpha_manual(values=c(0.4, 1)) +
    ggtitle(paste0('3P and 2P in ',year,' season')) +
    xlab('Teams') + ylab('Points') +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    coord_flip()
  ggplotly(plot)
}


#wykres 2
#wykres wstęgowy pokazujący średnią liczbę zdobytych punktów w danym miesiącu przez drużyny w zadanych sezonach
#
#

avgPointsMonth <- function(year) {
  x2.host <- games_story %>%
    filter(season == year) %>%
    group_by(team_1_id, Month) %>%  
    summarise(Mean_Points = mean(as.numeric(team_1_score))) %>%
    mutate(freq=n()) %>%
    rename(Team = team_1_id)
  
  x2.opp <- games_story %>%
    filter(season == year) %>%
    group_by(team_2_id, Month) %>%  
    summarise(Mean_Points = mean(as.numeric(team_2_score))) %>%
    mutate(freq=n()) %>%
    rename(Team = team_2_id)
  
  x2 <- rbind(x2.host, x2.opp) %>%
    group_by(Team, Month) %>%
    summarise(Points = weighted.mean(Mean_Points, freq))
  
  g1 <- ggplot(x2, aes(factor(Month) , Points)) +
    geom_boxplot() +
    xlab('Months') + ylab('Mean Points')
  ggplotly(g1)
 }


 #wykres 3
#ilość punktów w poszczególnych miastach

map <- openmap(c(50,-128), c(22,-65), type = "osm-wanderreitkarte")
plot(map)

#pointsMap <- function(year) {
  usa_center = as.numeric(geocode("United States"))
  USAMap = ggmap(get_googlemap(center = usa_center, scale = 2, zoom = 4), extent = "normal")
  
  coordinates <- teams_names %>%
    select(City, lon, lat)
  
  #prepare data
  games_agr <- games_story %>%
    filter(season == year) %>%
    group_by(City) %>%
    mutate(Points = as.numeric(team_1_score) + as.numeric(team_2_score), Game_Number = n()) %>%
    group_by(City, Game_Number) %>%
    summarise(Points = sum(Points)) %>%
    full_join(coordinates) %>%
    mutate(freq = n(), avgPoints = Points/Game_Number) %>%
    select(City, avgPoints, lon, lat)
  
  #prepare map layout
  g <- list(
    scope = 'usa',
    projection = list(type = 'albers usa'),
    showland = TRUE,
    landcolor = toRGB("gray85"),
    subunitwidth = 1,
    countrywidth = 1,
    subunitcolor = toRGB("white"),
    countrycolor = toRGB("white")
  )
  
  #prepare plot
  p <- plot_geo(games_agr, locationmode = 'USA-states', sizes = c(1, 250)) %>%
    add_markers(
      x = ~lon, y = ~lat, size = ~avgPoints, color = ~q, hoverinfo = "text",
      text = ~paste(games_agr$City, "<br />", games_agr$avgPoints, " mean points per game")
    ) %>%
    layout(title = paste('Mean points per game<br>Season', year, '<br>(Click legend to toggle)', sep = " "), geo = g)
  p
  #USAMap +
   # geom_point(data = games_agr, aes(x=lon, y=lat, colour = avgPoints, size = Game_Number), alpha = 0.6) +
    #scale_color_gradient(low = 'green', high = 'red')
#}

