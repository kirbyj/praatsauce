### Ensure that only within-interval frames are included

procedure restrictInterval: .orgTimes#, .orgVals#, .start, .end

.newTimes# = { 0 }
.newVals# = { 0 }
j = 0

for i from 1 to size(.orgTimes#)
  if .orgTimes#[i] > .start & .orgTimes#[i] < .end
    if j = 0
      .newTimes#[1] = .orgTimes#[i]
      .newVals#[1] = .orgVals#[i]
      j = j + 1
    else
      .newTimes# = combine#(.newTimes#, .orgTimes#[i])
      .newVals# = combine#(.newVals#, .orgVals#[i])
    endif
  endif
endfor

endproc
