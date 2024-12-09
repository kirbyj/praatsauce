### Pad derived signal vectors with zeros to ensure that they are equal length

procedure zeroPadding: .res#, .numFrames, .mostFrames

if .numFrames < mostFrames
  ## ... if there are vectors with more frames than the present one ...

  ## how many zeros should be added?
	diffFrames = .mostFrames - .numFrames

	## if uneven number, add one more zero to the start than the end
	padStart = ceiling(diffFrames / 2)
	padEnd = floor(diffFrames / 2)
	padStart# = zero# (padStart)
	.res# = combine# (padStart#, .res#)
	if padEnd <> 0
		padEnd# = zero# (padEnd)
		.res# = combine# (.res#, padEnd#)
	endif
else
  ## ... if there are no vectors with more frames than the present one,
  ## return results unchanged ...

	.res# = .res#
endif

endproc
