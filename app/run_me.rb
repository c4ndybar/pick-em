require_relative 'football_season'
require_relative 'pick_analyzer'
require_relative 'helper'

current_week = 7
end_week = 14
spread_file = '../spreads.csv'
previous_picks_file = '../previous_picks.csv'
scores_file = '../actual_scores.csv'
teams_file = '../teams.csv'

season = FootballSeason.new(spread_file)

def print_picks(picks, previous_picks, current_week, season)
  puts "Previous picks are: #{previous_picks}"
  puts ''
  picks.each { |week, team| puts "week #{week} - #{team} - #{season.get_games_for_team_and_week(team, week)}" }
  puts ''
  season.get_games_for_week(current_week).each { |game| puts game }
end

def get_picks_for_season(season, previous_picks, current_week, end_week)
  pick_analyzer = PickAnalyzer.new(season)
  teams = season.teams - previous_picks

  pick_analyzer.pick_optimal_teams_for_weeks(current_week, end_week, teams)
end

def get_team_modifiers(season, teams, scores_file)
  team_scores = Hash.new(0)
  team_modifiers = Hash.new
  spreads = Hash.new(0)
  CSV.foreach(scores_file) do |row|
    week = row[0].to_i
    away_team = teams[row[1]]
    home_team = teams[row[2]]
    away_score = row[3].strip.to_i
    home_score = row[4].strip.to_i
    team_scores[away_team] += home_score - away_score
    team_scores[home_team] += away_score - home_score
    spreads[away_team] += season.get_games_for_team_and_week(away_team, week).get_spread(away_team)
    spreads[home_team] += season.get_games_for_team_and_week(home_team, week).get_spread(home_team)
  end
  
  teams.values.each {|t| puts"#{t} - spread to actual #{spreads[t]/5} | #{team_scores[t]/5}... #{get_modifier(spreads[t]/5, team_scores[t]/5)}"}
  week_count = 5
  teams.values.each {|t| team_modifiers[t] = get_modifier(spreads[t]/week_count, team_scores[t]/week_count)}
  team_modifiers
end

def get_modifier(spread, score)
  mod = score - spread
  is_neg = mod < 0
  mod = Math.sqrt(mod.abs)
  mod *= -1 if is_neg
  mod.round(1)
end

def load_teams(file_path)
  teams = Hash.new
  CSV.foreach(file_path) do |row|
    teams[row[0].strip] = row[1].strip
  end
  teams
end


teams = load_teams(teams_file)
modifiers = get_team_modifiers(season, teams, scores_file)

season.games.each do |game|
  game.spread += modifiers[game.home_team] - modifiers[game.away_team]
end

previous_picks = CSV.readlines(previous_picks_file).flatten
picks = get_picks_for_season(season, previous_picks, current_week, end_week)

print_picks(picks, previous_picks, current_week, season)
