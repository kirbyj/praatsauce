procedure zeroFrequencyFilter: .dur, .fs, .windSamp, .start

inputSound = selected("Sound")

## apply zero frequency filter

Formula: "self + self[col] - (-2*0.999) * self[col-1] + " +
	... "self[col] - (0.999^2) * self[col-2]"

## extract numbers

filtMat = Down to Matrix
filtVals# = Get all values in row: 1

## create empty sound to populate using filter

filt = Create Sound from formula: "x", 1, 0, .dur, .fs, "0"
Shift times to: "start time", .start

## get moving average smooth of signal

### the window size used is based on the average pitch of the entire
### interval, whereas what Mittal et al and what voicesauce does is base the
### window size on the average pitch in a 50 ms window.
### should look into emulating this, but it would definitely take some more work.
### this is also simplified in how the edges are treated, I think this is by
### necessity given how the moving average filter is implemented.

weight = 1 / .windSamp

formula$ = "(" + string$(weight) + " * filtVals#[col - 1 + 1])"
for k from 2 to .windSamp
	formula$ = formula$ + "+ self + (" + string$(weight) +
	... "* filtVals#[col - " + string$(k) + " + 1])"
endfor
Formula: "if col > " + string$(.windSamp) + " then " + formula$ + " else self fi"
Formula: "self[col + " + string$(.windSamp / 2) + "]"

## trend removal and generating sound from matrix

movingAverage = Down to Matrix
movingAverageVals# = Get all values in row: 1

trendRem# = filtVals# - movingAverageVals#
trendRem = Create simple Matrix from values: "x", { trendRem# }
outputSound = To Sound
Override sampling frequency: .fs

## clean up

removeObject: inputSound, filtMat, filt, movingAverage, trendRem
selectObject: outputSound

endproc
