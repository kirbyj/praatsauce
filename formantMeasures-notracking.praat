# formantMeasures.praat
# version 0.1
#
# from a script copyright 2009-2010 Timothy Mills <mills.timothy@gmail.com>
# heavily modified 2011-2017 James Kirby <j.kirby@ed.ac.uk>
#
# It is designed to work as part of the "praatsauce" script suite,
# which can be obtained from the author:
#
#   James Kirby <j.kirby@ed.ac.uk>
#
# This script is released under the GNU General Public License version 3.0 
# The included file "gpl-3.0.txt" or the URL "http://www.gnu.org/licenses/gpl.html" 
# contains the full text of the license.
#
# This script takes a Sound object and an associated TextGrid, and
# determines the first three formant frequencies.  It can work in a 
# fully-automated fashion, but users are advised that formant 
# tracking errors can be common.  Manual checking of the output is
# recommended.
#
# This script was heavily modified from the original in jan 2017 because it 
# was returning very strange and inaccurate results. Part of the problem with 
# the existing script structure is that it plows through all subjects with the 
# same set of parameters - this will lead to erroneous measurements.
# Ideally, you will process each subject on their own, so that you can tailor
# parameters like maxFormantHz to gender/speaker.

form Parameters for formant measurement
 comment TextGrid interval
 natural tier 1
 integer interval_number 2
 sentence interval_label v
 comment Window parameters
 positive windowPosition 0.5
 positive windowLength 0.025
 comment Output
 boolean outputToMatrix 1
 boolean manualCheck 0
 boolean saveAsEPS 0 
 boolean useExistingFormants 0
 text inputdir /home/username/data/ 
 text basename myFile
 boolean listenToSound 1
 comment Leave timeStep at 0 for auto.
 real timeStep 0
 integer maxNumFormants 5
 positive maxFormantHz 5500
 positive preEmphFrom 50
# positive f1ref 500
# positive f2ref 1500
# positive f3ref 2500
 positive spectrogramWindow 0.005
 positive measure 2
 positive timepoints 3
 positive timestep 1
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

###
### Third, decide what times to measure at.
###
d = startTime
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
### column 1 holds time of measurement
### (relative to distance from startTime)
### columns 2-4 hold F1, F2, F3
###
if outputToMatrix
	Create simple Matrix... FormantAverages timepoints 4 0
	matrixID = selected("Matrix")
endif
### (end of build Matrix object)

###
### Interlude: play sound (if requested)
if manualCheck
	if listenToSound
		select soundID
		Play
	endif
endif
### (end of manual check sound playback)

###
### Fifth, create Formant object (or use existing Formant object if present)
###
if useExistingFormants = 1
# Load existing Formant object if available
    if fileReadable ("'inputdir$''basename$'.Formant")
        Read from file... 'inputdir$''basename$'.Formant
        formantID = selected("Formant")
    else
        ## If can't load, create
        select 'soundID'
        To Formant (burg)... timeStep maxNumFormants maxFormantHz windowLength preEmphFrom
        formantID = selected("Formant")
    endif
## else create 
else  
    select 'soundID'
    To Formant (burg)... timeStep maxNumFormants maxFormantHz windowLength preEmphFrom
    formantID = selected("Formant")
endif
### (end of load/create Formant object)

###
# Display results, possibly
###
checked = 1
repeat

    # for display purposes, just use midpoint
	midTime = (startTime + endTime) / 2
	windowStart = midTime - (windowLength / 2)
	windowEnd = midTime + (windowLength / 2)
	
	select 'formantID'
	f1 = Get value at time... 1 midTime Hertz Linear
	f2 = Get value at time... 2 midTime Hertz Linear
	f3 = Get value at time... 3 midTime Hertz Linear

    if (manualCheck or saveAsEPS)

        # Generate output in picture window
        select 'soundID'
        To Spectrogram... 'spectrogramWindow' 'maxFormantHz' 0.0005 20 Gaussian
        spectrogramID = selected("Spectrogram")
        Erase all

        Select outer viewport... 0 6 0 3
        Paint... 'startTime' 'endTime' 0 'maxFormantHz' 100 yes 50 6 0 yes
        Marks left... 6 yes yes no
        Marks right... 6 yes yes no
        Yellow
        Line width... 3
        select 'formantID'
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
        mid = midTime
        midShort = 'mid:3'
        One mark bottom... 'mid' no no no 'midShort'
        Draw line... midTime 0 midTime 'maxFormantHz'

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
                    select 'formantID'
                    Remove
                    select 'soundID'
                    To Formant (burg)... timeStep maxNumFormants maxFormantHz windowLength preEmphFrom
                    formantID = selected("Formant")
                 endif
        else
            checked = 1
        endif
        # end of "if manualCheck"

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


## OK, now we've got a Formant object we can live with
## Better save it to file
select 'formantID'
Write to text file... 'inputdir$''basename$'.Formant

###
### Finally: store measurements for each timepoint
for i from 1 to timepoints

	if outputToMatrix
        select 'formantID'
        f1 = Get value at time... 1 mid'i' Hertz Linear
        f2 = Get value at time... 2 mid'i' Hertz Linear
        f3 = Get value at time... 3 mid'i' Hertz Linear

        ## can't have undefineds in your Praat Matrices, sorry              
        if f1 = undefined
           f1 = 0
        endif
        if f2 = undefined
           f2 = 0
        endif
        if f3 = undefined
           f3 = 0
        endif

	    select 'matrixID'

        # find time of measurement, relative to startTime
        #absPoint = mid'i' - startTime
        #absPoint = round( (mid'i' - startTime)*1000 ) / 1000
        
        # set first col to ms time
        #Set value... i 1 absPoint
        # here we record absolute time in file like VoiceSauce does
        Set value... i 1 mid'i'

        # finally record formants
	    Set value... i 2 'f1'
	    Set value... i 3 'f2'
	    Set value... i 4 'f3'
	else
	    printline "'name$''tab$''f1''tab$''f2''tab$''f3'"
	endif
### End the 'for' loop over timepoints
endfor

select 'soundID'
plus 'textGridID'
