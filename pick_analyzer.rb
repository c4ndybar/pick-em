class PickAnalyzer
  def initialize(season)
    @season = season
    @margins = Hash.new
  end

  def printWeeklyFavorites()
    @season.weeks.each do |week|
      weekPick = @season.getGamesForWeek(week).sort {|g1, g2| g1.point_differential <=> g2.point_differential}.last

      puts weekPick
    end
  end

  def printBestWeekForTeams()
    @season.teams.each do |team|
      teamBest = @season.getGamesForTeam(team).sort {|g1, g2| g1.getMarginOfVictory(team) <=> g2.getMarginOfVictory(team)}.last

      puts "Best game for #{team}: #{teamBest}"
    end
  end

  def printDebugInfo()
    @season.games.each {|g| p g}
    puts 'game count is ' + @season.games.length.to_s
    @season.teams.each {|t| puts t}
    puts 'team count is ' + @season.teams.length.to_s
    @season.weeks.each {|w| puts w}
    puts 'week count is ' + @season.weeks.length.to_s
  end

  def getMarginForTeamAndWeek(team, week)
    if @margins[team] == nil
      @margins[team] = Hash.new
    end

    if @margins[team][week] == nil
      @margins[team][week] = @season.getMarginOfVictoryForTeamAndWeek(team, week)
    end

    return @margins[team][week]
  end

  def pickOptimalTeamsForWeeks(week, lastWeek, teams)
    bestteam = nil
    bestMargin = nil
    bestPicks = []
    teamMargin = 0

    bestTeams = teams.select {|team| getMarginForTeamAndWeek(team, week) >= 5}
    bestTeams.each do |team|

      if week < lastWeek
        teams.delete(team)
        picks = pickOptimalTeamsForWeeks(week + 1, lastWeek, teams)
        teams.push(team)
        if picks == nil
          next
        end
      else
        picks = []
      end

      winMargin = getMarginForTeamAndWeek(team, week)
      totalWinMargin = calculateWinMarginSum(picks) + winMargin
      if bestMargin == nil || totalWinMargin > bestMargin
        bestteam = team
        bestMargin = totalWinMargin
        bestPicks = picks
        teamMargin = winMargin
      end

    end

    if bestteam == nil
      return nil
    end

    bestPick = [week, bestteam, teamMargin]
    bestPicks.push(bestPick)

    return bestPicks
  end

  def calculateWinMarginSum(picks)
    sum = 0
    picks.each do |pick|
      sum += pick[2]
    end

    return sum
  end

  def simplePicker()
    weeklyPicks = Hash.new

    @season.weeks.each do |week|
      pick = @season.getGamesForWeek(week).sort {|g1, g2| g1.point_differential <=> g2.point_differential}.select {|g| !(weeklyPicks.has_value? g.favoredTeam)}.last
      weeklyPicks[week] = pick.favoredTeam
    end

    return weeklyPicks
  end

end