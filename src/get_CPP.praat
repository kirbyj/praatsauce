### Get ceptral peak prominences

include extract_snippet.praat

procedure cpp: .timeStep, .f0min, .f0max, .start, .end

## extract padded snippet.
## one analysis window corresponds ROUGHLY to six pitch cycles (i.e.
## 6 * pitch floor), because for some reason this number is rounded in some
## arcane fashion.

soundID = selected("Sound")

@snippet: .start, .end, ((6 * (1 / .f0min)) / 2) + (.timeStep / 2)
snippetID = selected("Sound")

## create cepstrogram, grab frame times

To PowerCepstrogram: .f0min, .timeStep, 5000, 50
.times# = List all frame times
cepID = selected("PowerCepstrogram")

## tabulate cpp values based on the cepstrogram
## arguments are: should frame numbers and times be included in the table
## (no, we already grabbed them), should peak quefrencies be included (no,
## don't need them, afaik that's just inferior pitch tracking), how many decimals
## to include, "tolerance" (?? documentation is silent on this matter, it's set
## to 0.05 following defaults), interpolation (default parabolic), quefrency
## range (default 0.001-0.05), trend type (default exponential decay),
## fit method (robust -- default "robust slow" is truly slow)

To Table (cepstral peak prominences): 0, 0, 6, 3, 0, 3, .f0min, .f0max, 0.05, "parabolic",
	... 0.001, 0, "Exponential decay", "Robust"
tableID = selected("Table")
.res# = Get all numbers in column: "CPP(dB)"

## grab number of rows

.numFrames = Get number of rows

## clean up

select cepID
plus tableID
plus snippetID
Remove

select soundID

endproc
