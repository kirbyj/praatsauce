### Build first line of PraatSauce results table

procedure initiateTable: .pitch, .formants, .harmonicAmplitude,
  ... .harmonicAmplitudeUncorrected, .bw, .slope, .slopeUncorrected, .cpp, .hnr,
  ... .rms, .soe, .outputDir$, .outputFile$, .useTextGrid

## we build a string with space-delimited column names depending on the
## measures that users ask for.
## always need a column with file name

firstLine$ = "file"

## add label column only if users are using TextGrids

if .useTextGrid <> 0
	firstLine$ = firstLine$ + " label"
endif

## always need a column with times

firstLine$ = firstLine$ + " t"

## other columns depend on which measures users want returned

if .pitch <> 0
	firstLine$ = firstLine$ + " f0"
endif

if .formants <> 0
	firstLine$ = firstLine$ + " F1 F2 F3"
endif

if .harmonicAmplitude <> 0
	firstLine$ = firstLine$ + " H1c H2c H4c A1c A2c A3c H2Ku H5Ku"
endif

if .harmonicAmplitudeUncorrected <> 0
	firstLine$ = firstLine$ + " H1u H2u H4u A1u A2u A3u"
endif

if .bw <> 0
	firstLine$ = firstLine$ + " B1 B2 B3"
endif

if .slope <> 0
	firstLine$ = firstLine$ + " H1H2c H2H4c H1A1c H1A2c H1A3c H2KH5Ku"
endif

if .slopeUncorrected <> 0
	firstLine$ = firstLine$ + " H1H2u H2H4u H1A1u H1A2u H1A3u"
endif

if .cpp <> 0
	firstLine$ = firstLine$ + " CPP"
endif

if .hnr <> 0
	firstLine$ = firstLine$ + " HNR05 HNR15 HNR25 HNR35"
endif

if .rms <> 0
	firstLine$ = firstLine$ + " intensity"
endif

if .soe <> 0
  firstLine$ = firstLine$ + " soe"
endif

## make table with required arguments: object name, number of rows, column names

Create Table with column names: "init", 0, firstLine$
tableID = selected("Table")

## save the table as tsv

Save as tab-separated file: "'.outputDir$''.outputFile$'"

## clean up

select tableID
Remove

endproc
