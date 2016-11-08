class SpreadModifier

  def modify_spreads(season, teams, scores_file)
    modifiers = team_modifiers(season, teams, scores_file)

    season.games.each do |game|
      game.spread += modifiers[game.home_team] - modifiers[game.away_team]
    end
  end

  private
  
  def team_modifiers(season, teams, scores_file)
    team_scores = Hash.new([])
    team_modifiers = Hash.new
    spreads = Hash.new([])
    CSV.foreach(scores_file) do |row|
      week = row[0].to_i
      away_team = teams[row[1]]
      home_team = teams[row[2]]
      away_score = row[3].strip.to_i
      home_score = row[4].strip.to_i
      team_scores[away_team] += [home_score - away_score]
      team_scores[home_team] += [away_score - home_score]
      spreads[away_team] += [season.get_games_for_team_and_week(away_team, week).get_spread(away_team)]
      spreads[home_team] += [season.get_games_for_team_and_week(home_team, week).get_spread(home_team)]
    end
    teams.values.each do |t|
      actual_average = average(team_scores[t]).round(1)
      spread_average = average(spreads[t]).round(1)
      team_modifiers[t] = get_modifier(spread_average, actual_average)
      puts"#{t} - spread to actual #{spread_average} | #{actual_average}... #{team_modifiers[t]}"
    end
    team_modifiers
  end

  def average(arr)
    arr.reduce(0) {|f,s| f + s}.to_f / arr.length.to_f
  end

  def get_modifier(spread, score)
    mod = score - spread
    is_neg = mod < 0
    mod = mod.abs.to_f / 2*((CURRENT_WEEK - 1).to_f / END_WEEK.to_f)
    mod *= -1 if is_neg
    mod.round(1)
  end
end
