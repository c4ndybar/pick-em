class Game
  attr_accessor :week, :away_team, :home_team, :spread, :point_differential

  def initialize(csv_row)
    @week = csv_row[0].strip.to_i
    @away_team = csv_row[1].strip
    @home_team = csv_row[2].strip
    @spread = csv_row[3].strip.to_f
  end

  def point_differential
    @spread.abs
  end

  def get_margin_of_victory(team)
    if team == @home_team
      return @spread * -1
    else
      return @spread
    end
  end

  def get_spread(team)
    get_margin_of_victory(team) * -1
  end

  def favored_team
    if @spread.zero?
      return nil
    elsif spread < 0
      return @home_team
    else
      return @away_team
    end
  end

  def has_team(team)
    @home_team == team || @away_team == team
  end

  def to_s
    "#{@week} - #{@away_team}@#{home_team} - #{favored_team} by #{point_differential.round(2)}"
  end
end
