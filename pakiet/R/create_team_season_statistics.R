#' #' Table with team season statistics
#' 
#' Function \code{create_team_season_statistics} creates a table containing team season statistics in a PostgreSQL database
#'
#' @usage create_team_season_statistics(connection)
#'
#' @param connection connection to the database.
#'
#' @return ?????NULL????? TODO
#'
#' @example
#' \dontrun{
#' create_team_season_statistics(connection)}
#'
#' @author XXXXXXXXX
#'
#' @export

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