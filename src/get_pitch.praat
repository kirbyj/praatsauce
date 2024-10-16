### Get pitch values

include extract_snippet.praat

procedure pitch: .timeStep, .f0min, .f0max, .start, .end

## extract padded snippet
## one analysis window corresponds ROUGHLY to three pitch cycles (i.e.
## 3 * pitch floor), because for some reason this number is rounded in some
## arcane fashion.

soundID = selected("Sound")

@snippet: .start, .end, ((3 * (1 / .f0min)) / 2) + (.timeStep / 2)
snippetID = selected("Sound")

## filtered ac is now the recommended method for calculating pitch. I haven't
## really touched any of the defaults.
## untouched arguments: max number of candidates, "very accurate" (no),
## attenuation at ceiling, silence threshold, voicing threshold, octave cost,
## octave-jump cost, voiced/unvoiced cost

To Pitch (filtered ac): .timeStep, .f0min, .f0max, 15, 0, 0.03, 0.09, 0.5,
  ... 0.005, 0.35, 0.14
pitchOrgID = selected("Pitch")

## I run the Kill octave jumps function (although not sure that it's really
## necessary when using filtered ac?)

Kill octave jumps
pitchFiltID = selected("Pitch")

## grab all values as a vector

.f0# = List values in all frames: "Hertz"

## grab frame times and number of frames

.times# = List all frame times
.numFrames = Get number of frames

## clean up

select pitchOrgID
plus pitchFiltID
plus snippetID
Remove

select soundID

endproc
