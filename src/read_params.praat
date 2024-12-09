### Process parameters file, output necessary variables

procedure params: .file$

## find each of the core parameters in the params.csv file and store them as
## variables

Read Table from comma-separated file: .file$
inputDirID = Search column: "variable", "inputDir"
.inputDir$ = Get value: inputDirID, "input"
outputDirID = Search column: "variable", "outputDir"
.outputDir$ = Get value: outputDirID, "input"
outputFileID = Search column: "variable", "outputFile"
.outputFile$ = Get value: outputFileID, "input"
channelID = Search column: "variable", "channel"
.channel = Get value: channelID, "input"
intervalEquidistantID = Search column: "variable", "intervalEquidistant"
.intervalEquidistant = Get value: intervalEquidistantID, "input"
intervalFixedID = Search column: "variable", "intervalFixed"
.intervalFixed = Get value: intervalFixedID, "input"
pitchID = Search column: "variable", "pitch"
.pitch = Get value: pitchID, "input"
formantID = Search column: "variable", "formant"
.formant = Get value: formantID, "input"
harmonicAmplitudeID = Search column: "variable", "harmonicAmplitude"
.harmonicAmplitude = Get value: harmonicAmplitudeID, "input"
harmonicAmplitudeUncorrectedID = Search column: "variable", "harmonicAmplitudeUncorrected"
.harmonicAmplitudeUncorrected = Get value: harmonicAmplitudeUncorrectedID, "input"
bwID = Search column: "variable", "bw"
.bw = Get value: bwID, "input"
bwHawksMillerID = Search column: "variable", "bwHawksMiller"
.bwHawksMiller = Get value: bwHawksMillerID, "input"
slopeID = Search column: "variable", "slope"
.slope = Get value: slopeID, "input"
slopeUncorrectedID = Search column: "variable", "slopeUncorrected"
.slopeUncorrected = Get value: slopeUncorrectedID, "input"
cppID = Search column: "variable", "cpp"
.cpp = Get value: cppID, "input"
hnrID = Search column: "variable", "hnr"
.hnr = Get value: hnrID, "input"
intensityID = Search column: "variable", "intensity"
.intensity = Get value: intensityID, "input"
soeID = Search column: "variable", "soe"
.soe = Get value: soeID, "input"
resample16kHzID = Search column: "variable", "resample16kHz"
.resample16kHz = Get value: resample16kHzID, "input"
windowLengthID = Search column: "variable", "windowLength"
.windowLength = Get value: windowLengthID, "input"
f0minID = Search column: "variable", "f0min"
.f0min = Get value: f0minID, "input"
f0maxID = Search column: "variable", "f0max"
.f0max = Get value: f0maxID, "input"
pitchMethodID = Search column: "variable", "pitchMethod"
.pitchMethod = Get value: pitchMethodID, "input"
pitchWindowShapeID = Search column: "variable", "pitchWindowShape"
.pitchWindowShape = Get value: pitchWindowShapeID, "input"
pitchMaxNoCandidatesID = Search column: "variable", "pitchMaxNoCandidates"
.pitchMaxNoCandidates = Get value: pitchMaxNoCandidatesID, "input"
silenceThresholdID = Search column: "variable", "silenceThreshold"
.silenceThreshold = Get value: silenceThresholdID, "input"
voicingThresholdID = Search column: "variable", "voicingThreshold"
.voicingThreshold = Get value: voicingThresholdID, "input"
octaveCostID = Search column: "variable", "octaveCost"
.octaveCost = Get value: octaveCostID, "input"
octaveJumpCostID = Search column: "variable", "octaveJumpCost"
.octaveJumpCost = Get value: octaveJumpCostID, "input"
voicedUnvoicedCostID = Search column: "variable", "voicedUnvoicedCost"
.voicedUnvoicedCost = Get value: voicedUnvoicedCostID, "input"
killOctaveJumpsID = Search column: "variable", "killOctaveJumps"
.killOctaveJumps = Get value: killOctaveJumpsID, "input"
maxNumFormantsID = Search column: "variable", "maxNumFormants"
.maxNumFormants = Get value: maxNumFormantsID, "input"
preEmphFromID = Search column: "variable", "preEmphFrom"
.preEmphFrom = Get value: preEmphFromID, "input"
f1refID = Search column: "variable", "f1ref"
.f1ref = Get value: f1refID, "input"
f2refID = Search column: "variable", "f2ref"
.f2ref = Get value: f2refID, "input"
f3refID = Search column: "variable", "f3ref"
.f3ref = Get value: f3refID, "input"
f3refID = Search column: "variable", "f3ref"
.f3ref = Get value: f3refID, "input"
maxFormantHzID = Search column: "variable", "maxFormantHz"
.maxFormantHz = Get value: maxFormantHzID, "input"
pitchSynchronousID = Search column: "variable", "pitchSynchronous"
.pitchSynchronous = Get value: pitchSynchronousID, "input"
cppTrendTypeID = Search column: "variable", "cppTrendType"
.cppTrendType = Get value: cppTrendTypeID, "input"
cppFastID = Search column: "variable", "cppFast"
.cppFast = Get value: cppFastID, "input"
pitchSaveID = Search column: "variable", "pitchSave"
.pitchSave = Get value: pitchSaveID, "input"
pitchSaveDirID = Search column: "variable", "pitchSaveDir"
.pitchSaveDir$ = Get value: pitchSaveDirID, "input"
pitchReadID = Search column: "variable", "pitchRead"
.pitchRead = Get value: pitchReadID, "input"
pitchReadDirID = Search column: "variable", "pitchReadDir"
.pitchReadDir$ = Get value: pitchReadDirID, "input"
formantSaveID = Search column: "variable", "formantSave"
.formantSave = Get value: formantSaveID, "input"
formantSaveDirID = Search column: "variable", "formantSaveDir"
.formantSaveDir$ = Get value: formantSaveDirID, "input"
formantReadID = Search column: "variable", "formantRead"
.formantRead = Get value: formantReadID, "input"
formantReadDirID = Search column: "variable", "formantReadDir"
.formantReadDir$ = Get value: formantReadDirID, "input"
useTextGridID = Search column: "variable", "useTextGrid"
.useTextGrid = Get value: useTextGridID, "input"
tgDirID = Search column: "variable", "tgDir"
.tgDir$ = Get value: tgDirID, "input"
filelistID = Search column: "variable", "filelist"
.filelist$ = Get value: filelistID, "input"
intervalTierID = Search column: "variable", "intervalTier"
.intervalTier = Get value: intervalTierID, "input"
includeTheseLabelsID = Search column: "variable", "includeTheseLabels"
.includeTheseLabels$ = Get value: includeTheseLabelsID, "input"

