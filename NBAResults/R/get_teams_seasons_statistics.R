#' Data frame with teams' statistics
#'
#' Function \code{get_teams_seasons_statistics} downloads team statistics from
#' the basketball-reference.com website and creates data frame with them for all
#' NBA teams.
#' Data frame contains statistics from 2011 to 2016.
#'
#' @usage get_teams_seasons_statistics(connection)
#'
#' @param connection connection to the database
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' get_teams_seasons_statistics()
#' }
#'
#' @author Szymon Bazyluk, Aliaksandr Panimash, Piotr Smuda
#'
#' @export

get_teams_seasons_statistics <- function(connection){

   team_stats <- data.frame(matrix(numeric(0), ncol = 25))
   opponent_stats <- data.frame(matrix(numeric(0), ncol = 25))
   miscellaneous_stats <- data.frame(matrix(numeric(0), ncol = 25))


   for(i in 1:6){
      Year <- paste0("201", i)
      html <- paste0("http://www.basketball-reference.com/leagues/NBA_", Year, ".html")
      URL <- readLines(html)
      URL <- paste(URL, collapse = "")
      URL <- gsub("<!--|-->", "", URL)
      URL <- read_html(URL)

      team_tmp <- URL %>% html_nodes("#team-stats-base")
      team_tmp <- html_table(team_tmp)[[1]]
      team_tmp$Team <- gsub('\\*', '', team_tmp$Team)
      team_tmp <- cbind(team_tmp, Year)
      team_tmp <- team_tmp[1:30, 2:26]

      nazwy <- names(team_tmp)
      names(team_stats) <- nazwy
      team_stats <- rbind(team_stats, team_tmp)


      opponent_tmp <- URL %>% html_nodes("#opponent-stats-base")
      opponent_tmp <- html_table(opponent_tmp)[[1]]
      opponent_tmp$Team <- gsub('\\*', '',opponent_tmp$Team)
      opponent_tmp <- cbind(opponent_tmp, Year)
      opponent_tmp <- opponent_tmp[1:30, 2:26]
      nazwy <- names(opponent_tmp)
      names(opponent_stats) <- nazwy
      opponent_stats <- rbind(opponent_stats, opponent_tmp)

      miscellaneous_tmp <- URL %>% html_nodes("#misc_stats")
      miscellaneous_tmp <- html_table(miscellaneous_tmp)[[1]]
      nazwy <- as.character(miscellaneous_tmp[1, -1])
      miscellaneous_tmp <- miscellaneous_tmp[2:31, 2:24]
      miscellaneous_tmp <- cbind(miscellaneous_tmp, Year)
      names(miscellaneous_tmp) <- c(nazwy, "Year")
      miscellaneous_tmp$Team <- gsub('\\*', '', miscellaneous_tmp$Team)
      names(miscellaneous_stats) <- c(nazwy, "Year")
      miscellaneous_stats <- rbind(miscellaneous_stats, miscellaneous_tmp)
   }

   team_stats  <- team_stats[order(team_stats$Team,team_stats$Year),]
   opponent_stats <- opponent_stats[order(opponent_stats$Team,opponent_stats$Year),]
   miscellaneous_stats <- miscellaneous_stats[order(miscellaneous_stats$Team,miscellaneous_stats$Year),]

   stats <- cbind(team_stats[1:24], opponent_stats[4:24], miscellaneous_stats[2:24])

   stats$Team[stats$Team == "Charlotte Hornets"] <- "Charlotte Bobcats"
   stats$Team[stats$Team == "New Jersey Nets"] <- "Brooklyn Nets"
   stats$Team[stats$Team == "New Orleans Pelicans"] <- "New Orleans Hornets"
   stats <- stats[order(stats$Team,stats$Year),]

   colnames(stats)[25:45] <- paste0("O", names(stats[25:45]))

   teams_names <- read_teams_names_table(connection)

   stats$Team <- sapply(stats$Team, function(x) teams_names[teams_names$current_name == x, 2])

   for(k in c(2:65)){
      stats[, k] <- as.numeric(stats[, k])
   }
   stats$Team = as.character(stats$Team)
   stats$Team[19:24] = "CHO"
   stats$Team[109:114] = "NOP"
   stats$Attendance = as.numeric(gsub(",", "", stats$Attendance))
   stats$Year = as.character(stats$Year)

   assign("teams_seasons_statistics", stats, env = .GlobalEnv)
}
