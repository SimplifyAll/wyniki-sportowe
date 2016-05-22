library(RPostgreSQL) #do not user require(), require = try, library = do or fail
connect <- function(){
  pw <- {
    "dataScience"
  }
  driver <- dbDriver("PostgreSQL")
  con <- dbConnect(driver, dbname="basketball", 
                   host= "localhost", port=5432,
                   user="kndatascience", password=pw )
  rm(pw)
  return(con)
}

create_betting_firms <- function(connection){
  sql_command <- "CREATE TABLE betting_firms (
  name varchar(64),
  CONSTRAINT betting_firms_pk PRIMARY KEY (name)
  )
  WITH (
    OIDS=FALSE
  );"
  dbSendQuery(conn = connection, statement = sql_command)
}

create_teams <- function(connection){
  sql_command <- "CREATE TABLE teams (
  current_name  varchar(30),
  id            varchar(4) NOT NULL,
  change_year   varchar(4),
  previous_name varchar(30),
  previous_abr  varchar(8),
  CONSTRAINT teams_pk PRIMARY KEY (id)
  )
  WITH (
    OIDS=FALSE
  );"
  dbSendQuery(conn=connection, statement = sql_command)
}

create_seasons <- function(connection) {
  sql_command <- "CREATE TABLE seasons (
  yearStart varchar(4),
  CONSTRAINT seasons_pk PRIMARY KEY (yearStart)
  )
  WITH (
    OIDS=FALSE
  );"
  dbSendQuery(conn=connection, statement = sql_command)
}

create_team_season_statistics <- function(connection) {
  sql_command <- "CREATE TABLE team_season_statistics (
  team_id					  	      	varchar(4) NOT NULL,
  game_num					        	integer,
  min_play					        	integer,
  total_field_goals		    		integer,
  total_field_goals_a 	  		integer,
  total_field_goals_p		  		real,
  total_3Ps					        	integer,
  total_3P_attempts		    		integer,
  total_3P_p			      			real,
  total_2Ps					        	integer,
  total_2P_attempts		    		integer,
  total_2P_p					      	real,
  total_free_throws			    	integer,
  total_free_throw_attempts		integer,
  total_free_throw_p			  	real,
  total_offensive_rebounds		integer,
  total_defensive_rebounds		integer,
  total_rebounds		    			integer,
  total_assists			      		integer,
  total_steals			      		integer,
  total_blocks			      		integer,
  total_turnovers		    			integer,
  total_personal_fauls	  		integer,
  total_points				      	integer,
  pergame_points			    		real,
  
  op_field_goals		    			integer,
  op_field_goals_a 	    			integer,
  op_field_goals_p	    			real,
  op_3Ps					        		integer,
  op_3P_attempts	    				integer,
  op_3P_p					        		real,
  op_2Ps				        			integer,
  op_2P_attempts    					integer,
  op_2P_p						        	real,
  op_free_throws		    			integer,
  op_free_throw_attempts			integer,
  op_free_throw_p			    		real,
  op_offensive_rebounds	  		integer,
  op_defensive_rebounds	  		integer,
  op_rebounds			      			integer,
  op_assists		      				integer,
  op_steals			        			integer,
  op_blocks			        			integer,
  op_turnovers		      			integer,
  op_personal_fauls	    			integer,
  op_points					        	integer,
  op_pergame_points	    			real,
  
  age			              			real,
  pred_win			        			integer,
  pred_lose			        			integer,
  margin_v			        			real,
  str_s			             			real,
  simple_rate			        		real,
  off_rate		        				real,
  deff_rate			        			real,
  pace_f			        				real,
  free_throw_rate	    				real,
  g3p_rate					        	real,
  true_shoot				      		real,
  eff_goals				        		real,
  turnover_p			      			real,
  off_reb_p				        		real,
  perfield_free_throw_p		  	real,
  opp_eff_goals_p				    	real,
  opp_turnover_p			    		real,
  def_reb_p					        	real,
  opp_perfield_goal_attempt		real,
  arena						          	varchar(50),
  attendance			      			real,
  
  season					        		varchar(4) NOT NULL,
  CONSTRAINT team_season_stats_pk PRIMARY KEY (team_id, season)
  )
  WITH (
  OIDS=FALSE
  );"
  dbSendQuery(conn=connection, statement = sql_command)
  sql_command <- "ALTER TABLE team_season_statistics
  ADD CONSTRAINT team_name_fkey FOREIGN KEY (team_id) REFERENCES teams(id);"
  dbSendQuery(conn=connection, statement = sql_command)
  sql_command <- "ALTER TABLE team_season_statistics
  ADD CONSTRAINT season_fkey FOREIGN KEY (season) REFERENCES seasons(yearStart);"
  dbSendQuery(conn=connection, statement = sql_command)
}

