### Convert matrix of PraatSauce results to a table and save to disk

procedure prepareTable: .fileName$, .outputDir$, .outputFile$, .useTextGrid,
  ... .lab$, .intervalID

## data structure tomfoolery -- convert matrix to long format, then to
## TableOfReal, and then to Table

finalMatrix = selected("Matrix")
tMatrix = Transpose
tor = To TableOfReal
table = To Table: "x"

## loop through table and add file name
## doesn't seem like there's a vectorized way to add strings to tables!

nRow = Get number of rows
for r from 1 to nRow
	Set string value: r, "x", .fileName$
endfor

## if using TextGrid, loop through table and add interval labels

if .useTextGrid <> 0
	Insert column: 2, "lab"
	Insert column: 3, "intervalID"
	for r from 1 to nRow
		Set string value: r, "lab", .lab$
		Set numeric value: r, "intervalID", .intervalID
	endfor
endif

## some really silly data structure tomfoolery which seems to be the only way
## to avoid adding column names to the results file again and again & again

results$ = List: 0
strings = Create Strings from tokens: "results", results$, "'newline$'"
Remove string: 1
stringsRep = Replace all: "$", "\n", 0, "regular expressions"
results$# = List all strings

## add results to file

appendFile: "'.outputDir$''.outputFile$'", results$#

## clean up

removeObject: strings, stringsRep, table, tor, tMatrix, finalMatrix

endproc
