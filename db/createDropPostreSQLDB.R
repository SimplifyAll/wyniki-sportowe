#install package if not yet present, make sure to have libpq-dev
#https://code.google.com/archive/p/rpostgresql/ link to te rpostgresql package
install.packages("RPostgreSQL")

#Skrypt tworzy bazę
#TODO: zenkapsulować do trzech funkcji: connect(), disconnect(), create(), delete()
#Przed odpaleniem należy stworzyć w bazie tabelę test

library(RPostgreSQL) #do not user require(), require = try, library = do or fail

pw <- {
  "dataScience"
}

driver <- dbDriver("PostgreSQL")

con <- dbConnect(driver, dbname="basketball", 
                 host= "localhost", port=5432,
                 user="kndatascience", password=pw )
rm(pw)#remove password

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
game_num                      integer,
min_play                      integer,
field_goals                   integer,
field_goals_a                 integer,
field_goals_p                 integer,
pergame_3Ps                   real,
pergame_3P_attempts           real,
pergame_3P_p                  real,
pergame_2Ps                   real,
pergame_2P_attempts           real,
pergame_2P_p                  real,
pergame_free_throws           real,
pergame_free_throw_attempts   real,
pergame_free_throw_p           real,
pergame_offensive_rebounds    real,
pergame_defensive_rebounds    real,
total_defensive_rebounds      real,
pergame_assists               real,
pergame_steals                real,
pergame_blocks                real,
pergame_turnovers             real,
pergame_personal_fauls        real,
points_general                real,
pergame_points                real,
op_field_goals                   integer,
op_field_goals_a                 integer,
op_field_goals_p                 integer,
op_pergame_3Ps                   real,
op_pergame_3P_attempts           real,
op_pergame_3P_p                  real,
op_pergame_2Ps                   real,
op_pergame_2P_attempts           real,
op_pergame_2P_p                  real,
op_pergame_free_throws           real,
op_pergame_free_throw_attempts   real,
op_pergame_free_throw_p           real,
op_pergame_offensive_rebounds    real,
op_pergame_defensive_rebounds    real,
op_total_defensive_rebounds      real,
op_pergame_assists               real,
op_pergame_steals                real,
op_pergame_blocks                real,
op_pergame_turnovers             real,
op_pergame_personal_fauls        real,
op_points_general                real,
op_pergame_points                real,
age                              real,
pred_win                          real,
pred_lose                         real,
margin_v                          real,
str_s                             real,
simple_rate                       real,
off_rate                          real,
deff_rate                         real,
pace_f                            real,
free_throw_rate                   real,
g3p_rate                           real,
true_shoot                        real,
eff_goals                         real,
turnover_p                        real,
off_reb_p                         real,
perfield_free_throw_p              real,
opp_eff_goals_p                   real,
opp_turnover_p                    real,
def_reb_p                         real,
opp_perfield_goal_attempt         real,
arena                             varchar(50),
attendance                        real,
season                        varchar(4) NOT NULL,
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
  id                        integer,
  team_1_id               varchar(4) NOT NULL,
  team_2_id               varchar(4) NOT NULL,
  game_date                 date,
  team_1_score              integer,
  team_2_score              integer,
  if_win                    character,
  season                    varchar(4) NOT NULL,
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


# INSERT
#dbSendPreparedQuery(con, "INSERT INTO teams() VALUES (?,?,?,?,?)", team.names) w przypadku 
dbWriteTable(con, "teams", 
             value = team.names, append = TRUE, row.names = FALSE)
games.story <- data.frame(id=t(t(c(1:nrow(games.story)))),games.story[,-7])
dbWriteTable(con, "seasons", value = data.frame(season=as.character(c(2011:2015))), append = TRUE, row.names = FALSE)
dbWriteTable(con, "games", value = games.story[,-7], append = TRUE, row.names = FALSE)



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

