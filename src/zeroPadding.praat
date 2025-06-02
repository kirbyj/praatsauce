### Pad derived signal vectors with zeros to ensure that they are equal length
### Almost certainly overthinking this

procedure zeroPadding: .res#, .numFrames, .mostFrames, .times#, .firstFrame,
  ... .lastFrame, .timeStep, .equidistant, .start

if .equidistant <> 0 & .start > 0
  .res# = .res#
else
  if min(.times#) > .firstFrame & .numFrames < .mostFrames
    diffFrames = (min(.times#) - .firstFrame) / .timeStep
    if round(diffFrames) + size(.res#) > .mostFrames
      discrepancy = (round(diffFrames) + size(.res#)) - .mostFrames
      diffFrames = diffFrames - discrepancy
    endif
    padStart# = zero#( round(diffFrames) )
    .res# = combine# (padStart#, .res#)
    .numFrames = size(.res#)
  else
    .res# = .res#
  endif

  if max(.times#) < .lastFrame & .numFrames < .mostFrames
    diffFrames = (.lastFrame - max(.times#)) / .timeStep
    if round(diffFrames) + size(.res#) > .mostFrames
      discrepancy = (round(diffFrames) + size(.res#)) - .mostFrames
      diffFrames = diffFrames - discrepancy
    endif
    padEnd# = zero#( round(diffFrames) )
    .res# = combine# (.res#, padEnd#)
  else
    .res# = .res#
  endif

endif

if size(.res#) < .mostFrames
  discrepancy = .mostFrames - size(.res#)
  .res# = combine# (.res#, zero#(discrepancy))
endif

endproc