create_games <- function(connection){
  sql_command <- "CREATE TABLE games (
  id                        integer,
  team_1_id                 varchar(4) NOT NULL,
  team_2_id                 varchar(4) NOT NULL,
  game_date                 date,
  team_1_score              integer,
  team_2_score              integer,
  if_win                    integer,
  season                    varchar(4) NOT NULL,
  CONSTRAINT games_pk PRIMARY KEY (id)
  )
  WITH (
    OIDS=FALSE
  );"
  dbSendQuery(conn=connection, statement = sql_command)
  sql_command <- "ALTER TABLE games
  ADD CONSTRAINT team_1_name_fkey FOREIGN KEY (team_1_id) REFERENCES teams(id);"
  dbSendQuery(conn=connection, statement = sql_command)
  sql_command <- "ALTER TABLE games
  ADD CONSTRAINT team_2_name_fkey FOREIGN KEY (team_2_id) REFERENCES teams(id);"
  dbSendQuery(conn=connection, statement = sql_command)
  sql_command <- "ALTER TABLE games
  ADD CONSTRAINT season_fkey FOREIGN KEY (season) REFERENCES seasons(yearStart);"
  dbSendQuery(conn=connection, statement = sql_command)
}

create_bets <-function(connection){
  sql_command <- "CREATE TABLE bets (
  team_1_chances      integer,
  team_2_chances      integer,
  bet_time            timestamp,
  bet_firm            varchar(64),
  game_id             integer,
  CONSTRAINT bets_pk PRIMARY KEY (game_id, bet_firm, bet_time)
  )
  WITH (
    OIDS=FALSE
  );"
  dbSendQuery(conn=connection, statement = sql_command)
  sql_command <- "ALTER TABLE bets
  ADD CONSTRAINT game_id_fkey FOREIGN KEY (game_id) REFERENCES games(id);"
  dbSendQuery(conn=connection, statement = sql_command)
  sql_command <- "ALTER TABLE bets
  ADD CONSTRAINT bet_firm_fkey FOREIGN KEY (bet_firm) REFERENCES betting_firms(name);"
  dbSendQuery(conn=connection, statement = sql_command)
}

create_DB <- function(connection){
  create_betting_firms(connection = connection)
  create_teams(connection = connection)
  create_seasons(connection = connection)
  create_team_season_statistics(connection = connection)
  create_games(connection = connection)
  create_bets(connection = connection)
}

write_teams <- function(connection, cleanUp){
  get_team_names()
  dbWriteTable(connection, "teams", 
             value = team_names, append = TRUE, row.names = FALSE)
  if(cleanUp)
    rm(team_names)
}

write_seasons <- function(connection) {
  dbWriteTable(connection, "seasons", value = data.frame(season=as.character(c(2011:2016))),
                           append = TRUE, row.names = FALSE)
}

write_games_story <- function(connection, cleanUp){
  get_games_story()
  games_story <- data.frame(id=t(t(c(1:nrow(games_story)))),games_story)
  dbWriteTable(connection, "games", value = games_story, append = TRUE, row.names = FALSE)
  if(cleanUp)
    rm(games_story)
}

write_team_season_stats <- function(connection, cleanUp){
  get_stats()
  dbWriteTable(connection, "team_season_statistics", value = stats, append = TRUE, row.names = FALSE)
  if(cleanUp)
    rm(stats)
}

setup_environment <- function(){
  con = connect()
  print("Created Connection")
  create_DB(connection = con)
  print("Database Constructed")
  write_teams(connection = con, FALSE)
  print("Teams inserted")
  write_seasons(connection = con)
  print("Seasons inserted")
  write_games_story(connection = con, FALSE)
  print("Games inserted")
  write_team_season_stats(connection = con, FALSE)
  print("Statistics Inserted")
  disconnect(connection = con)
  print("Setup Finished disconnecting from DB")
}




dropDB <- function(connection){
  sql_command <- "DROP TABLE IF EXISTS bets;"
  dbSendQuery(conn=connection, statement=sql_command)
  sql_command <- "DROP TABLE IF EXISTS betting_firms;"
  dbSendQuery(conn=connection, statement=sql_command)
  sql_command <- "DROP TABLE IF EXISTS games;"
  dbSendQuery(conn=connection, statement=sql_command)
  sql_command <- "DROP TABLE IF EXISTS team_season_statistics;"
  dbSendQuery(conn=connection, statement=sql_command)
  sql_command <- "DROP TABLE IF EXISTS seasons;"
  dbSendQuery(conn=connection, statement=sql_command)
  sql_command <- "DROP TABLE IF EXISTS teams;"
  dbSendQuery(conn=connection, statement=sql_command)
}

disconnect <- function(connection){
  dbDisconnect(connection)
}