require_relative 'football_season'
require_relative 'pick_analyzer'
require_relative 'helper'

season = FootballSeason.new


def printPicks(picks, season)
  picks.each {|week, team| puts "week #{week} - #{team} - #{season.getGameForTeamAndWeek(team, week)}"}
end

def getPicks(season)
  pickAnalyzer = PickAnalyzer.new(season)
  previousPicks = getPreviousPicks()
  teams = season.teams - previousPicks

  return pickAnalyzer.pickOptimalTeamsForWeeks(previousPicks.length + 1, 14, teams)
end

picks = getPicks(season)

puts "Previous picks are: #{getPreviousPicks()}"
puts ""
printPicks(picks, season)
puts ""
season.getGamesForWeek(3).each {|game| puts game}