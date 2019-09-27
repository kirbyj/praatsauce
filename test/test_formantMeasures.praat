#include formantMeasures.praat
# call via runScript rather than include ....

form log name
  sentence log log file name
endform

# form Parameters for formant measurement
#     comment TextGrid interval
#     natural tier 1
#     integer interval_number 2
#     sentence interval_label v
#     comment Window parameters
#     positive windowPosition 0.5
#     positive windowLength 0.025
#     boolean manualCheck 0
#     boolean saveAsEPS 0
#     boolean useBandwidthFormula 1
#     boolean useExistingFormants 0
#     text inputdir /home/username/data/
#     text basename myFile
#     boolean listenToSound 1
#     comment Leave timeStep at 0 for auto.
#     real timeStep 0
#     integer maxNumFormants 5
#     positive maxFormantHz 5500
#     positive preEmphFrom 50
#     positive f1ref 500
#     positive f2ref 1500
#     positive f3ref 2500
#     positive spectrogramWindow 0.005
#     positive measure 2
#     positive timepoints 3
#     positive timestep 1
#     boolean formantTracking 1
#     positive smoothWindowSize 20
#     positive smoother 1
# endform

tier = 1
interval = 2
ilabel$ = "v"
windowPosition = 0.5
windowLength = 0.025
manualCheck$ = "no"
saveAsEPS$ = "no"
useBandwidthFormula$ = "no"
useExistingFormants$ = "no"
inputdir$ = "."
basename$ = "myFile"
listenToSound$ = "yes"
spectrogramWindow = 0.005

f1ref = 500
f2ref = 1500
f3ref = 2500

measure = 2
timepoints = 3
timestep = 1
formantTracking$ = "yes"

timeStep = 0
maxNumFormants = 5
maxFormantHz = 5500
preEmphFrom = 50

smoothWindowSize = 20
smoother$ = "no"

# Load and select TextGrid, Sound, Formant
Read from file: "../comp/madurese/baca-read.TextGrid"
Read from file: "../comp/madurese/baca-read.wav"
selectObject: "Sound baca-read"
To Formant (burg): timeStep, maxNumFormants, maxFormantHz, windowLength, preEmphFrom

selectObject: "Sound baca-read"
plusObject: "TextGrid baca-read"
plusObject: "Formant baca-read"

runScript: "formantMeasures.praat", tier, interval, ilabel$, windowPosition,
... windowLength, manualCheck$, saveAsEPS$, useBandwidthFormula$,
... useExistingFormants$, inputdir$, basename$, listenToSound$, timeStep,
... maxNumFormants, maxFormantHz, preEmphFrom, f1ref, f2ref, f3ref,
... spectrogramWindow, measure, timepoints, timestep, formantTracking$,
... smoothWindowSize, smoother$
; runScript: "formantMeasures.praat", 1, 2, "v", 0.5,
; ... 0.025, "no", "no", "no",
; ... "no", ".", "myFile", "yes", 0.005,
; ... 5, 5500, 50, 500, 1500, 2500,
; ... 0.005, 2, 3, 1, "yes"

# save matrix
selectObject: "Matrix FormantAverages"
Save as matrix text file: "../test/obtained/FormantAverages.mat"
