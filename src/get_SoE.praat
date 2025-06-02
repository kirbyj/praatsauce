include zeroFrequencyFilter.praat

procedure soe: .fs, .meanF0, .timeStep, .numFrames, .times#, .windowLength,
  ... .start, .end

## extract snippet, using same window as for pitch estimation

snd = selected("Sound")

@snippet: .start, .end, ((3 * (1 / 50)) / 2) + (.timeStep / 2)
start = Get start time
snippet = selected("Sound")
dur = Get total duration

## resample to 16kHz unless sample rate already 16 kHz or lower, in which case
## make a copy of the sound before filtering

if .fs > 16000
  Resample: 16000, 50
  newFS = 16000
else
  Copy: "x"
  newFS = .fs
endif

# if there are no pitch values in the intervals, use some reasonable value
# to avoid erroring out

if .meanF0 = undefined
  meanPitchSamp = newFS / 150
else
  meanPitchSamp = newFS / .meanF0
endif
windSamp = round (2 * (meanPitchSamp / 1.5) + 1)

## get differenced signal

Reverse
Formula: "self - self[col + 1]"
Reverse

## cascade of zero frequency filters

@zeroFrequencyFilter: dur, newFS, windSamp, start
@zeroFrequencyFilter: dur, newFS, windSamp, start

filter = selected("Sound")

## time information gets messed up at some point in the above by converting
## between matrices and sound objects, so we fix that...

Shift times to: "start time", start

## scale peak and get all values from the filtered sound so we can regress
## over them

if .start > 0
  tmp = Extract part: start + ((3 * (1 / 50)) / 2) + (.timeStep / 2),
    ... start + dur - ((3 * (1 / 50)) / 2) + (.timeStep / 2), "rectangular", 1, 1

  removeObject: filter
  filter = selected("Sound")
endif


Scale peak: 0.99
filtMat = Down to Matrix
z# = Get all values in row: 1

## Create pointprocess object with positive-to-negative zero crossings
## corresponding to glottal closure instants

selectObject: filter
pp = To PointProcess (zeroes): 1, 0, 1

## initialize object for SOE values

.soe# = zero#(.numFrames)

## loop through times vector

for i from 1 to .numFrames

  ## get the zero crossing nearest to the current times

	nearest = Get nearest index: .times#[i]
	zc = Get time from index: nearest

	## return 0 if zero crossing is further away than the .timeStep
	## or if no zero crossing is found

	if zc - .times#[i] > .timeStep | zc - .times#[i] < -.timeStep | zc = undefined
		.soe#[i] = 0
	else

	## otherwise calculate slope around the zero crossings

		selectObject: filter
		samp = Get sample number from time: zc
		samp = round(samp)
		numer = 0
		denom = 0
		for theta from 1 to 5
		  if samp + theta < size(z#) & samp - theta > 0
  			numer = numer + theta * (z#[samp+theta] - z#[samp-theta])
  			denom = denom + 2 * theta^2
  		else
  		  numer = 0
  		  denom = 0
  		endif
		endfor
		.soe#[i] = numer / denom
		.soe#[i] = -.soe#[i]
		selectObject: pp
	endif
endfor

## clean up

removeObject: snippet, filter, filtMat, pp
selectObject: snd

endproc
