
def median(array)
  sorted = array.sort
  len = sorted.length
  (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
end

def get_previous_picks
  CSV.readlines('previous_picks.csv').flatten
end
