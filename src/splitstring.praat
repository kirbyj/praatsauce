## splitstring.praat: parse a string into an "array"

## James Kirby <j.kirby@ed.ac.uk>
## 23 February 2017
## (adapted from a procedure by Paul Boersma)

procedure splitstring: .string$, .sep$
    .strLen = 0
    repeat
        .sepIndex = index (.string$, .sep$)
        if .sepIndex <> 0
            .value$ = left$ (.string$, .sepIndex - 1)
            .string$ = mid$ (.string$, .sepIndex + 1, 10000)
        else
            .value$ = .string$
        endif
        .strLen = .strLen + 1
        .array$[.strLen] = .value$
    until .sepIndex = 0
endproc

## Call with e.g.
##
##    @splitstring: name$, separator$
##
## then access with
##
##    splitstring.strLen
##    splitstring.array$[i]
##
## etc.  
