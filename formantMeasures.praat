### formantMeasures.praat
# version 0.0.5
#
# copyright 2009-2010 Timothy Mills
#
# This script takes a Sound object and an associated TextGrid, and
# determines the first three formant frequencies.  It can work in a 
# fully-automated fashion, but users are advised that formant 
# tracking errors can be common.  Manual checking of the output is
# recommended.
#
# This script is designed to work as a subscript of the master script 
# "spectralTiltMaster.praat", which can be obtained from the author:
#
#	Timothy Mills <mills.timothy@gmail.com>
#
# This script is released under the GNU General Public License version 3.0 
# (the same license that Praat is available under).  The included file
# "gpl-3.0.txt" or the URL "http://www.gnu.org/licenses/gpl.html" contains
# the full text of the license.

form Parameters for formant measurement
 comment TextGrid interval
 natural tier 1
 integer interval_number 2
 sentence interval_label v1
 comment Window parameters
 positive windowPosition 0.5
 positive windowLength 0.025
 comment Output
 boolean outputToMatrix 1
 boolean manualCheck 0
 boolean saveAsEPS 0
 text inputdir /home/username/data/
 boolean listenToSound 1
 comment Leave timeStep at 0 for auto.
 real timeStep 0
 integer maxNumFormants 5
 positive maxFormantHz 5500
 positive preEmphFrom 50
 positive f1ref 500
 positive f2ref 1500
 positive f3ref 2500
 positive spectrogramWindow 0.005
 positive measure 2
 positive points 3
endform

###
### First, check that proper objects are present and selected.
###
numSelectedSound = numberOfSelected("Sound")
numSelectedTextGrid = numberOfSelected("TextGrid")
if (numSelectedSound<>1 or numSelectedTextGrid<>1)
 exit Select only one Sound object and one TextGrid object.
endif
name$ = selected$("Sound")
soundID = selected("Sound")
textGridID = selected("TextGrid")
### (end object check)

###
### Second, establish time domain.
###
select textGridID
if 'interval_number' > 0
 intervalOfInterest = interval_number
else
 numIntervals = Get number of intervals... 'tier'
 for currentInterval from 1 to 'numIntervals'
  currentIntervalLabel$ = Get label of interval... 'tier' 'currentInterval'
  if currentIntervalLabel$==interval_label$
   intervalOfInterest = currentInterval
  endif
 endfor
endif

startTime = Get starting point... 'tier' 'intervalOfInterest'
endTime = Get end point... 'tier' 'intervalOfInterest'
### (end time domain check)

### repeat this procedure for each time point. 
### it seems tedious but this is the only way to go.


## Decide what times to measure at ##
## For the midpoint, just measure at 50%
if measure = 1
	points = 1
	mid1 = (startTime + endTime) / 2
## For the second measurement choice, we'll measure at 25%, 50%, and 75%
elsif measure = 2
	points = 3
	mid1 = startTime + (0.25 * (endTime - startTime))
	mid2 = (startTime + endTime) / 2
	mid3 = startTime + (0.75 * (endTime - startTime))
## For equidistant points we have to calculate the times
else
	for point from 1 to points
		## Ensure we are at least 12.5ms from the edges
		mid'point' = (((point - 1)/(points - 1)) * ((endTime-0.0125) - (startTime+0.0125))) + (startTime + 0.0125)
	endfor
endif

## Times have been stored

## Build Matrix object (once)
## each row represents a timepoint
## each column represents a formant
if outputToMatrix
	Create simple Matrix... FormantAverages points 3 0
	matrixID = selected("Matrix")
endif

# First, play sound (if requested)
if manualCheck
	if listenToSound
		select soundID
		Play
	endif
endif
## (end of manual check sound playback)

###
# Create Formant objects (once)
###
select 'soundID'
To Formant (burg)... 'timeStep' 'maxNumFormants' 'maxFormantHz' 'windowLength' 'preEmphFrom'
formantID = selected("Formant")

# Tracking cleans up the tracks a little.  The original Formant object is then discarded.
minFormants = Get minimum number of formants
if 'minFormants' = 2
    Track... 2 'f1ref' 'f2ref' 'f3ref' 3850 4950 1 1 1
else
    Track... 3 'f1ref' 'f2ref' 'f3ref' 3850 4950 1 1 1
