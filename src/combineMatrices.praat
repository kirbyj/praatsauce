## Combine two matrices

procedure combineMatrices: .add##

orgMatrix = selected("Matrix")

## make matrix appear in the objects list

newMatrix = Create simple Matrix from values: "results", .add##

## select both matrices to be combined and merge them

selectObject: newMatrix, orgMatrix
combinedMatrix = Merge (append rows)

## clean up

removeObject: orgMatrix, newMatrix
selectObject: combinedMatrix

endproc
