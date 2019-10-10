form log name
  sentence log log file name
endform

; form Parameters for spectral tilt measure following Iseli et al.
;  comment TextGrid interval to measure.  If numeric, check the box.
;  natural tier 1
;  integer interval_number 0
;  text interval_label v
;  comment Window parameters
;  real windowPosition 0.5
;  positive windowLength 0.025
;  comment Output
;  boolean saveAsEPS 0
;  boolean useBandwidthFormula 1
;  sentence inputdir /home/username/data/
;  comment Manually check token?
;  boolean manualCheck 1
;  comment Analysis parameters
;  positive maxDisplayHz 4000
;  positive measure 2
;  positive timepoints 3
;  positive timestep 1
;  positive f0min 40
;  positive f0max 500
; endform

tier = 1
interval = 0
ilabel$ = "v"
windowPosition = 0.5
windowLength = 0.025
saveAsEPS$ = "no"
useBandwidthFormula$ = "no"
inputdir$ = "."
manualCheck$ = "no"
maxDisplayHz = 4000
measure = 2
timepoints = 3
timestep = 1
f0min = 40
f0max = 500

maxNumFormants = 5
maxFormantHz = 5500
preEmphFrom = 50

# Load and select TextGrid, Sound, Formant
Read from file: "../comp/madurese/baca-read.TextGrid"
Read from file: "../comp/madurese/baca-read.wav"
selectObject: "Sound baca-read"
To Formant (burg): timestep, maxNumFormants, maxFormantHz, windowLength, preEmphFrom
selectObject: "Sound baca-read"
To Pitch: 0, 75, 600

selectObject: "Sound baca-read"
plusObject: "TextGrid baca-read"
plusObject: "Pitch baca-read"
plusObject: "Formant baca-read"

runScript: "spectralMeasures.praat", tier, interval, ilabel$,
... windowPosition, windowLength, saveAsEPS$, useBandwidthFormula$,
... inputdir$, manualCheck$, maxDisplayHz, measure, timepoints,
... timestep, f0min, f0max

selectObject: "Matrix IseliMeasures"
Save as matrix text file: "../test/obtained/IseliMeasures.mat"
