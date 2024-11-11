### Get harmonic amplitudes and spectral measures

include correctIseli.praat
include extract_snippet.praat

procedure spec: .windowLength, .timeStep, .numFrames, .times#,
  ... .measureSlope, .measureSlopeUncorrected, .pitchSynchronous,
	... .f0min, .f0max, .f0#, .f1#, .f2#, .f3#, .b1#, .b2#, .b3#, .fs, .start, .end

## extract padded snippet.
## analysis windows are rounded in some arcane fashion, which is ignored here.

soundID = selected("Sound")

@snippet: .start, .end, .windowLength + (.timeStep / 2)
snippetID = selected("Sound")

## initiate empty vectors for harmonic amplitudes

.h1u# = zero# (.numFrames)
.h2u# = zero# (.numFrames)
.h4u# = zero# (.numFrames)
.a1u# = zero# (.numFrames)
.a2u# = zero# (.numFrames)
.a3u# = zero# (.numFrames)
.h2ku# = zero# (.numFrames)
.h5ku# = zero# (.numFrames)

## upper and lower limits where to search for f0-based harmonic amplitudes
## created here to vectorize as much as possible

lowerbh1# = .f0# - (.f0# / 10)
upperbh1# = .f0# + (.f0# / 10)
lowerbh2# = (.f0# * 2) - (.f0# / 10)
upperbh2# = (.f0# * 2) + (.f0# / 10)
lowerbh4# = (.f0# * 4) - (.f0# / 10)
upperbh4# = (.f0# * 4) + (.f0# / 10)

## upper and lower limits where to search for H2K and H5K.
## based on +/- f0, which in legacy PS was calculated from the cepstral peak
## (not sure why)

lowerbh2k# = 2000 - .f0#
upperbh2k# = 2000 + .f0#
lowerbh5k# = 5000 - .f0#
upperbh5k# = 5000 + .f0#

## upper and lower limits where to search for formant-based harmonic amplitudes

lowerba1# = .f1# - (.f1# * 0.2)
upperba1# = .f1# + (.f1# * 0.2)
lowerba2# = .f2# - (.f2# * 0.1)
upperba2# = .f2# + (.f2# * 0.1)
lowerba3# = .f3# - (.f3# * 0.1)
upperba3# = .f3# + (.f3# * 0.1)

## make spectrograms. arguments include frequency ceiling (default is 5000,
## set a bit higher to properly calculate H5K), frequency step (default 20 Hz,
## but maybe we want higher precision?), and window shape

if .pitchSynchronous = 0

  To Spectrogram: .windowLength, 5500, .timeStep, 20, "Gaussian"
  spectrogramID = selected("Spectrogram")

endif

## can't think of a way to vectorize this, so it's loops all the way down :-(

