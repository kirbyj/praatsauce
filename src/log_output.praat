procedure show_title: .title$
    appendInfoLine: "-------"
    appendInfoLine: .title$
    appendInfoLine: "-------"
endproc

procedure show_common_settings:
... .resample_to_16k, .windowLength, .windowPosition, .maxFormantHz
    @show_title: "Common Settings"
    appendInfoLine: "resample_to_16k: <", .resample_to_16k, ">"
    appendInfoLine: "windowLength: <", .windowLength, ">"
    appendInfoLine: "windowPosition: <", .windowPosition, ">"
    appendInfoLine: "maxFormantHz: <", .maxFormantHz, ">"
    appendInfoLine: ""
endproc

procedure show_pitch_tracking: .useExistingPitch, .f0min, .f0max
    @show_title: "Pitch tracking"
    appendInfoLine: "useExistingPitch: <", .useExistingPitch, ">"
    appendInfoLine: "f0min: <", .f0min, ">"
    appendInfoLine: "f0max: <", .f0max, ">"
    appendInfoLine: ""
endproc

procedure show_formant_measures:
... .listenToSound, .timeStep, .maxNumFormants, .preEmphFrom,
... .formantTracking, .f1ref, .f2ref, .f3ref, .saveAsEPS,
... .useExistingFormants, .useBandwidthFormula
    @show_title: "Formant measures"
    appendInfoLine: "listenToSound: <", .listenToSound, ">"
    appendInfoLine: "timeStep: <", .timeStep, ">"
    appendInfoLine: "maxNumFormants: <", .maxNumFormants, ">"
    appendInfoLine: "preEmphFrom: <", .preEmphFrom, ">"
    appendInfoLine: "formantTracking: <", .formantTracking, ">"
    appendInfoLine: "F1ref: <", .f1ref, ">"
    appendInfoLine: "F2ref: <", .f2ref, ">"
    appendInfoLine: "F3ref: <", .f3ref, ">"
    appendInfoLine: "saveAsEPS: <", .saveAsEPS, ">"
    appendInfoLine: "useExistingFormants: <", .useExistingFormants, ">"
    appendInfoLine: "useBandwidthFormula: <", .useBandwidthFormula, ">"
    appendInfoLine: ""
endproc
