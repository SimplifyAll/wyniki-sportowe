#install package if not yet present, make sure to have libpq-dev
#https://code.google.com/archive/p/rpostgresql/ link to te rpostgresql package
#install.packages("RPostgreSQL")

#Skrypt tworzy bazę
#TODO: zenkapsulować do trzech funkcji: connect(), disconnect(), create(), delete()
#Przed odpaleniem należy stworzyć w bazie tabelę test

library(RPostgreSQL) #do not user require(), require = try, library = do or fail

pw <- {
  "haslo"
}

driver <- dbDriver("PostgreSQL")

con <- dbConnect(driver, dbname="datascience", 
                 host= "localhost", port=5432,
                 user="postgres", password=pw )
rm(pw)#remove password

#simple test to see if connected
if(!dbExistsTable(con, "test")){
  stop()
}

#CREATE DB

sql_command <- "CREATE TABLE betting_firms (
  name varchar(64),
  CONSTRAINT betting_firms_pk PRIMARY KEY (name)
)
WITH (
  OIDS=FALSE
);"
dbSendQuery(conn=con, statement = sql_command)

sql_command <- "CREATE TABLE teams (
  id            SERIAL,
  current_name  varchar(8),
  previous_name varchar(8),
  change_year   varchar(4),
  CONSTRAINT teams_pk PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);"
dbSendQuery(conn=con, statement = sql_command)

sql_command <- "CREATE TABLE seasons (
  yearStart varchar(4),
  CONSTRAINT seasons_pk PRIMARY KEY (yearStart)
)
WITH (
  OIDS=FALSE
);"
dbSendQuery(conn=con, statement = sql_command)

sql_command <- "CREATE TABLE team_season_statistics (
  team_id                       varchar(4) NOT NULL,
  season                        integer NOT NULL,
  wins_num                      integer,
  losses_num                    integer,
  season_finish_position        integer,
  srs                           real,
  pace                          real,
  offensive_rating              real,
  defensive_rating              real,
  pergame_field_goals           real,
  pergame_field_goal_attempts   real,
  pergame_3Ps                   real,
  pergame_3P_attempts           real,
  pergame_2Ps                   real,
  pergame_2P_attempts           real,
  pergame_free_throws           real,
  pergame_free_throw_attempts   real,
  pergame_offensive_rebounds    real,
  pergame_defensive_rebounds    real,
  pergame_assists               real,
  pergame_steals                real,
  pergame_blocks                real,
  pergame_turnovers             real,
  pergame_personal_fauls        real,
  season_field_goals            integer,
  season_field_goal_attempts    integer,
  season_3Ps                    integer,
  season_3P_attempts            integer,
  season_2Ps                    integer,
  season_2P_attempts            integer,
  season_free_throws            integer,
  season_free_throw_attempts    integer,
  season_offensive_rebounds     integer,
  season_defensive_rebounds     integer,
  season_assists                integer,
  season_steals                 integer,
  season_blocks                 integer,
  season_turnovers              integer,
  season_personal_fauls         integer,
  CONSTRAINT team_season_stats_pk PRIMARY KEY (team_id, season)
)
WITH (
    OIDS=FALSE
);"
dbSendQuery(conn=con, statement = sql_command)
sql_command <- "ALTER TABLE team_season_statistics
ADD CONSTRAINT team_name_fkey FOREIGN KEY (team_id) REFERENCES teams(id);"
dbSendQuery(conn=con, statement = sql_command)
sql_command <- "ALTER TABLE team_season_statistics
ADD CONSTRAINT season_fkey FOREIGN KEY (season) REFERENCES seasons(yearStart);"
dbSendQuery(conn=con, statement = sql_command)

sql_command <- "CREATE TABLE games (
  id                        serial,
  game_date                 date,
  is_team_1_home            boolean,
  team_1_id               integer NOT NULL,
  team_2_id               integer NOT NULL,
  team_1_score              integer,
  team_2_score              integer,
  season                    varchar(4) NOT NULL,
  game_field_goals               integer,
  game_filed_goal_attempts       integer,
  game_2Ps                       integer,
  game_2P_attempts               integer,
  game_3Ps                       integer,
  game_3P_attempts               integer,
  game_free_throws               integer,
  game_free_throw_attempts       integer,
  game_offensive_rebounds        integer,
  game_defensive_rebounds        integer,
  game_assists                   integer,
  game_steals                    integer,
  game_blocks                    integer,
  game_turnovers                 integer,
  game_personal_fauls            integer,
  CONSTRAINT games_pk PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);"
dbSendQuery(conn=con, statement = sql_command)
sql_command <- "ALTER TABLE games
ADD CONSTRAINT team_1_name_fkey FOREIGN KEY (team_1_id) REFERENCES teams(id);"
dbSendQuery(conn=con, statement = sql_command)
sql_command <- "ALTER TABLE games
ADD CONSTRAINT team_2_name_fkey FOREIGN KEY (team_2_id) REFERENCES teams(id);"
dbSendQuery(conn=con, statement = sql_command)
sql_command <- "ALTER TABLE games
ADD CONSTRAINT season_fkey FOREIGN KEY (season) REFERENCES seasons(yearStart);"
dbSendQuery(conn=con, statement = sql_command)

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
dbSendQuery(conn=con, statement = sql_command)
sql_command <- "ALTER TABLE bets
ADD CONSTRAINT game_id_fkey FOREIGN KEY (game_id) REFERENCES games(id);"
dbSendQuery(conn=con, statement = sql_command)
sql_command <- "ALTER TABLE bets
ADD CONSTRAINT bet_firm_fkey FOREIGN KEY (bet_firm) REFERENCES betting_firms(name);"
dbSendQuery(conn=con, statement = sql_command)

#DROP DB TABLES
sql_command <- "DROP TABLE IF EXISTS bets;"
dbSendQuery(conn=con, statement=sql_command)
sql_command <- "DROP TABLE IF EXISTS betting_firms;"
dbSendQuery(conn=con, statement=sql_command)
sql_command <- "DROP TABLE IF EXISTS games;"
dbSendQuery(conn=con, statement=sql_command)
sql_command <- "DROP TABLE IF EXISTS team_season_statistics;"
dbSendQuery(conn=con, statement=sql_command)
sql_command <- "DROP TABLE IF EXISTS seasons;"
dbSendQuery(conn=con, statement=sql_command)
sql_command <- "DROP TABLE IF EXISTS teams;"
dbSendQuery(conn=con, statement=sql_command)

dbDisconnect(con)
