get_odds <- function(path)
{
  
  #ustawienie sciezki do folderu z plikiem phantomjs.exe jako WD
  old_wd <- getwd()
  setwd(path)
  
  #ramka danych do agregacji historycznych zakladow
  odds_history <- data.frame(matrix(numeric(0),ncol=8))
  
  
  #sciagamy dane z sezonow 2010/2011 - 2015/2016
  for (year in 1:6)
  {
    
    j=1
    
    #dane znajduja sie w podstronach (kazda z nich zawiera tabele z 50 meczami)
    repeat
    {
      
      #odwolanie do biezacego sezonu jest inne ni¿ do historycznych
      if (year==6){
        
        page <- paste0("http://www.oddsportal.com/basketball/usa/nba/results/#/page/", j, "/")
      } else {
        
        page <- paste0("http://www.oddsportal.com/basketball/usa/nba-201", year-1, "-201", year, "/results/#/page/", j, "/")
      }
      
      
      #stworzenie pliku z kodem javascript w working directory
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
      
      
      #scrapujemy zaklady
      repeat{
        system("./phantomjs scrap_page_file.js")
        whole_page <- readLines(file.path(getwd(), "page_file.html"), warn = FALSE)
        whole_page <- paste0(whole_page, collapse = "")
        whole_page <- read_html(whole_page)
        
        odds <- html_nodes(whole_page, xpath = '//*[contains(@class, "odds-nowrp")]')
        odds <- matrix(html_text(odds), byrow = TRUE, ncol = 2)
        if(nrow(odds)==0){
          break
        }
        odd_example <- suppressWarnings(as.numeric(odds[1,1]))
        if((!is.na(odd_example) & !(odd_example%%1 == 0)) | odds[1,1] == "-"){
          break
        }
        
      }
      
      if(nrow(odds)==0){
        break
      }
      
      #scrapowanie nazw zespolow, wynikow i dat
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
          dates[i] <- dates[i-1]
        }
      }
      dates <- dates[!dates_to_remove]
      dates <- strsplit(dates, " ")
      dates <- unlist(lapply(dates, function(x){
        paste0(x[2], " ", x[1], ", ", x[3])}))
      
      years <- stri_sub(dates, from = -4)
      
      #zlaczenie do tabelki dla jednej podstrony i dodanie do finalnej tabeli
      page_table <- cbind(teams, dates, results, odds, years)
      odds_history <- rbind(odds_history,page_table)
      
      
      
      j=j+1
    }
    
  }
  
  colnames(odds_history) <- c("Host", "Opponent", "Date", "Tm", "Opp", "Tm_odd", "Opp_odd", "Year")
  
  
  #zostawiamy tylko druzyny, dla ktorych mamy staty bez innych meczy
  to_errase<-odds_history$Host %in% team_names$name
  odds_history<-odds_history[to_errase,]
  
  #zamiana nazw na skroty
  Host <- unlist(sapply(odds_history$Host, function(x) team_names[team_names$name==x,2]))
  names(Host)=NULL
  odds_history$Host=as.vector(Host)
  
  Opponent_tmp=unlist(sapply(odds_history$Opponent, function(x) team_names[team_names$name==x, 2]))
  names(Opponent_tmp)=NULL
  odds_history$Opponent=as.vector(Opponent_tmp)
  
  #zamiana brakow danych przy zakladach na 0
  odds_history$Tm_odd<-factor(odds_history$Tm_odd,levels=c(levels(odds_history$Tm_odd),0))
  odds_history$Tm_odd[odds_history$Tm_odd=="-"]<-0
  odds_history$Opp_odd<-factor(odds_history$Opp_odd,levels=c(levels(odds_history$Opp_odd),0))
  odds_history$Opp_odd[odds_history$Opp_odd=="-"]<-0
  
  #sortowanie
  odds_history=odds_history[order(odds_history$Date),]
  
  #usuniecie stworzonych plikow
  file.remove("page_file.html")
  file.remove("scrap_page_file.js")
  
  assign( "odds_history" , odds_history , env = .GlobalEnv )
  setwd(old_wd)
}

get_odds(path="D:\\sgh\\DataScience\\phantomjs-2.1.1-windows\\bin")
write.xlsx(odds_history, "D:\\sgh\\DataScience\\odds_history.xlsx")

