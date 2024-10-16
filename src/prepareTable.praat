### Convert matrix of PraatSauce results to a table and save to disk

procedure prepareTable: .fileName$, .outputDir$, .outputFile$, .useTextGrid, .lab$

## data structure tomfoolery -- convert matrix to long format, then to
## TableOfReal, and then to Table

finalMatrixID = selected("Matrix")
Transpose
tmatrixID = selected("Matrix")
To TableOfReal
torID = selected("TableOfReal")
To Table: "x"
tableID = selected("Table")

## loop through table and add file name
## doesn't seem like there's a vectorized way to add strings to tables!

nRow = Get number of rows
for r from 1 to nRow
	Set string value: r, "x", .fileName$
endfor

## if using TextGrid, loop through table and add interval labels

if .useTextGrid <> 0
	Insert column: 2, "lab"
	for r from 1 to nRow
		Set string value: r, "lab", .lab$
	endfor
endif

## some really silly data structure tomfoolery which seems to be the only way
## to avoid adding column names to the results file again and again & again

results$ = List: 0
Create Strings from tokens: "results", results$, "'newline$'"
stringsID = selected("Strings")
Remove string: 1
Replace all: "$", "\n", 0, "regular expressions"
stringsRepID = selected("Strings")
results$# = List all strings

## add results to file

appendFile: "'.outputDir$''.outputFile$'", results$#

## clean up

select stringsID
plus stringsRepID
plus tableID
plus torID
plus tmatrixID
plus finalMatrixID
Remove

endproc
