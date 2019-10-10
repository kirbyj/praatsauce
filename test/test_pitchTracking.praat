
form log name
  sentence log log file name
endform

; form Parameters for f0 measurement
;  comment TextGrid interval
;  natural tier 4
;  natural interval_number 0
;  text interval_label v
;  real windowPosition
;  positive windowLength
;  boolean manualCheck 1
;  boolean outputToMatrix 1
;  positive measure 2
;  positive timepoints 10
;  positive timestep 1
; endform

tier = 1
interval_number = 0
interval_label$ = "v"
windowPosition = 0.5
windowLength = 0.0025
manualcheck$ = "no"
outputToMatrix$ = "yes"
measure = 2
timepoints = 10
timestep = 1

# Load and select TextGrid, Sound, Pitch
Read from file: "../comp/madurese/baca-read.TextGrid"
Read from file: "../comp/madurese/baca-read.wav"
selectObject: "Sound baca-read"
To Pitch: 0, 75, 600

selectObject: "Sound baca-read"
plusObject: "TextGrid baca-read"
plusObject: "Pitch baca-read"

runScript: "pitchTracking.praat", tier, interval_number, interval_label$,
... windowPosition, windowLength, manualcheck$, outputToMatrix$, measure,
... timepoints, timestep

selectObject: "Matrix PitchAverages"
Save as matrix text file: "../test/obtained/PitchAverages.mat"
