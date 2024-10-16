procedure snippet: .start, .end, .pad

## if using TextGrid interval, extract that interval from the sound file
## + half a window length and half a time step on each side of the interval,
## to make sure that the first measure is centered roughly at the beginning
## of the interval.
## if no TextGrid is used, "extract" whole sound file. a bit computationally
## wasteful, but I did some loop tests and snipping sound files seems to be
## blazing fast.

dur = Get end time

if .start > 0
	start = .start - .pad
else
	start = 0
endif

if .end < dur
	end = .end + .pad
else
	end = dur
endif

## arguments for sound file snipping: start and end times, window shape
## (a "rectangular" window is basically equivalent to no window at all),
## relative width (?? no documentation), and whether to preserve original times
## (yes we want this!)

Extract part: start, end, "rectangular", 1, 1

endproc
