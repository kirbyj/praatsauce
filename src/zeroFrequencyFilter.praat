procedure zeroFrequencyFilter: .dur, .fs, .windSamp, .start

inputSoundID = selected("Sound")

## apply zero frequency filter

Formula: "self + self[col] - (-2*0.999) * self[col-1] + " +
	... "self[col] - (0.999^2) * self[col-2]"

## extract numbers

Down to Matrix
filtMatID = selected("Matrix")
filtVals# = Get all values in row: 1

## create empty sound to populate using filter

Create Sound from formula: "x", 1, 0, .dur, .fs, "0"
Shift times to: "start time", .start
filtID = selected("Sound")

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

Down to Matrix
movingAverageID = selected("Matrix")
movingAverageVals# = Get all values in row: 1

trendRem# = filtVals# - movingAverageVals#
Create simple Matrix from values: "x", { trendRem# }
trendRemID = selected("Matrix")
To Sound
Override sampling frequency: .fs
outputSoundID = selected("Sound")

## clean up

select inputSoundID
plus filtMatID
plus filtID
plus movingAverageID
plus trendRemID
Remove

select outputSoundID

endproc
