#' Data frame with team names
#' 
#' Function \code{get_team_names} creates data frame with all NBA team names and their abbreviation
#'
#' @usage get_team_names()
#'
#' @param
#'
#' @return ?????NULL????? TODO
#'
#' @example
#' \dontrun{
#' get_team_names()}
#'
#' @author XXXXXXXXX
#'
#' @export

get_team_names <- function()
{
  
  team_names <- data.frame(name=rep("a",30), shortcut=rep('a',30), change_year=rep(NA,30), previous_name=rep(NA,30),
                           previous_shortcut=rep('a',30))
  
  team_names$name <- c("Atlanta Hawks", "Boston Celtics", "Brooklyn Nets", "Charlotte Hornets", "Chicago Bulls",
                       "Cleveland Cavaliers", "Dallas Mavericks", "Denver Nuggets", "Detroit Pistons",
                       "Golden State Warriors", "Houston Rockets", "Indiana Pacers", "Los Angeles Clippers",
                       "Los Angeles Lakers", "Memphis Grizzlies", "Miami Heat", "Milwaukee Bucks",
                       "Minnesota Timberwolves", "New Orleans Pelicans", "New York Knicks", "Oklahoma City Thunder",
                       "Orlando Magic", "Philadelphia 76ers", "Phoenix Suns", "Portland Trail Blazers",
                       "Sacramento Kings", "San Antonio Spurs", "Toronto Raptors", "Utah Jazz", "Washington Wizards")

  team_names$shortcut <- c("ATL", "BOS", "BRK", "CHO", "CHI", "CLE", "DAL", "DEN", "DET", "GSW", "HOU", "IND", "LAC",
                           "LAL", "MEM", "MIA", "MIL", "MIN", "NOP", "NYK", "OKC", "ORL", "PHI", "PHO", "POR", "SAC",
                           "SAS", "TOR", "UTA", "WAS")
  
  team_names$change_year <- c(NA, NA, 2013, 2015, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 2014,
                              NA, 2009, NA, NA, NA, NA, NA, NA, NA, NA, NA)
  
  team_names$previous_shortcut <- c(NA, NA, "NJN", "CHA", NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                                    "NOH", NA, "SEA", NA, NA, NA, NA, NA, NA, NA, NA, NA)
  
  team_names$previous_name <- c(NA, NA, "New Jersey Nets", "Charlotte Bobcats", NA, NA, NA, NA, NA, NA, NA, NA, NA,
                                NA, NA, NA, NA, NA, "New Orleans Hornets", NA, "Seattle SuperSonics", NA, NA, NA, NA,
                                NA, NA, NA, NA, NA)
  
  
  assign("team_names" , team_names, env = .GlobalEnv )
}