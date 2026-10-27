#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

set -e

declare -A teams_seen
while IFS="," read -r year round winner opponent winner_goals opponent_goals
do
  if [[ "$year" == "year" || -z "$year" ]]; then
    continue
  fi
  teams_seen["$winner"]=1
  teams_seen["$opponent"]=1
done < games.csv

team_values=""
for team in "${!teams_seen[@]}"
do
  team_values+="('$team'),"
done
team_values=${team_values%,}
$PSQL "INSERT INTO teams(name) VALUES $team_values ON CONFLICT (name) DO NOTHING"

declare -A team_ids
while IFS="|" read -r team_id team_name
do
  team_ids["$team_name"]=$team_id
done < <($PSQL "SELECT team_id, name FROM teams")

game_values=""
while IFS="," read -r year round winner opponent winner_goals opponent_goals
do
  if [[ "$year" == "year" || -z "$year" ]]; then
    continue
  fi
  game_values+="($year, '$round', ${team_ids[$winner]}, ${team_ids[$opponent]}, $winner_goals, $opponent_goals),"
done < games.csv
game_values=${game_values%,}
$PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES $game_values"
