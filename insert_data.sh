#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
if [[ $WINNER != "winner" ]]
then 
  TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  if [[ -z $TEAM_ID_WINNER ]]
  then
    INSERT_TEAM_WINNER=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")    
    TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi

  TEAM_ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  if [[ -z $TEAM_ID_OPPONENT ]]
  then
    INSERT_TEAM_OPPONENT=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")    
    TEAM_ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi
  INSERT_GAME=$($PSQL "INSERT INTO games (year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ('$YEAR', '$ROUND', '$TEAM_ID_WINNER', '$TEAM_ID_OPPONENT', '$WINNER_GOALS', '$OPPONENT_GOALS')")  
  if [[ $INSERT_GAME == "INSERT 0 1" ]]
  then
    echo Inserted team, $YEAR $WINNER $TEAM_ID_WINNER $TEAM_ID_OPPONENT $WINNER_GOALS $OPPONENT_GOALS
  fi  

fi
done


