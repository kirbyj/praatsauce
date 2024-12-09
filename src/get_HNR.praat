### Calculate harmonics-to-noise ratio

include extract_snippet.praat
include restrictInterval.praat

procedure hnr: .maxFreq, .timeStep, .f0min, .start, .end

## extract padded snippet.
## one analysis window corresponds ROUGHLY to two pitch cycles (i.e.
## 2 * pitch floor), because for some reason this number is rounded in some
## arcane fashion.

snd = selected("Sound")

@snippet: .start, .end, ((2 * (1 / .f0min)) / 2) + (.timeStep / 2)
snippet = selected("Sound")

## bandpass filter with 100 Hz smoothing (default)
  ## is 100 Hz smoothing perhaps a bit much when grabbing just e.g 0-500 Hz?

filter = Filter (pass Hann band): 0, .maxFreq, 100

## the harmonicity arguments that aren't user controlled are the silence
## threshold (which is set very low here), and cycles per window.
## (this probably allows users to control the window size)

hnr = To Harmonicity (cc): .timeStep, .f0min, 0.00001, 1

## some data structure tomfoolery that allows us to grab all values in one
## fell swoop. also grab frames times and number of frames

.times# = List all frame times
matrix = To Matrix
.res# = Get all values in row: 1
.numFrames = Get number of columns

if .start > 0 | .end < dur

  @restrictInterval: .times#, .res#, .start, .end

  .times# = restrictInterval.newTimes#
  .res# = restrictInterval.newVals#
  .numFrames = size(restrictInterval.newTimes#)

endif

## clean up

removeObject: filter, hnr, matrix, snippet
selectObject: snd

endproc
