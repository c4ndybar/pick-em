require_relative 'football_season'
require_relative 'pick_analyzer'
require_relative 'helper'

season = FootballSeason.new
current_week = 3
end_week = 14

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

previous_picks = get_previous_picks
picks = get_picks_for_season(season, previous_picks, current_week, end_week)

print_picks(picks, previous_picks, current_week, season)
