# Pick'em

NFL Pick'em application to pick optimal picks for the season.  Adjusts the picks with updated scores each week.

### To get picks
- Update `spreads.csv` with spreads for entire season.  CG Technology usually puts out spread predictions for the season.
- Update `teams` with correct team data matching the data in `spreads.csv`
- If the season has started, update `actual_scores.csv` with score data.  A good source for score data is [pro-football-reference](https://www.pro-football-reference.com/years/2018/games.htm).  Also, update `previous_picks.csv` with your picks for previous weeks.
- Run the app to get the picks
```bash
cd app
ruby pick_em.rb
```
