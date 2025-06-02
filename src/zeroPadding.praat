### Pad derived signal vectors with zeros to ensure that they are equal length
### Almost certainly overthinking this

procedure zeroPadding: .res#, .numFrames, .mostFrames, .times#, .firstFrame,
  ... .lastFrame, .timeStep, .equidistant, .start

if .equidistant <> 0 & .start > 0
  .res# = .res#
else
  if min(.times#) > .firstFrame & .numFrames < .mostFrames
    diffFrames = (min(.times#) - .firstFrame) / .timeStep
    #padStart# = zero#( round(diffFrames) )
    padStart# = zero#( ceiling(diffFrames) )
    .res# = combine# (padStart#, .res#)
    .numFrames = size(.res#)
  else
    .res# = .res#
  endif

  if max(.times#) < .lastFrame & .numFrames < .mostFrames
    diffFrames = (.lastFrame - max(.times#)) / .timeStep
    if floor(diffFrames) + .numFrames > .mostFrames
      discrepancy = (floor(diffFrames) + .numFrames) - .mostFrames
      diffFrames = diffFrames - discrepancy
    endif
    #padEnd# = zero#( round(diffFrames) )
    padEnd# = zero#( floor(diffFrames) )
    .res# = combine# (.res#, padEnd#)
  else
    .res# = .res#
  endif
  
  if size(.res#) < .mostFrames
    discrepancy = .mostFrames - size(.res#)
    .res# = combine# (.res#, zero#(discrepancy))
  endif
endif


endproc
