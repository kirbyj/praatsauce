### Get time stamps to determine which parts of sound file to process in PraatSauce

procedure times: .fileName$, .inputDir$, .includeTheseLabels$, .useTextGrid,
  ... .intervalTier, .windowLength

soundID = selected("Sound")

## get TextGrid name from sound file name

baseName$ = left$("'.fileName$'", index("'.fileName$'", ".") - 1)
tgName$ = baseName$ + ".TextGrid"

if .useTextGrid = 1
  ## ... when TextGrid is used ...
  ## read TG file

	Read from file: .inputDir$ + baseName$ + ".TextGrid"
	tgID = selected("TextGrid")

	## get the number of intervals that user asked for

	.numIntervals = Count intervals where: .intervalTier, "matches (regex)",
		... .includeTheseLabels$

  ## do some tomfoolery to actually grab all start times in one fell swoop

	Get starting points: .intervalTier, "matches (regex)", .includeTheseLabels$
	pointsID = selected("PointProcess")
	To Matrix
	matrixID = selected("Matrix")
	.start# = Get all values in row: 1

	## clean up

	select pointsID
	plus matrixID
	Remove

	select tgID

	## do some tomfoolery to actually grab all end times in one fell swoop

	Get end points: .intervalTier, "matches (regex)", .includeTheseLabels$
	pointsID = selected("PointProcess")
	To Matrix
	matrixID = selected("Matrix")
	.end# = Get all values in row: 1

	## clean up

	select pointsID
	plus matrixID
	Remove

	select tgID

	## create string vector with labels
	## has to be a loop I think

	for int from 1 to .numIntervals
		labID = Get interval at time: .intervalTier, .start# [int]
		.labs$ [int] = Get label of interval: .intervalTier, labID
	endfor
	Remove
else
  ## ... when TextGrid isn't used ...
  ## start and end times should just match the entire sound file and labels
  ## are meaningless. still have to make sure that they're vectors though,
  ## since data types are hardcoded in the variable names

	.numIntervals = 1
	select soundID
	start = Get start time
	.start# = { start }
	end = Get end time
	.end# = { end }
	.labs$ [1] = "x"
endif

endproc
