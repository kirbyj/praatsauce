## Combine two matrices

procedure combineMatrices: .add##

orgMatrixID = selected("Matrix")

## make matrix appear in the objects list

Create simple Matrix from values: "results", .add##

## select both matrices to be combined and merge them

newMatrixID = selected("Matrix")
plus orgMatrixID
Merge (append rows)
combinedMatrixID = selected("Matrix")

## clean up

select orgMatrixID
plus newMatrixID
Remove

select combinedMatrixID

endproc
