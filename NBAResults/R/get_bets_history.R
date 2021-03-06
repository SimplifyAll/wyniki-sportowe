#' Data frame with bookmaker statistics for NBA teams
#'
#' Function \code{get_bets_history} downloads nba games bets from  http://www.oddsportal.com website
#' and creates data frame with them for all NBA teams.
#' Data frame bookmaker statistics from 2011 to 2016.
#'
#' @usage get_bets_history(connection, path)
#'
#' @param connection connection to the database
#' @param path  path where phantomjs.exe file is contained
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' get_bets_history(path)
#' }
#'
#' @note
#' PhantomJS is needed to proper operation of this function.
#' You can download it from http://phantomjs.org/download.html.
#'
#' @author Ania Elsner, Piotr Smuda
#'
#' @export

get_bets_history <- function(connection, path){

   #set path to a folder which contains phantomjs.exe file as a WD
   old_wd <- getwd()
   setwd(path)

   #create data frame designed for aggregation historical bets
   odds_history <- data.frame(matrix(numeric(0), ncol = 8))

   #download data form seasons 2010/2011 - 2015/2016
   for (year in 1:6){
   j <- 1

   #data form one sizon are divided to few tables (each table contains 50 games)
   repeat{

      #path to current season is different
      # if (year == 7){
      #   page <- paste0("http://www.oddsportal.com/basketball/usa/nba/results/#/page/",
      #                  j, "/")
      # } else {
      page <- paste0("http://www.oddsportal.com/basketball/usa/nba-201",
                       year - 1, "-201", year, "/results/#/page/", j, "/")
      #}

      #create file with jascript code in working directory
      scrap_page_file <- paste0("// scrap_page_file.js

                                var webPage = require('webpage');
                                var page = webPage.create();

                                var fs = require('fs');
                                var path = 'page_file.html'

                                page.open(\'", page, "\', function (status) {
                                var content = page.content;
                                fs.write(path,content,'w')
                                phantom.exit();
                                });")
      writeLines(scrap_page_file, file.path(getwd(), "scrap_page_file.js"))

      #bets scraping
      repeat{
         system("./phantomjs scrap_page_file.js")
         whole_page <- readLines(file.path(getwd(), "page_file.html"), warn = FALSE)
         whole_page <- paste0(whole_page, collapse = "")
         whole_page <- read_html(whole_page)

         odds <- html_nodes(whole_page, xpath = '//*[contains(@class, "odds-nowrp")]')
         odds <- matrix(html_text(odds), byrow = TRUE, ncol = 2)
         if(nrow(odds) == 0){
            break
         }
         odd_example <- suppressWarnings(as.numeric(odds[1, 1]))
         if((!is.na(odd_example) & !(odd_example %% 1 == 0)) | odds[1, 1] == "-"){
            break
         }
      }

      if(nrow(odds) == 0){
         break
      }

      #scraping: names, results and dates
      teams <- html_nodes(whole_page, xpath = '//*[@class="name table-participant"]')
      teams <- stri_replace_all_fixed(html_text(teams), "Â", "")
      teams <- strsplit(teams, "-")
      teams <- do.call("rbind", lapply(teams, stri_trim_both))


      results <- html_nodes(whole_page, xpath = '//*[@class="center bold table-odds table-score"]')
      results <- unlist(stri_extract_all_regex(html_text(results), "[0-9]+:[0-9]+"))
      results <- strsplit(results, ":")
      results <- do.call("rbind", lapply(results, stri_trim_both))

      dates <- html_nodes(whole_page, xpath = '//*[contains(@class, "datet")]')
      dates <- html_text(dates)
      dates_to_remove <- stri_detect_regex(dates, "[0-9]+ [a-zA-Z]+ [0-9]+")
      for(i in 1:length(dates)){
         if(!dates_to_remove[i]){
            dates[i] <- dates[i - 1]
         }
      }
      dates <- dates[!dates_to_remove]
      dates <- strsplit(dates, " ")
      dates <- unlist(lapply(dates, function(x){
         paste0(x[2], " ", x[1], ", ", x[3])}))

      years <- as.numeric(paste0("201", year))

      #combine data to one table and aggregate them with previous one
      page_table <- cbind(teams, dates, results, odds, years)
      odds_history <- rbind(odds_history,page_table)

      j <- j + 1
      }
   }

   colnames(odds_history) <- c("Host", "Opponent", "Date", "Tm", "Opp", "Tm_bet", "Opp_bet", "Season")

   teams_names <- read_teams_names_table(connection)

   #we left only teams which we have stats for
   to_errase <- odds_history$Host %in% teams_names$current_name
   odds_history <- odds_history[to_errase,]

   #change names for short cut
   Host <- unlist(sapply(odds_history$Host, function(x) teams_names[teams_names$current_name == x, 2]))
   names(Host) <- NULL
   odds_history$Host <- as.vector(Host)

   Opponent_tmp <- unlist(sapply(odds_history$Opponent, function(x) teams_names[teams_names$current_name == x, 2]))
   names(Opponent_tmp) <- NULL
   odds_history$Opponent <- as.vector(Opponent_tmp)

   #change odds for games with no such an info for 0
   odds_history$Tm_bet <- factor(odds_history$Tm_bet,levels = c(levels(odds_history$Tm_bet), 0))
   odds_history$Tm_bet[odds_history$Tm_bet == "-"] <- 0
   odds_history$Opp_bet <- factor(odds_history$Opp_bet,levels = c(levels(odds_history$Opp_bet), 0))
   odds_history$Opp_bet[odds_history$Opp_bet == "-"] <- 0

   #change factors for numeric
   for(i in 4:8){
      odds_history[, i] <- as.numeric(as.character(odds_history[, i]))
   }

   #change of dates format
   old_locale <- Sys.getlocale("LC_TIME")
   Sys.setlocale("LC_TIME", "English_UK")
   odds_history$Date <- as.Date(as.character(odds_history$Date), "%b %d, %Y")
   Sys.setlocale("LC_TIME", old_locale)

   #sorting
   odds_history <- odds_history[order(odds_history$Date),]

   #delete files that has been created
   file.remove("page_file.html")
   file.remove("scrap_page_file.js")

   assign("bets_history", odds_history, env = .GlobalEnv)
   setwd(old_wd)
}
