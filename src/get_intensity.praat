### Get intensity (root-mean-squared amplitude) values

include extract_snippet.praat
include restrictInterval.praat

procedure rms: .timeStep, .f0min, .start, .end

## extract padded snippet.
## one analysis window corresponds ROUGHLY to 6.4 pitch cycles (i.e.
## 6.4 * pitch floor), because for some reason this number is rounded in some
## arcane fashion.

soundID = selected("Sound")

@snippet: .start, .end, ((6.4 * (1 / .f0min)) / 2) + (.timeStep / 2)
snippetID = selected("Sound")

## get intensity
## the final argument is whether to "subtract mean" (default yes)

To Intensity: .f0min, .timeStep, 1
rmsID = selected("Intensity")

## get frame times and number of frames

.times# = List all frame times
.numFrames = Get number of frames

## some data structure tomfoolery to extract all values in one fell swoop

Down to Matrix
matrixID = selected("Matrix")
.res# = Get all values in row: 1

if .start > 0 | .end < dur

  @restrictInterval: .times#, .res#, .start, .end

  .times# = restrictInterval.newTimes#
  .res# = restrictInterval.newVals#
  .numFrames = size(restrictInterval.newTimes#)

endif

## clean up

select rmsID
plus matrixID
plus snippetID
Remove

select soundID

endproc
