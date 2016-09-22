require 'CSV'
require_relative 'game'
require_relative 'helper'

class FootballSeason
  attr :games, :teams, :weeks

  def initialize()
    @games = []

    loadGames()
    @teams = @games.map {|g| g.homeTeam}.uniq.sort
    @weeks = (1..16).to_a
  end



  def getGamesForWeek(week)
    return @games.select {|g| g.week == week}
  end

  def getGamesForTeam(team)
    return @games.select {|g| g.awayTeam == team || g.homeTeam == team }
  end

  def getMedianMarginOfVictoryForTeam(team)
    pointDifferentials = getGamesForTeam(team).map {|g| g.getMarginOfVictory(team)}

    return median(pointDifferentials)
  end

  def getMarginOfVictoryForTeamAndWeek(team, week)
    game = getGameForTeamAndWeek(team, week)
    if game == nil
      return -100 #bye week
    else
      return game.getMarginOfVictory(team)
    end
  end

  def getGameForTeamAndWeek(team, week)
    return @games.select {|g| g.week == week && g.hasTeam(team)}.first
  end

  def isByeWeek(team, week)
    return getGameForTeamAndWeek(team, week) == nil
  end

  private

  def loadGames()
    CSV.foreach("spreads.csv") do |row|
      game = Game.new(row)
      @games.push(game)
    end
  end
end