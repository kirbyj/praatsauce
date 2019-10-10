include splitstring.praat

form log name
  sentence log log file name
endform

# Returns length and 1-indexed array
@splitstring: "This is a test", " "
assert splitstring.strLen = 4
assert splitstring.array$[4] = "test"
assert splitstring.array$[1] = "This"