for frame from 1 to .numFrames

	if (.f0# [frame] <> undefined & .f0# [frame] <> 0)

	  ## ... only proceed for frames where we have an f0 measure ...

    if .pitchSynchronous = 0

    	select spectrogramID

    	## grab spectral slice and convert that to long-term average spectrum.
    	## the LTAS object has the exact same information as the spectral slice!
    	## this is only done because the different data structures can be queried
    	## in different ways

    	To Spectrum (slice): .times# [frame]
    	spectrumID = selected("Spectrum")
    	To Ltas (1-to-1)
    	ltasID = selected("Ltas")

  	else

  	  select snippetID
  	  halfWinSize = (1 / .f0# [frame]) * 1.5
  	  Extract part: times# [frame] - halfWinSize, times# [frame] + halfWinSize,
  	    ... "Gaussian1", 1, 0
  	  pitchWindowID = selected("Sound")
  	  To Spectrum: 1
  	  spectrumID = selected("Spectrum")
  	  To Ltas (1-to-1)
  	  ltasID = selected("Ltas")

  	  select pitchWindowID
  	  Remove
  	  select ltasID

  	endif

	  ## get the highest amplitude in the ranges we specified above
	  ## "none" = no interpolation

		.h1u# [frame] = Get maximum: lowerbh1# [frame], upperbh1# [frame],
			... "none"
		.h2u# [frame] = Get maximum: lowerbh2# [frame], upperbh2# [frame],
			... "none"
		.h4u# [frame] = Get maximum: lowerbh4# [frame], upperbh4# [frame],
			... "none"
		.h2ku# [frame] = Get maximum: lowerbh2k# [frame],
			... upperbh2k# [frame], "none"
		.h5ku# [frame] = Get maximum: lowerbh5k# [frame],
			... upperbh5k# [frame], "none"
		.a1u# [frame] = Get maximum: lowerba1# [frame], upperba1# [frame],
			... "none"
		.a2u# [frame] = Get maximum: lowerba2# [frame], upperba2# [frame],
			... "none"
		.a3u# [frame] = Get maximum: lowerba3# [frame], upperba3# [frame],
			... "none"

		## clean up
  	select spectrumID
  	plus ltasID
  	Remove

	endif

endfor

## Not sure if I understand how this theoretically works for H2k and H5k
## Legacy praatsauce corrects for H2k by using the third formant

## Iseli correction of harmonic amplitude based on f0 and relevant formants.
## legacy PS does correction of H2k based on first three formants, does no
## correction for H5k. here I correct neither.

@correctIseli: .f0#, .f1#, .b1#, .fs
.h1c# = .h1u# - correctIseli.res#
@correctIseli: .f0#, .f2#, .b2#, .fs
.h1c# = .h1c# - correctIseli.res#
@correctIseli: 2 * .f0#, .f1#, .b1#, fs
.h2c# = .h2u# - correctIseli.res#
@correctIseli: 2 * .f0#, .f2#, .b2#, fs
.h2c# = .h2c# - correctIseli.res#
@correctIseli: 4 * .f0#, .f1#, .b1#, fs
.h4c# = .h4u# - correctIseli.res#
@correctIseli: 4 * .f0#, .f2#, .b2#, fs
.h4c# = .h4c# - correctIseli.res#
@correctIseli: .f1#, .f1#, .b1#, fs
.a1c# = .a1u# - correctIseli.res#
@correctIseli: .f1#, .f2#, .b2#, fs
.a1c# = .a1c# - correctIseli.res#
@correctIseli: .f2#, .f1#, .b1#, fs
.a2c# = .a2u# - correctIseli.res#
@correctIseli: .f2#, .f2#, .b2#, fs
.a2c# = .a2c# - correctIseli.res#
@correctIseli: .f3#, .f1#, .b1#, fs
.a3c# = .a3u# - correctIseli.res#
@correctIseli: .f3#, .f2#, .b2#, fs
.a3c# = .a3c# - correctIseli.res#
@correctIseli: .f3#, .f3#, .b3#, fs
.a3c# = .a3c# - correctIseli.res#

## calculate corrected harmonic slopes
## (also return uncorrected H2K-H5K, since there is no correction for this)

if .measureSlope <> 0
	.h1h2c# = .h1c# - .h2c#
	.h2h4c# = .h2c# - .h4c#
	.h1a1c# = .h1c# - .a1c#
	.h1a2c# = .h1c# - .a2c#
	.h1a3c# = .h1c# - .a3c#
	.h2kh5ku# = .h2ku# - .h5ku#
endif

## calculate uncorrected harmonic slopes for those who want it!

if .measureSlopeUncorrected <> 0
	.h1h2u# = .h1u# - .h2u#
	.h2h4u# = .h2u# - .h4u#
	.h1a1u# = .h1u# - .a1u#
	.h1a2u# = .h1u# - .a2u#
	.h1a3u# = .h1u# - .a3u#
endif

## clean up

if .pitchSynchronous = 0
  select spectrogramID
  Remove
endif

select snippetID
Remove

select soundID

endproc
