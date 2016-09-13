class Game
  attr_accessor :week, :date, :awayTeam, :homeTeam, :spread, :point_differential

  def initialize(csv_row)
    @week = csv_row[0].strip.to_i
    @date = csv_row[1].strip
    @awayTeam = csv_row[2].strip
    @homeTeam = csv_row[3].strip
    @spread = csv_row[4].strip.to_f

    @point_differential = @spread.abs
  end

  def getMarginOfVictory(team)
    if team == @homeTeam
      return @spread * -1
    else
      return @spread
    end
  end

  def favoredTeam()
    if @spread == 0
      return nil
    elsif spread < 0
      return @homeTeam
    else
      return @awayTeam
    end
  end

  def to_s
    return "#{@week} - #{@awayTeam}@#{homeTeam} - #{favoredTeam} by #{point_differential}"
  end
end