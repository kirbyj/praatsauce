### Pad derived signal vectors with zeros to ensure that they are equal length

procedure zeroPadding: .res#, .numFrames, .mostFrames, .times#, .firstFrame,
  ... .lastFrame, .timeStep, .equidistant

if .equidistant <> 0
  .res# = .res#
else
  if min(.times#) > .firstFrame & .numFrames < .mostFrames
    diffFrames = (min(.times#) - .firstFrame) / .timeStep
    padStart# = zero#( round(diffFrames) )
    .res# = combine# (padStart#, .res#)
    .numFrames = size(.res#)
  else
    .res# = .res#
  endif

  if max(.times#) < .lastFrame & .numFrames < .mostFrames
    diffFrames = (.lastFrame - max(.times#)) / .timeStep
    padEnd# = zero#( round(diffFrames) )
    .res# = combine# (padEnd#, .res#)
  else
    .res# = .res#
  endif
endif


endproc
