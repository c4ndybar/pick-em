class PickAnalyzer
  def initialize(season)
    @season = season
    @margins = {}
  end

  def print_weekly_favorites
    @season.weeks.each do |week|
      week_pick = @season.get_games_for_week(week).sort_by(&:point_differential).last

      puts week_pick
    end
  end

  def print_best_week_for_teams
    @season.teams.each do |team|
      best_game = @season.get_games_for_team(team).sort { |g1, g2| g1.get_margin_of_victory(team) <=> g2.get_margin_of_victory(team) }.last

      puts "Best game for #{team}: #{best_game}"
    end
  end

  def print_debug_info
    @season.games.each { |g| p g }
    puts 'game count is ' + @season.games.length.to_s
    @season.teams.each { |t| puts t }
    puts 'team count is ' + @season.teams.length.to_s
    @season.weeks.each { |w| puts w }
    puts 'week count is ' + @season.weeks.length.to_s
  end

  def get_margin_for_team_and_week(team, week)
    @margins[team] = {} if @margins[team].nil?

    if @margins[team][week].nil?
      @margins[team][week] = @season.get_margin_of_victory_for_team_and_week(team, week)
    end

    @margins[team][week]
  end

  def pick_optimal_teams_for_weeks(week, last_week, teams)
    best_team = nil
    best_margin = nil
    best_picks = []
    team_margin = 0

    best_teams = teams.select { |team| get_margin_for_team_and_week(team, week) >= 5 }
    best_teams.each do |team|
      if week < last_week
        teams.delete(team)
        picks = pick_optimal_teams_for_weeks(week + 1, last_week, teams)
        teams.push(team)
        next if picks.nil?
      else
        picks = []
      end

      win_margin = get_margin_for_team_and_week(team, week)
      total_win_margin = calculate_win_margin_sum(picks) + win_margin
      next unless best_margin.nil? || total_win_margin > best_margin
      best_team = team
      best_margin = total_win_margin
      best_picks = picks
      team_margin = win_margin
    end

    return nil if best_team.nil?

    best_pick = [week, best_team, team_margin]
    best_picks.push(best_pick)

    best_picks
  end

  def calculate_win_margin_sum(picks)
    sum = 0
    picks.each do |pick|
      sum += pick[2]
    end

    sum
  end

  def simple_picker
    weekly_picks = {}

    @season.weeks.each do |week|
      pick = @season.get_games_for_week(week).sort_by(&:point_differential).select { |g| !(weekly_picks.value? g.favored_team) }.last
      weekly_picks[week] = pick.favored_team
    end

    weekly_picks
  end
end
