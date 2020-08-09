# pitchTracking.praat
# version 0.0.1
#
# from a script copyright 2009-2010 Timothy Mills <mills.timothy@gmail.com>
# heavily modified 2011-2017 James Kirby <j.kirby@ed.ac.uk>

# This script is designed to work as part of the "praatsauce" script suite,
# which can be obtained from:
#
#      https://github.com/kirbyj/praatsauce
#
# This script is released under the GNU General Public License version 3.0 
# The included file "gpl-3.0.txt" or the URL "http://www.gnu.org/licenses/gpl.html" 
# contains the full text of the license.

form Parameters for f0 measurement
 comment TextGrid interval
 natural tier 4
 natural interval_number 0
# text interval_label v
 real windowPosition
 positive windowLength
 boolean manualCheck 1
 boolean outputToMatrix 0
 positive measure 2
 positive timepoints 10
 positive timestep 1
endform

###
### First, check that proper objects are present and selected.
###
numSelectedSound = numberOfSelected("Sound")
numSelectedTextGrid = numberOfSelected("TextGrid")
numPitch = numberOfSelected("Pitch")
if (numSelectedSound<>1 or numSelectedTextGrid<>1 or numPitch<>1)
 exit Select only one Sound, one TextGrid, and one Pitch object.
endif
name$ = selected$("Sound")
soundID = selected("Sound")
textGridID = selected("TextGrid")
pitchID = selected("Pitch")
### (end object check)

###
### Second, establish time domain.
###
select textGridID
if interval_number > 0
 intervalOfInterest = interval_number
#else
# numIntervals = Get number of intervals... 'tier'
# for currentInterval from 1 to 'numIntervals'
# 	currentIntervalLabel$ = Get label of interval... 'tier' 'currentInterval'
#    if currentIntervalLabel$==interval_label$
#    	intervalOfInterest = currentInterval
#    endif
# endfor
endif

startTime = Get starting point... 'tier' 'intervalOfInterest'
endTime = Get end point... 'tier' 'intervalOfInterest'
### (end time domain check) ##

###
### Third, decide what times to measure at.
###

d = startTime + (timestep/1000)
## If equidistant points: compute based on number of points
if measure = 1
    diff = (endTime - startTime) / (timepoints+1)
## If absolute: take a measurement every timepoints/1000 points
elsif measure = 2
    diff = timestep / 1000
endif
for point from 1 to timepoints
    mid'point' = d
    d = d + diff
endfor
### (end time point selection)

###
### Fourth, build Matrix object to hold results
### each row represents a timepoint
### second column represents absolute timepoint of the measurement (distance from startTime)
### third column represents an f0 measurement
if outputToMatrix
    Create simple Matrix... PitchAverages timepoints 3 0
    matrixID = selected("Matrix")
endif
### (end build Matrix object)

###
### Fifth, store a measurement at each timepoint.
###
for i from 1 to timepoints

	if outputToMatrix
		select 'pitchID'
		f0 = Get value at time... mid'i' Hertz Linear
		timestamp = mid'i'
		if f0 = undefined
			f0 = 0 
		endif
		select 'matrixID'

        # find time of measurement, relative to startTime
        #absPoint = mid'i' - startTime
        #absPoint = round( (mid'i' - startTime)*1000 ) / 1000

        # set first value to ms time
		#Set value... i 1 absPoint
		Set value... i 1 mid'i'
        # set second value to f0
        Set value... i 2 'f0'
	else
        printline "'name$''tab$''f0'"
	pause
	endif
endfor
### (end measurement loop)

select 'soundID'
plus 'textGridID'

