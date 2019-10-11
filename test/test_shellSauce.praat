; form Directory and measures
;     sentence inputdir /Users/jkirby/Projects/praatsauce/comp/madurese/
;     sentence textgriddir /Users/jkirby/Projects/praatsauce/comp/madurese/
;     sentence outputdir /Users/jkirby/Projects/praatsauce/comp/
;     sentence outputfile spectral_measures.txt
;     natural startToken 1
;     natural interval_tier 1
;     sentence skip_these_labels ^$|^\s+$|r
;     integer point_tier 0
;     sentence point_tier_labels ov cv rv
;     sentence separator _
;     real manualCheckFrequency 0
;     optionmenu Measure: 2
;        option n equidistant points
;        option every n milliseconds
; 	natural Points 5
;     boolean resample_to_16k 1
;     boolean pitchTracking 1
;     boolean formantMeasures 1
;     boolean spectralMeasures 1
;     positive windowLength 0.025
;     positive windowPosition 0.5
;     positive maxFormantHz 5000
;     positive spectrogramWindow 0.005
;     boolean listenToSound 0
;     real timeStep 0
;     integer maxNumFormants 5
;     positive preEmphFrom 50
;     boolean formantTracking 1
;     positive F1ref 500
;     positive F2ref 1500
;     positive F3ref 2500
;     boolean saveAsEPS 0
;     boolean useExistingFormants 0
;     boolean useBandwidthFormula 0
;     boolean useExistingPitch 0
;     positive f0min 50
;     positive f0max 300
; endform

form log name
  sentence log log file name
endform

inputdir$ = "../comp/madurese"
textgriddir$ = "../comp/madurese"
outputdir$ = "../test/obtained"
outputfile$ = "spectral_measures.txt"
startToken = 1
interval_tier = 1
skip_these_labels$ = "^$|^\s+$|r"
point_tier = 0
point_tier_labels$ = "ov cv rv"
separator$ = "_"
manualCheckFrequency$ = "no"
measure$ = "n equidistant points"
points = 5
resample_to_16k$ = "yes"
pitchTracking$ = "yes"
formantMeasures$ = "yes"
spectralMeasures$ = "yes"
windowLength = 0.025
windowPosition = 0.5
maxFormantHz = 5000
spectrogramWindow = 5000
listenToSound$ = "no"
timeStep = 0
maxNumFormants = 5
preEmphFrom = 50
formantTracking$ = "no"
f1ref = 500
f2ref = 1500
f3ref = 2500
saveAsEPS$ = "no"
useExistingFormants$ = "no"
useBandwidthFormula$ = "no"
useExistingPitch$ = "no"
f0min = 50
f0max = 300

runScript: "shellSauce.praat", inputdir$, textgriddir$, outputdir$, outputfile$,
... startToken, interval_tier, skip_these_labels$, point_tier,
... point_tier_labels$, separator$, manualCheckFrequency$, measure$,
... points, resample_to_16k$, pitchTracking$, formantMeasures$,
... spectralMeasures$, windowLength, windowPosition, maxFormantHz,
... spectrogramWindow, listenToSound$, timeStep, maxNumFormants, preEmphFrom,
... formantTracking$, f1ref, f2ref, f3ref, saveAsEPS$, useExistingFormants$,
... useBandwidthFormula$, useExistingPitch$, f0min, f0max
