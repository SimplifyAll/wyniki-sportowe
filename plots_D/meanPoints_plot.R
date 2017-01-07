library(dplyr)
library(reshape2)
library(ggplot2)
library(stringi)
library(plotly)

#wykres 2
#wykres wstÄ™gowy pokazujÄ…cy Ĺ›redniÄ… liczbÄ™ zdobytych punktĂłw w danym miesiÄ…cu przez druĹĽyny w zadanych sezonach
#
#
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
  xlab('Months') + ylab('Mean Points per Game') +
  ggtitle(paste('Comparison of mean points per game in season',year, sep = " "))
ggplotly(g1)