library(dplyr)
library(reshape2)
library(ggplot2)
library(stringi)
library(plotly)

year = 2014
#wykres 1
#iloĹ›Ä‡ zdobytych punktĂłw za dwa i trzy w sezonie zasadniczym z podziaĹ‚em na konferencje
#
#przygotowanie tabeli
  season_score <- teams_seasons_statistics %>%
    full_join(teams_names, by = c("team_id" = "id")) %>%
    filter(season == year) %>%
    select(team_id, total_2ps, total_3ps, Possition, Conference) %>%
    #mutate(total_2ps = total_2ps + total_3ps) %>%
    arrange(desc(Conference), Possition) %>%
    rename(`Total Score` = total_2ps, `3 Points Shots Score` = total_3ps, Team = team_id)
  
  teams_levels <- as.character(season_score$Team)
  
  season_score<-melt(season_score,id.vars=c("Team", "Possition", "Conference")) %>%
    arrange(desc(variable)) %>%
    mutate(value = as.numeric(as.character(value))) %>%
    rename(Points = value, `Points Type` = variable)
  type_levels <- c("3 Points Shots Score", "Total Score")
  
  season_score$Team <- factor(season_score$Team, levels = teams_levels, ordered = TRUE)
  season_score$`Points Type` <- factor(season_score$`Points Type`, levels = type_levels, ordered = TRUE)
  
  #tworzenie wykresĂłW
  plot <- ggplot(season_score, aes(x=Team, y=Points, fill=`Points Type`, alpha=Conference)) +
    geom_bar(stat="identity", colour="black") + 
    scale_alpha_manual(values=c(0.4, 1)) +
    ggtitle(paste0('3P and 2P in ',year,' season')) +
    xlab('Teams') + ylab('Points') +
    #theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    coord_flip()
  #plot
  ggplotly(plot)
  
  
#---------------------------
#plotly war
#---------------------------
  