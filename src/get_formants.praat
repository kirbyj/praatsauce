### Get formant values

include extract_snippet.praat
include restrictInterval.praat

procedure fmt: .measureBandwidths, .timeStep, .maxN, .maxHz,
	... .windowLength, .preEmphFrom, .start, .end, .f1ref, .f2ref, .f3ref,
	... .save, .saveDir$, .read, .readDir$, .basefn$

## extract padded snippet.
## analysis windows are rounded in some arcane fashion, which is ignored here.

soundID = selected("Sound")

@snippet: .start, .end, .windowLength + (.timeStep / 2)
snippetID = selected("Sound")

if .read = 0

  ## all formant calculation arguments are user-controlled

  To Formant (burg): .timeStep, .maxN, .maxHz, .windowLength, .preEmphFrom
  orgFormantID = selected("Formant")

  ## convert to formantGrid and back to remove undefineds

  #### Removed this for now because it messes up the time domain.
  #### Will add formant duplicates to any part of the sound file that isn't
  #### tracked because of the windowing

  #### This could be a more serious problem, because the tracking algo below
  #### will shoot an error if there --undefined--s in F3

  #Down to FormantGrid
  #formantGridID = selected("FormantGrid")
  #To Formant: .timeStep, 0.1
  #fullFormantID = selected("Formant")

  ##

  ## use tracking algo to clean these up a bit.
  ## arguments are: how many formants to track, what are their references
  ## (F1-F5 have to be specified, but untracked formants are ignored),
  ## frequency cost, bandwidth cost, transition cost (the last three are all
  ## just defaults)

  Track: 3, .f1ref, .f2ref, .f3ref, 3500, 4500, 1, 1, 1
  trackedFormantID = selected("Formant")

  if .save <> 0

    Save as text file: .saveDir$ + .basefn$ + ".Formant"

  endif

else

  Read from file: .readDir$ + .basefn$ + ".Formant"
  orgFormantID = selected("Formant")
  trackedFormantID = selected("Formant")

endif

## grab frame times and number of frames

.times# = List all frame times
.numFrames = Get number of frames

## tabulate formants.
## these arguments concern whether frame number or times should be included
## (no, we already have them), whether intensity should be included (no, we
## calculate intensity separately because otherwise we don't get dB but some
## other unit), how many decimals to use, and whether to include bandwidths
## (depends if the user wants empirical bandwidths or wants to estimate them
## using the Hawks-Miller formula)

Down to Table: 0, 0, 3, 0, 3, 0, 3, .measureBandwidths
tableID = selected("Table")

## grab formant values

.f1# = Get all numbers in column: "F1(Hz)"
.f2# = Get all numbers in column: "F2(Hz)"
.f3# = Get all numbers in column: "F3(Hz)"

## grab bandwidths if user wants empirical bandwidths

if .measureBandwidths <> 0
	.b1# = Get all numbers in column: "B1(Hz)"
	.b2# = Get all numbers in column: "B2(Hz)"
	.b3# = Get all numbers in column: "B3(Hz)"
endif

if .start > 0 | .end < dur

  @restrictInterval: .times#, .f1#, .start, .end
  .f1# = restrictInterval.newVals#
  @restrictInterval: .times#, .f2#, .start, .end
  .f2# = restrictInterval.newVals#
  @restrictInterval: .times#, .f3#, .start, .end
  .f3# = restrictInterval.newVals#
  .times# = restrictInterval.newTimes#

  if .measureBandwidths <> 0
    @restrictInterval: .times#, .b1#, .start, .end
    .b1# = restrictInterval.newVals#
    @restrictInterval: .times#, .b2#, .start, .end
    .b2# = restrictInterval.newVals#
    @restrictInterval: .times#, .b3#, .start, .end
    .b3# = restrictInterval.newVals#
  endif

  .numFrames = size(restrictInterval.newTimes#)

endif

## clean up

select orgFormantID
plus trackedFormantID
plus tableID
plus snippetID
Remove

select soundID

endproc
