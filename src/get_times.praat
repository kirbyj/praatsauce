### Get time stamps to determine which parts of sound file to process in PraatSauce

procedure times: .fileName$, .inputDir$, .includeTheseLabels$, .useTextGrid,
  ... .intervalTier, .windowLength

snd = selected("Sound")

## get TextGrid name from sound file name

baseName$ = left$("'.fileName$'", index("'.fileName$'", ".") - 1)
tgName$ = baseName$ + ".TextGrid"

if .useTextGrid = 1
  ## ... when TextGrid is used ...
  ## read TG file

	tg = Read from file: .inputDir$ + baseName$ + ".TextGrid"

	## get the number of intervals that user asked for

	.numIntervals = Count intervals where: .intervalTier, "matches (regex)",
		... .includeTheseLabels$

  ## do some tomfoolery to actually grab all start times in one fell swoop

	points = Get starting points: .intervalTier, "matches (regex)",
	  ... .includeTheseLabels$
	matrix = To Matrix
	.start# = Get all values in row: 1

	## clean up

  removeObject: points, matrix
  selectObject: tg

	## do some tomfoolery to actually grab all end times in one fell swoop

	point = Get end points: .intervalTier, "matches (regex)", .includeTheseLabels$
	matrix = To Matrix
	.end# = Get all values in row: 1

	## clean up

  removeObject: point, matrix
  selectObject: tg

	## create string vector with labels
	## has to be a loop I think

	for int from 1 to .numIntervals
		labID = Get interval at time: .intervalTier, .start# [int]
		.labs$ [int] = Get label of interval: .intervalTier, labID
	endfor
	removeObject: tg
else
  ## ... when TextGrid isn't used ...
  ## start and end times should just match the entire sound file and labels
  ## are meaningless. still have to make sure that they're vectors though,
  ## since data types are hardcoded in the variable names

	.numIntervals = 1
	selectObject: snd
	start = Get start time
	.start# = { start }
	end = Get end time
	.end# = { end }
	.labs$ [1] = "x"
endif

endproc
