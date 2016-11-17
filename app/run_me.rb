require_relative 'football_season'
require_relative 'pick_analyzer'
require_relative 'spread_modifier'
require_relative 'helper'

CURRENT_WEEK = 11
END_WEEK = 14
MINIMUM_POINT_THRESHOLD = 6

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
  picks.each do |week, team|
    puts "week #{week}"
    optimal_pick = season.get_games_for_team_and_week(team, week)
    games = season.get_games_for_week(week)
    pick_found = false
    games.sort_by(&:point_differential).reverse.each_with_index do |game, index|
      best_pick = game == optimal_pick
      puts "#{game} #{best_pick ? '<--- optimal pick' : '' }"
      pick_found ||= best_pick
      break if (pick_found && index >= 2) && week != CURRENT_WEEK
    end
  end
end

def get_picks_for_season(season, previous_picks)
  pick_analyzer = PickAnalyzer.new(season)
  teams = season.teams - previous_picks

  pick_analyzer.pick_optimal_teams_for_weeks(CURRENT_WEEK,
                                             END_WEEK,
                                             MINIMUM_POINT_THRESHOLD,
                                             teams)
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
