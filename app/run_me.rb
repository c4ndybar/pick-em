require_relative 'football_season'
require_relative 'pick_analyzer'
require_relative 'spread_modifier'
require_relative 'helper'

CURRENT_WEEK = 10
END_WEEK = 14
spread_file = '../spreads.csv'
previous_picks_file = '../previous_picks.csv'
scores_file = '../actual_scores.csv'
teams_file = '../teams.csv'

season = FootballSeason.new(spread_file)
spread_modifier = SpreadModifier.new

def print_picks(picks, previous_picks, season)
  puts "Previous picks are: #{previous_picks}"
  puts ''
  picks.each { |week, team| puts "week #{week} - #{team} - #{season.get_games_for_team_and_week(team, week)}" }
  puts ''
  season.get_games_for_week(CURRENT_WEEK).each { |game| puts game }
end

def get_picks_for_season(season, previous_picks)
  pick_analyzer = PickAnalyzer.new(season)
  teams = season.teams - previous_picks

  pick_analyzer.pick_optimal_teams_for_weeks(CURRENT_WEEK, END_WEEK, teams)
end

def load_teams(file_path)
  teams = Hash.new
  CSV.foreach(file_path) do |row|
    teams[row[0].strip] = row[1].strip
  end
  teams
end

teams = load_teams(teams_file) #.sort_by { |t,name| t}
previous_picks = CSV.readlines(previous_picks_file).flatten

spread_modifier.modify_spreads(season, teams, scores_file)
picks = get_picks_for_season(season, previous_picks)

print_picks(picks, previous_picks, season)
