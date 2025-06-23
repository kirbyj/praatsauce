### Get ceptral peak prominences

include extract_snippet.praat
include restrictInterval.praat

procedure cpp: .timeStep, .f0min, .f0max, .start, .end, .trendType, .fast

## Get string values for trend type and fit method

if .trendType <> 0
  trend$ = "Straight"
else
  trend$ = "Exponential decay"
endif

if .fast <> 0
  fitMethod$ = "Robust"
else
  fitMethod$ = "Robust slow"
endif

## extract padded snippet.
## one analysis window corresponds ROUGHLY to six pitch cycles (i.e.
## 6 * pitch floor), because for some reason this number is rounded in some
## arcane fashion.

snd = selected("Sound")

@snippet: .start, .end, ((6 * (1 / .f0min)) / 2) + (.timeStep / 2)
snippet = selected("Sound")

snippetDur = Get total duration
if snippetDur < (1 / .f0min) * 6
  .f0min = ((1 / snippetDur) * 6) + 1
endif


## create cepstrogram, grab frame times

cep = To PowerCepstrogram: .f0min, .timeStep, 5000, 50
.times# = List all frame times

## tabulate cpp values based on the cepstrogram
## arguments are: should frame numbers and times be included in the table
## (no, we already grabbed them), should peak quefrencies be included (no,
## don't need them, afaik that's just inferior pitch tracking), how many decimals
## to include, "tolerance" (?? documentation is silent on this matter, it's set
## to 0.05 following defaults), interpolation (default parabolic), quefrency
## range (entire cepstrum), trend type (default exponential decay),
## fit method (robust -- default "robust slow" is truly slow)

table = To Table (cepstral peak prominences): 0, 0, 6, 3, 0, 3, .f0min, .f0max,
  ... 0.05, "parabolic", 0.001, 0, trend$, fitMethod$
.res# = Get all numbers in column: "CPP(dB)"

## grab number of rows

.numFrames = Get number of rows

if .start > 0 | .end < dur

  @restrictInterval: .times#, .res#, .start, .end

  .times# = restrictInterval.newTimes#
  .res# = restrictInterval.newVals#
  .numFrames = size(restrictInterval.newTimes#)

endif

## clean up

removeObject: cep, table, snippet
selectObject: snd

endproc
