require_relative 'football_season'
require_relative 'pick_analyzer'

season = FootballSeason.new
season.loadGames()

pickAnalyzer = PickAnalyzer.new(season)

def printPicks(picks, season)
  picks.each {|week, team| puts "week #{week} - #{team} - #{season.getGameForTeamAndWeek(team, week)}"}
end

previousPicks = ["SEA"]
teams = pickAnalyzer.sortTeamsByWinMargin(season.teams).reverse.take(32) - previousPicks

picks = pickAnalyzer.pickOptimalTeamsForWeeks(previousPicks.length + 1, 14, teams)

#picks = pickAnalyzer.pickWorstTeamFirst()
printPicks(picks, season)