Remove

## add trailing slashes to the directory names since it doesn't matter if
## they're doubled

.inputDir$ = .inputDir$ + "/"
.outputDir$ = .outputDir$ + "/"
.tgDir$ = .tgDir$ + "/"
.pitchSaveDir$ = .pitchSaveDir$ + "/"
.pitchReadDir$ = .pitchReadDir$ + "/"
.formantSaveDir$ = .formantSaveDir$ + "/"
.formantReadDir$ = .formantReadDir$ + "/"

## set voicingThreshold and octaveCost depending on pitchMethod

if .voicingThreshold = 0
  if .pitchMethod = 0
    .voicingThreshold = 0.5
  else
    .voicingThreshold = 0.45
  endif
endif

if .octaveCost = 0
  if .pitchMethod = 0
    .octaveCost = 0.055
  else
    .octaveCost = 0.01
  endif
endif

## some sanity checks. should probably add more, these were the first that came
## to mind

if .intervalEquidistant + .intervalFixed = 0
exitScript: "Either intervalEquidistant or intervalFixed in the params file ";
	... "should contain a number above 0."
endif

if .intervalEquidistant > 0 & .intervalFixed > 0
exitScript: "Either intervalEquidistant or intervalFixed in the params file ";
	... "should be 0."
endif

if .maxNumFormants < 3
exitScript: "maxNumFormants should be 3 or more"
endif

## more general variables telling us whether formants, pitch, etc are required.
## i.e even if the user doesn't want a pitch measure returned, it may still be
## required to compute harmonic amplitudes if the user wants those, etc

.measureFormants = .formant + .harmonicAmplitude + .harmonicAmplitudeUncorrected +
  ... .bw + .bwHawksMiller + .slope + .slopeUncorrected

.measurePitch = .pitch + .harmonicAmplitude + .harmonicAmplitudeUncorrected +
  ... .slope + .slopeUncorrected + .bw + .bwHawksMiller + .soe

.spectralMeasures = .harmonicAmplitude + .harmonicAmplitudeUncorrected +
  ... .slope + .slopeUncorrected

.measureSlope = .slope + .slopeUncorrected

.requireBandwidths = .bwHawksMiller + .bw + .spectralMeasures

if .bwHawksMiller = 0
  .measureBandwidths = .bw + .spectralMeasures
else
  .measureBandwidths = 0
endif

## delete output file if it already exists

filedelete "'outputDir$''outputFile$'"

endproc
