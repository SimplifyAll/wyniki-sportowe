library(plotly)
library(dplyr)

year = 2014

coordinates <- teams_names %>%
  select(id, City, lon, lat) %>%
  unique()

#prepare data
games_agr <- merge(games_story, coordinates, by.x = 'team_1_id', by.y = "id", all = TRUE)  %>%
  filter(season == year) %>%
  group_by(City) %>%
  mutate(Points = as.numeric(team_1_score) + as.numeric(team_2_score), Game_Number = n()) %>%
  group_by(City, Game_Number, lon, lat) %>%
  summarise(Points = sum(Points)) %>%
  mutate(freq = n(), avgPoints = Points/Game_Number)

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
    x = ~lon, y = ~lat, size = ~avgPoints, color = ~Game_Number, hoverinfo = "text",
    text = ~paste(games_agr$City, "<br />", games_agr$avgPoints, " mean points per game")
  ) %>%
  layout(title = paste('Mean points per game<br>Season', year, '<br>(Click legend to toggle)', sep = " "), geo = g)
p






#--------------------------------
#stare
#--------------------------------
#wykres 3
#ilość punktów w poszczególnych miastach
#pointsMap <- function(year) {
#usa_center = as.numeric(geocode("United States"))
#USAMap = ggmap(get_googlemap(center = usa_center, scale = 2, zoom = 4), extent = "normal")
#
#USAMap <- USAMap +
#  geom_point(data = games_agr, aes(x=lon, y=lat, colour = avgPoints, size = Game_Number), alpha = 0.6) +
#  scale_color_gradient(low = 'green', high = 'red')
#ggplotly(USAMap)
#}
