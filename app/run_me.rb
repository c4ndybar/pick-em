require_relative 'football_season'
require_relative 'pick_analyzer'
require_relative 'helper'

current_week = 6
end_week = 14
spread_file = '../spreads.csv'
previous_picks_file = '../previous_picks.csv'

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

previous_picks = CSV.readlines(previous_picks_file).flatten
picks = get_picks_for_season(season, previous_picks, current_week, end_week)

print_picks(picks, previous_picks, current_week, season)
