include getbw_HawksMiller.praat

form log name
  sentence log log file name
endform

# test one above 500Hz and one below
@getbw_HawksMiller: 120, 2230
above_500_result = getbw_HawksMiller.result
@getbw_HawksMiller: 210, 400
below_500_result = getbw_HawksMiller.result
appendFileLine: log$, above_500_result, " ", below_500_result

delta = 1e-14
assert abs(71.86461637179505 - above_500_result) < delta
assert abs(48.36033265309102 - below_500_result) < delta