endif
trackedFormantID = selected("Formant")
select formantID
Remove


## For all of these times... ##
for i from 1 to points

		checked = 1

        ## reason to build formant object at each timepoint is to allow user 
        ## to do manual checks and modifications...
        ## skipping for now 
        #
		## repeat until user is happy
		#repeat

		# Determine window: we will take an average over this window, 
		# centered at the point.
		midTime = mid'i'
		windowStart = midTime - (windowLength / 2)
		windowEnd = midTime + (windowLength / 2)
		 
		select trackedFormantID
		f1 = Get value at time... 1 mid'i' Hertz Linear
		f2 = Get value at time... 2 mid'i' Hertz Linear
		f3 = Get value at time... 3 mid'i' Hertz Linear
		#f1 = Get mean... 1 'windowStart' 'windowEnd' Hertz
		#f2 = Get mean... 2 'windowStart' 'windowEnd' Hertz
		#f3 = Get mean... 3 'windowStart' 'windowEnd' Hertz

		###
		# Display results
		###
		if (manualCheck or saveAsEPS)

		# Generate output in picture window
			select 'soundID'
			To Spectrogram... 'spectrogramWindow' 'maxFormantHz' 0.002 20 Gaussian
			spectrogramID = selected("Spectrogram")
			Erase all

			Select outer viewport... 0 6 0 3
			Paint... 'startTime' 'endTime' 0 'maxFormantHz' 100 yes 50 6 0 yes
			Marks left... 6 yes yes no
			Marks right... 6 yes yes no
			Yellow
			Line width... 3
			select 'trackedFormantID'
			#Speckle... 'startTime' 'endTime' 'maxFormantHz' 30 no
			Draw tracks... 'startTime' 'endTime' 'maxFormantHz' no
			rf1 = round('f1')
			rf2 = round('f2')
			Text top... no Tracker output -- F1: 'rf1' Hz ***** F2: 'rf2' Hz

			# Bracket window
			windowStart$ = fixed$(windowStart,3)
			windowEnd$ = fixed$(windowEnd,3)
			Line width... 1
		  	# This will mark the beginning and end of the window (blue lines)		
			#One mark bottom... 'windowStart' no no no 'windowStart$'
			#One mark bottom... 'windowEnd' no no no 'windowEnd$'
			Blue
			Draw line... 'windowStart' 0 'windowStart' 'maxFormantHz'
			Draw line... 'windowEnd' 0 'windowEnd' 'maxFormantHz'
			
			# This will just mark the midpoint (red line)
			Red
			mid = mid'i'
			midShort = 'mid:3'
			One mark bottom... 'mid' no no no 'midShort'
			Draw line... mid'i' 0 mid'i' 'maxFormantHz'

			Black
			Select outer viewport... 0 6 3 7
			select 'soundID'
			Extract part... 'windowStart' 'windowEnd' rectangular 1 yes
			soundPartID = selected("Sound")
			To Spectrum... yes
			spectrumID = selected("Spectrum")
			To Ltas (1-to-1)
			ltasID = selected("Ltas")
			minDB = Get minimum... 0 'maxFormantHz' None
			maxDB = Get maximum... 0 'maxFormantHz' None
			dBrange = maxDB-minDB
			maxDB = maxDB + 0.1*dBrange
			Draw... 0 'maxFormantHz' 'minDB' 'maxDB' yes  Curve
			Red
			f1Disp$ = fixed$(f1,0)
			f2Disp$ = fixed$(f2,0)
			f3Disp$ = fixed$(f3,0)
			Draw line... 'f1' 'minDB' 'f1' 'maxDB'
			One mark top... 'f1' no no no F1
			One mark bottom... 'f1' no no no 'f1Disp$'
			Draw line... 'f2' 'minDB' 'f2' 'maxDB'
			One mark top... 'f2' no no no F2
			One mark bottom... 'f2' no no no 'f2Disp$'
			Draw line... 'f3' 'minDB' 'f3' 'maxDB'
			One mark top... 'f3' no no no F3
			One mark bottom... 'f3' no no no 'f3Disp$'
			Black

			# Find nearest peak within search ratio
			searchRangeA1 = 'f1' * 0.2
			searchRangeA2 = 'f2' * 0.1
			searchRangeA3 = 'f3' * 0.1
			lowerboundA1 = 'f1' - 'searchRangeA1'
			upperboundA1 = 'f1' + 'searchRangeA1'
			lowerboundA2 = 'f2' - 'searchRangeA2'
			upperboundA2 = 'f2' + 'searchRangeA2'
			lowerboundA3 = 'f3' - 'searchRangeA3'
			upperboundA3 = 'f3' + 'searchRangeA3'
			# Then query LTAS object to get the formant amplitudes.
		   	# Also, record the frequency of the amplitude peak.  If this is far from the
			# recorded formant frequency (f1Hz etc), there may be a problem.  The most 
			# likely cause of such a discrepancy would be a non-stationary formant, 
			# which violates one of the assumptions underpinning this measure.
			select 'ltasID'
			a1dB = Get maximum... 'lowerboundA1' 'upperboundA1' None
			a1Hz = Get frequency of maximum... 'lowerboundA1' 'upperboundA1' None
			a2dB = Get maximum... 'lowerboundA2' 'upperboundA2' None
			a2Hz = Get frequency of maximum... 'lowerboundA2' 'upperboundA2' None
			a3dB = Get maximum... 'lowerboundA3' 'upperboundA3' None
			a3Hz = Get frequency of maximum... 'lowerboundA3' 'upperboundA3' None

			# Display
			Green
			circleRadius = maxFormantHz / 100
			Draw circle... 'a1Hz' 'a1dB' 'circleRadius'
			a1dBlabel = a1dB + 0.05*dBrange
			Text... 'a1Hz' Centre 'a1dBlabel' Half  A1
			Draw circle... 'a2Hz' 'a2dB' 'circleRadius'
			a2dBlabel = a2dB + 0.05*dBrange
			Text... 'a2Hz' Centre 'a2dBlabel' Half  A2
			Draw circle... 'a3Hz' 'a3dB' 'circleRadius'
			a3dBlabel = a3dB + 0.05*dBrange
			Text... 'a3Hz' Centre 'a3dBlabel' Half  A3
			Black

		  	if manualCheck

				   # Query for adjustments
				   beginPause ("Check results.")
						positive ("windowPosition", 'windowPosition')
						positive ("windowLength", 'windowLength')
						integer ("maxNumFormants", 'maxNumFormants')
						positive ("maxFormantHz", 'maxFormantHz')
						positive ("preEmphFrom", 'preEmphFrom')
						positive ("spectrogramWindow", 'spectrogramWindow')
						comment ("Hit <accept> to continue using shown analysis, or <adjust>")
						comment ("to remeasure current token using above parameters.")
				   		clicked = endPause("Accept","Adjust",1)
				   		if 'clicked' = 1
							# User has chosen "Accept"
							checked = 1
				   		else
						# User has chosen "Adjust"
							checked = 0
							select 'trackedFormantID'
							Remove
				   		endif
			else
				checked = 1
		  	endif
		  	# end of "if manualCheck"

			## 
			# Record parameters in text file of same name as token.
			#
			select 'soundID'
			tokenName$ = selected$("Sound")

			newParameters$ = "'windowPosition''tab$''windowLength''tab$''maxNumFormants''tab$''maxFormantHz''tab$''preEmphFrom''tab$''spectrogramWindow'"

			#filedelete 'inputdir$''tokenName$'.FmtParam.txt
			#fileappend 'inputdir$''tokenName$'.FmtParam.txt 'newParameters$'

			select 'spectrogramID'
			plus 'soundPartID'
			plus 'spectrumID'
			plus 'ltasID'
			Remove
		 endif

		until checked = 1

		if saveAsEPS
		 Select outer viewport... 0 6 0 7
		 Write to EPS file... 'inputdir$''name$'.Fmt.eps
		endif

		if outputToMatrix
		 select 'matrixID'
         if f1 = undefined
            f1 = 0
         endif
         if f2 = undefined
            f2 = 0
         endif
         if f3 = undefined
            f3 = 0
         endif
		 Set value... i 1 'f1'
		 Set value... i 2 'f2'
		 Set value... i 3 'f3'
		else
		 printline "'name$''tab$''f1''tab$''f2''tab$''f3'"
		endif

### End the 'for' loop over points
endfor


### The master script saves the Formant object for use with certain 
### spectral tilt measures.

select 'soundID'
plus 'textGridID'
