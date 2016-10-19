require 'CSV'
require_relative 'game'
require_relative 'helper'

class FootballSeason
  attr_reader :games, :teams, :weeks

  def initialize(file_path)
    @games = []

    load_games(file_path)
    @teams = @games.map(&:home_team).uniq.sort
    @weeks = (1..16).to_a
  end

  def get_games_for_week(week)
    @games.select { |g| g.week == week }
  end

  def get_games_for_team_and_weekam(team)
    @games.select { |g| g.away_team == team || g.home_team == team }
  end

  def get_median_margin_of_victory_for_team(team)
    point_differentials = get_games_for_team(team).map { |g| g.get_margin_of_victory(team) }

    median(point_differentials)
  end

  def get_margin_of_victory_for_team_and_week(team, week)
    game = get_games_for_team_and_week(team, week)
    if game.nil?
      return -100 # bye week
    else
      return game.get_margin_of_victory(team)
    end
  end

  def get_games_for_team_and_week(team, week)
    @games.select { |g| g.week == week && g.has_team(team) }.first
  end

  def is_bye_week(team, week)
    get_games_for_team_and_week(team, week).nil?
  end

  private

  def load_games(file_path)
    CSV.foreach(file_path) do |row|
      game = Game.new(row)
      @games.push(game)
    end
  end
end
