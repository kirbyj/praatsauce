###############
# PraatSauce
###############

# Copyright (c) 2018-2019 James Kirby

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


# Portions of PraatSauce are based on

# spectralTiltMaster.praat
# version 0.0.5
# copyright 2009-2010 Timothy Mills
# <mills.timothy@gmail.com>

# VoiceSauce 
# version 1.31
# http://www.seas.ucla.edu/spapl/voicesauce/

###############################
## includes
###############################
include splitstring.praat

###
### The opening form gets information on the location of the files to process,
### where the output should go, the structure of the TextGrids, which labels 
### to process, and the temporal resolution of the measurements.
###

clearinfo

form Directory and measures
    comment Input directory and results file
    sentence inputdir /Users/jkirby/Projects/praatsauce/comp/madurese/
    sentence textgriddir /Users/jkirby/Projects/praatsauce/comp/madurese/
    sentence outputdir /Users/jkirby/Projects/praatsauce/comp/
    sentence outputfile spectral_measures.txt
    comment If measuring in sessions, use this parameter to pick up where you left off:
    natural startToken 1
    comment If you only want to analyze one channel, enter it here (or 0 for stereo):
    integer channel 1
    comment Which is your interval tier?
    natural interval_tier 1
    comment Enter interval labels you don't want to process as a well-formed regex:
    sentence skip_these_labels ^$|^\s+$|r
    comment Which is your point tier? (Enter 0 if you aren't using a point tier)
    integer point_tier 0
    comment If using a point tier: enter the labels of interest, separated by spaces:
    sentence point_tier_labels ov cv rv
    comment What character separates linguistic variables in token names? (e.g. "-" or "_")
    sentence separator _
    #comment Some measures (formant measure, pitch tracking, h1-a3, a1-a2) 
    #comment allow you to manually check the output.
    comment What portion of tokens do you wish to (randomly) manually inspect? 
    comment (0=none, 0.5 half, 1=all, etc.)
    real manualCheckFrequency 0
    comment At what points in the segment should we record measurements?
    optionmenu Measure: 2
       option n equidistant points
       option every n milliseconds
    comment If n equidistant points, how many? (e.g. 1, 3, 11...)
    comment If every n milliseconds, at what msec interval? (e.g. 5, 10...)
    natural Points 5
endform

###
### The second form lets the user select which measures to run, and 
### obtains some general analysis parameters that are used by the  
### subscripts.
###
beginPause: "Select measurements"
    comment: "Resample to 16 KHZ?"
    boolean: "resample_to_16k", 1    
    comment: "Spectral measure(s) to take"
    boolean: "pitchTracking", 1
    boolean: "formantMeasures", 1
    boolean: "spectralMeasures", 1
    comment: "Note that taking spectral measures requires both formant and pitch analysis;"
    comment: "checking this box implies checking the two previous boxes."
	comment: "You can elect to load existing Pitch and Formant objects in a moment."
    comment: "Analysis window properties"
    positive: "windowLength", 0.025
    positive: "windowPosition", 0.5
    positive: "maxFormantHz", 5000
    comment: "For scripts that display spectrograms, what window size?"
    positive: "spectrogramWindow", 0.005
    #comment: "Smoothing window size (set to 0 for no smoothing)"
    #integer: "smoothWindowSize", 20
    #comment: "Select a smoothing algorithm"
    #optionMenu: "smoother", 1
    #option: "Simple moving average"
    #option: "Weighted symmetric moving average"
endPause: "Continue", 1

printline -------
printline Common settings
printline -------
printline resample_to_16k:  <'resample_to_16k'>
printline windowLength:  <'windowLength'>
printline windowPosition:  <'windowPosition'>
printline maxFormantHz:  <'maxFormantHz'>
#printline smoothWindowSize:  <'smoothWindowSize'>
#printline smoother:  <'smoother'>

###
### The following form obtains parameters specific to the spectral
### measurement subscript. This form will be shown only if the 
### user has selected spectral measures in the previous window.
### Not currently implemented. However, if spectralMeasures is
### selected, automatically select pitch and formant tracking, 
### since these objects are both needed to calculate the spectral
### balance measures.
###

if spectralMeasures
#    beginPause ("VoiceSauce-like Spectral magnitude measurement options")
#        comment ("Do you want to save the display summary of each token's")
#        comment ("analysis as an EPS file?")
#        boolean ("spectralMagnitudeSaveAsEPS", 0)
#        comment ("Maximum frequency for LTAS display")
#        positive ("maxDisplayHz", 5000)
#    endPause ("Continue", 1)
#    
#    #printline -------
#    #printline Spectral Magnitude
#    #printline -------
#    #printline smoothingHz: <'smoothingHz'>
#    #printline
	pitchTracking = 1
	formantMeasures = 1
endif

###
### The following form obtains parameters specific to the pitch
### measurement subscript. This form will be shown only if the 
### user has selected pitch tracking in the previous window.
###

if pitchTracking
    beginPause ("Pitch tracking options")
    comment: "Do you want to load existing Pitch objects, or generate new ones?"
    boolean: "useExistingPitch", 0 
    comment ("Lower and upper limits to estimated frequency?")
    positive ("f0min", 50)
    positive ("f0max", 300)

    endPause ("Continue", 1)
    printline -------
    printline Pitch tracking
    printline -------
    printline useExistingPitch: <'useExistingPitch'>
    printline f0min:  <'f0min'>
    printline f0max:  <'f0max'>
    printline
endif

###
### The following form obtains parameters specific to the formant
### measurement subscript. This form will be shown only if the 
### user has selected formant tracking in the previous window.
###

if formantMeasures
    beginPause: "Formant measurement options"
        comment: "Would you like to listen to each sound if checking tracks?"
        boolean: "listenToSound", 0
        comment: "Time step determines how close the analysis frames are for"
        comment: "formant measurement.  Set at 0 for default (1/4 of window)."
        real: "timeStep", 0
        comment: "The maximum number of formants and the point of pre-emphasis"
        comment: "are key parameters in the Burg formant estimation algorithm."
        integer: "maxNumFormants", 5
        positive: "preEmphFrom", 50
        comment: "Would you like to smooth the formant tracks?"
        boolean: "formantTracking", 1
        comment: "If yes: the tracking used to smooth formant contours after initial"
        comment: "estimates requires reference formant values (neutral vowel)."
        positive: "F1ref", 500
        positive: "F2ref", 1500
        positive: "F3ref", 2500
        comment: "Do you want to save the visual output as an EPS file?"
        boolean: "saveAsEPS", 0
        comment: "Do you want to load existing Formant objects, or generate new ones?"
        boolean: "useExistingFormants", 0
        comment: "Do you want to use Praat's estimates of formant bandwidths, or"
        comment: "bandwidths estimated by the Hawks and Miller formula?"
        comment: "Note: this requires that you selected to run a pitch analysis previously"
        boolean: "useBandwidthFormula", 0
    endPause: "Continue", 1

    printline -------
    printline Formant measures
    printline -------
    printline listenToSound:  <'listenToSound'>
    printline timeStep:  <'timeStep'>
    printline maxNumFormants:  <'maxNumFormants'>
    printline preEmphFrom:  <'preEmphFrom'>
    printline formantTracking:  <'formantTracking'>
    printline F1ref:  <'F1ref'>
    printline F2ref:  <'F2ref'>
    printline F3ref:  <'F3ref'>
    printline saveAsEPS:  <'saveAsEPS'>
    printline useExistingFormants: <'useExistingFormants'>
    printline useBandwidthFormula: <'useBandwidthFormula'>
    printline
endif

###
## A quick pause so that the user can check all of the parameters 
## reported in the info window, and save them to a file if needed.
###

beginPause ("Got all that?")
    comment ("If you want to save this list of parameters to a file,")
    comment ("select the Info window and choose 'Save As...' from ")
    comment ("the File menu.")
endPause ("Continue", 1)

###
## Add redundant trailing directory slashes since everyone 
## forgets, and it doesn't matter if they're doubled
###

inputdir$ = inputdir$ + "/" 
outputdir$ = outputdir$ + "/"
textgriddir$ = textgriddir$ + "/"

###
## If outputfile already exists, delete it (so that it can be 
## replaced with a new version).  Also, clear info screen.
###

outputfile$ = "'outputdir$''outputfile$'"
filedelete 'outputfile$'
clearinfo

###
## Get directory listing, sort, count
###

Create Strings as file list... fileList 'textgriddir$'*.TextGrid
stringsListID = selected("Strings", 1)
Sort
numTokens = Get number of strings

###
## Build up header variable based on user's choices in the form.

header$ = "Filename"

## Add label for each linguistic variable parsed from token names.
## In order to be as flexible as possible, this script simply labels
## these variables 'var1', 'var2', etc.  After measurement, you can 
## change these labels in the text file or in your statistical 
## software to have more descriptive names.  Alternatively, you can 
## modify this section of the script.

select stringsListID
sampleFileName$ = Get string... 1
@splitstring: sampleFileName$, separator$
if splitstring.strLen > 1
    for i from 1 to splitstring.strLen
        header$ = "'header$',var'i'"
    endfor
endif

## Add interval label column
header$ = "'header$',Label"

## Add header columns for interval start and end times
header$ = "'header$',seg_Start,seg_End"

## Add header columns for point tier points
## One column is added per label
if point_tier <> 0
    @splitstring: point_tier_labels$, " "
    number_of_points = splitstring.strLen
    for i from 1 to number_of_points
        thisCol$ = splitstring.array$[i]
        header$ = "'header$','thisCol$'"
    endfor
endif

## Add header columns for point number and the absolute timepoint value
header$ = "'header$',t,t_ms"

## Add header columns for selected measures
if pitchTracking
	header$ = "'header$',f0"
endif
if formantMeasures
	header$ = "'header$',F1,F2,F3,B1,B2,B3"
endif
if spectralMeasures
	header$ = "'header$',H1u,H2u,H4u,H2Ku,H5Ku,A1u,A2u,A3u,H1H2u,H2H4u,H1A1u,H1A2u,H1A3u,H2KH5Ku,H1c,H2c,H4c,A1c,A2c,A3c,H1H2c,H2H4c,H1A1c,H1A2c,H1A3c,CPP,HNR05,HNR15,HNR25,HNR35"
endif
header$ = "'header$''newline$'"

## Put header in outputfile and on Info screen.
fileappend 'outputfile$' 'header$'
echo 'header$'
## (end building of header)

###
# The following 'for' loop does the bulk of the processing.  Each cycle of
# the loop processes a single token.
#
for currentToken from startToken to numTokens

    ## Retrieve filename of current token
    select stringsListID
    currentTextGridFile$ = Get string... 'currentToken'
    basename$ = left$("'currentTextGridFile$'", index("'currentTextGridFile$'", ".") - 1)
    
    ## Load Sound
    Read from file... 'inputdir$''basename$'.wav
    ## Note that Sound is not resampled b/c later we use To Formant (burg)... 
    ## which resamples to twice the frequency of maxFormant (so 10k-11k usually)
    soundID = selected("Sound")
   
    ## If selected, downsample
    ## VoiceSauce only really does this b/c it is faster for STRAIGHT
    ## Given how the Burg algorithm works, input will be resampled 
    ## at the formant estimation stage no matter what.
    if resample_to_16k == 1
        Resample... 16000 50
        resampledID = selected("Sound")
        select 'soundID'
        Remove
        select 'resampledID'
        Rename... 'basename$'
        soundID = selected("Sound")
    endif  

    ## If selected, extract the channel of interest
	## if e.g. you have audio on channel 1 and EGG on channel 2
    if channel
        Extract one channel... channel
        monoID = selected("Sound")
        select 'soundID'
        Remove
        select 'monoID'
        Rename... 'basename$'
        soundID = selected("Sound")
    endif  

    # If there is an existing formant-tracking parameter file 
    # ("*.FmtParam.txt"), load it and use its parameters rather
    # than the ones entered in the opening forms.
    formantParamFile$ = "'inputdir$''basename$'.FmtParam.txt"
    
    if fileReadable (formantParamFile$)
        #pause Found <'formantParamFile$'>, started loop
        formantParameters$ < 'formantParamFile$'
        # This should contain a tab-delimited list in the following order:
        # windowPosition, windowLength, maxNumFormants, maxFormantHz, preEmphFrom, spectrogramWindow
        #echo 'formantParameters$'
        
        parameterIndex = index(formantParameters$, ,) - 1
        parameter$ = left$(formantParameters$, parameterIndex)
        windowPosition = 'parameter$'
        #printline windowPosition    = <'windowPosition'>
        formantParameters$ = mid$(formantParameters$, parameterIndex+2, 10000)
        parameterIndex = index(formantParameters$, ,) - 1
        parameter$ = left$(formantParameters$, parameterIndex)
        windowLength = 'parameter$'
        #printline windowLength      = <'windowLength'>
        formantParameters$ = mid$(formantParameters$, parameterIndex+2, 10000)
        parameterIndex = index(formantParameters$, ,) - 1
        parameter$ = left$(formantParameters$, parameterIndex)
        maxNumFormants = 'parameter$'
        #printline maxNumFormants    = <'maxNumFormants'>
        formantParameters$ = mid$(formantParameters$, parameterIndex+2, 10000)
        parameterIndex = index(formantParameters$, ,) - 1
        parameter$ = left$(formantParameters$, parameterIndex)
        maxFormantHz = 'parameter$'
        #printline maxFormantHz      = <'maxFormantHz'>
        formantParameters$ = mid$(formantParameters$, parameterIndex+2, 10000)
        parameterIndex = index(formantParameters$, ,) - 1
        parameter$ = left$(formantParameters$, parameterIndex)
        preEmphFrom = 'parameter$'
        #printline preEmphFrom       = <'preEmphFrom'>
        formantParameters$ = mid$(formantParameters$, parameterIndex+2, 10000)
        spectrogramWindow = 'formantParameters$'
        #printline spectrogramWindow = <'spectrogramWindow'>
     # else: Didn't find parameter file; use defaults.
    endif
 
    ## Load TextGrid
    Read from file... 'textgriddir$''currentTextGridFile$'
    textGridID = selected("TextGrid")

    ## Parse the token name into a series of linguistic variables.
    lingVars$ = ""
    @splitstring: basename$, separator$
    if splitstring.strLen > 1
        for i from 1 to splitstring.strLen
            lingVars$ = lingVars$ + splitstring.array$[i] + ","
        endfor
    endif

    ## Find the point tier point times, if using the point tier
    if point_tier <> 0
        ## ptimes$ will be string with number_of_points comma-separated values
        ptimes$ = ""
        ## slightly complicated because not all files have all points
        @splitstring: point_tier_labels$, " "
        ## points_on_tier is number of points on current TextGrid point tier
        points_on_tier = Get number of points... 'point_tier'
        ## for each item in @splitstring, write a time or NA
        for c from 1 to number_of_points
            ## set a flag so that we only write one per pass through the loop
            label_match = 0
            clabel$ = splitstring.array$[c]
            for p from 1 to points_on_tier
                plabel$ = Get label of point... 'point_tier' 'p'
                if plabel$ = clabel$
                    label_match = 1
                    ## record and truncate time of point
                    ptime = Get time of point... 'point_tier' 'p'
                    ptime = 'ptime:6'
                endif
            endfor
            ## now: we either found a match for this clabel$, or we didn't
            if label_match == 1
                ptimes$ = ptimes$ + string$(ptime) + ","
            else
                ptimes$ = ptimes$ + "NA," 
            endif 
        endfor  
    endif

    ###########################################
    ## Load/create Pitch, Formant, etc. objects
    ###########################################

	###
	## Not sure of the best way to do this. This way seems to be the cleanest,
	## because the objects are always only loaded or created once. 
	##
	## However, it is possible that they are created redundantly, because if
	## a given file doesn't have any intervals of interest, nothing will
	## be measured. 
	##
	## Mostly relevant for processing single files with many intervals of interest.
	###

	if pitchTracking
 		# if you want to load an existing object from disk...
    	if useExistingPitch
        	if fileReadable ("'inputdir$''basename$'.Pitch")
            	Read from file... 'inputdir$''basename$'.Pitch
            else
            	exit Cannot load Pitch object <'basename$'.Pitch>.
            endif
        # else create
        else
        	select 'soundID'
            #To Pitch... 0 'f0min' 'f0max'
            ## TODO April 2019: add this as a user option
            To Pitch (ac)... 0 'f0min' 15 0 0.03 0.45 0.01 0.35 0.14 'f0max'
			## This will result in two Pitch objects, but that's OK (I hope)...
            # Interpolate
			## This is maybe nice for some applications but hallucinates f0 in clearly voiceless regions!!
        endif
		## ... since only the second one will get referred to from now on
        pitchID = selected("Pitch")
	endif

	if formantMeasures
    	# if you want to load an existing object from disk...
        if useExistingFormants
        	# Load existing Formant object if available and selected
            if fileReadable ("'inputdir$''basename$'.Formant")
            	Read from file... 'inputdir$''basename$'.Formant
            else
            	exit Cannot load Formant object <'basename$'.Formant>.
            endif
		## else create 
        else
        	select 'soundID'
            To Formant (burg)... timeStep maxNumFormants maxFormantHz windowLength preEmphFrom
		endif

		formantID = selected("Formant")

		# moved from formantMeasures.praat 2020-08-18
		if formantTracking = 1
			# Tracking cleans up the tracks a little.  The original Formant object is then discarded.
			## mar 19: should really make the number of tracks a user parameter
			## also need to tune it possibly for each frame, because if the Formant
			## object has fewer values than the numTracks parameter, the command
			## will fail.
			minFormants = Get minimum number of formants
			if 'minFormants' = 2
				Track... 2 f1ref f2ref f3ref 3850 4950 1 1 1
			else
				Track... 3 f1ref f2ref f3ref 3850 4950 1 1 1
			endif
			trackedFormantID = selected("Formant")
			select 'formantID'
			Remove
			formantID = trackedFormantID
		endif

	endif

	if spectralMeasures
		# TODO: add option to read from disk as above
		### Create Harmonicity objects ###

		## here we use a 1 period window; the Praat 
		## default of 4.5 periods per window produces
		## much less accurate estimates
		select 'soundID'
		Filter (pass Hann band): 0, 500, 100
		Rename... 'basename$'_500
		To Harmonicity (cc): 0.01, f0min, 0.1, 1.0
		hnr05ID = selected ("Harmonicity")
		select 'soundID'
		Filter (pass Hann band): 0, 1500, 100
		Rename... 'basename$'_1500
		To Harmonicity (cc): 0.01, f0min, 0.1, 1.0
		hnr15ID = selected ("Harmonicity")
		select 'soundID'
		Filter (pass Hann band): 0, 2500, 100
		Rename... 'basename$'_2500
		To Harmonicity (cc): 0.01, f0min, 0.1, 1.0
		hnr25ID = selected ("Harmonicity")
		select 'soundID'
		Filter (pass Hann band): 0, 3500, 100
		Rename... 'basename$'_3500
		To Harmonicity (cc): 0.01, f0min, 0.1, 1.0
		hnr35ID = selected ("Harmonicity")
		### (end create Harmonicity objects ###
	endif

    ########################################
    ## Loop through non-empty intervals,
    ## ignoring those in skip_these_labels$
    ########################################

	select 'textGridID'
    num_intervals = Get number of intervals... 'interval_tier'
    for current_interval from 1 to num_intervals
        select 'textGridID'
        interval_label$ = Get label of interval... 'interval_tier' 'current_interval'

        ## only process non-empty intervals and those not in skip_these_labels$
        #if interval_label$ <> "" and index_regex(interval_label$, skip_these_labels$) = 0
        ## only process intervals not in skip_these_labels$ - if you want to skip empty
        ## intervals, include the relevant regex...
        if index_regex(interval_label$, skip_these_labels$) = 0
            echo <'current_interval' of 'num_intervals'> 'interval_label$'

            ######################################
            ## Sub-loop: process a single interval          
            #######################################

            ## Add interval label column to header
            header$ = "'header$','interval_label$'"
          
            ## Determine start and endpoints of current interval for reference
            interval_start = Get start time of interval... 'interval_tier' 'current_interval'
            interval_end = Get end time of interval... 'interval_tier' 'current_interval'
			# truncate to msec precision
			interval_start = (floor(1000 * interval_start) / 1000)
			interval_end = floor(1000 * interval_end) / 1000

            ## Determine how many timepoints we are measuring at
            if measure = 1
               timepoints = points
            elsif measure = 2
               timepoints = round(((interval_end - interval_start))*1000)/points
            endif
            
            ## Report current token number, name, and lingVars$:
            echo <'currentToken' of 'numTokens'> 'basename$':  'lingVars$'
            
            ## Manually check this token at random? 
            randomNumber = randomUniform(0,1)
            if manualCheckFrequency > randomNumber
                manualCheck = 1
            else
               manualCheck = 0
            endif 
         
            ####################################################
            ## Since we know we are processing this interval 
            ## we can just pass the interval number to the 
            ## sub-scripts; they are already set up to handle 
            ####################################################
            
            ################################
            ### Pitch tracking
            ################################
            
            if pitchTracking
                select pitchID
                plus soundID
                plus textGridID
                execute pitchTracking.praat 'interval_tier' 'current_interval' 'windowPosition' 'windowLength' 'manualCheck' 1 'measure' 'timepoints' 'points'
               
                ### Save output Matrix
                select Matrix PitchAverages
                pitchResultsID = selected("Matrix")
            endif
            ### (end of pitch tracking)

            ###################### 
            ### Formant measures
            ###################### 

			if formantMeasures
                select 'soundID'
                plus 'textGridID'
                plus 'formantID'
                execute formantMeasures.praat 'interval_tier' 'current_interval' 'windowPosition' 'windowLength' 'manualCheck' 'saveAsEPS' 'useBandwidthFormula' 'useExistingFormants' 'inputdir$' 'basename$' 'listenToSound' 'timeStep' 'maxNumFormants' 'maxFormantHz' 'preEmphFrom' 'f1ref' 'f2ref' 'f3ref' 'spectrogramWindow' 'measure' 'timepoints' 'points' 'formantTracking'
				formantID = selected("Formant")
                select Matrix FormantAverages
                formantResultsID = selected("Matrix")
            endif
            ### (end of formant measures)

            ###################################################################################### 
            ### Spectral corrections (including H1*, H2*, H4, A1*, A2*, A3* from Iseli et al.)
            ###################################################################################### 
            
            if spectralMeasures
                select 'soundID'
                plus 'textGridID'
                plus 'formantID'
                plus 'pitchID'
				plus 'hnr05ID'
				plus 'hnr15ID'
				plus 'hnr25ID'
				plus 'hnr35ID'
                execute spectralMeasures.praat 'interval_tier' 'current_interval' 'windowPosition' 'windowLength' 'saveAsEPS' 'useBandwidthFormula' 'inputdir$' 'manualCheck' 'maxDisplayHz' 'measure' 'timepoints' 'points' 'f0min' 'f0max'
            
                ## Assign ID to output matrix
                select Matrix IseliMeasures
                iseliResultsID = selected("Matrix")
            
            endif 
            ### (end of spectralMagnitude measure)
            
            # Report results
            #echo <token 'currentToken' of 'numTokens'> 'results$'
            
            ## Here we:
            ##  1. look for results matrices
            ##  2. Write as many lines as the matrices have rows
            
            for t from 1 to timepoints
                # Begin building results string with file and linguistic info.
                if point_tier == 0
                    results$ = "'basename$','lingVars$''interval_label$','interval_start:3','interval_end:3','t'"
                else
                    results$ = "'basename$','lingVars$''interval_label$','interval_start:3','interval_end:3','ptimes$''t'"
                endif

                # have we already written the ms time or do we still need to write it?
                msflag = 0
         
                if pitchTracking
                    select 'pitchResultsID'
                    if msflag = 0
                        mspoint = Get value in cell... t 1
                        results$ = "'results$','mspoint:3'"
                        msflag = 1
                    endif
                    currentPitch = Get value in cell... t 2 
                    results$ = "'results$','currentPitch:3'"
                endif
            
                if formantMeasures 
                    select 'formantResultsID'
                    if msflag = 0
                        mspoint = Get value in cell... t 1
                        results$ = "'results$','mspoint:3'"
                        msflag = 1
                    endif
                    for formant from 2 to 4
                        currentFormant = Get value in cell... t 'formant'
                        results$ = "'results$','currentFormant:3'"
                    endfor
                    for bandwidth from 5 to 7
                        currentBandwidth = Get value in cell... t 'bandwidth'
                        results$ = "'results$','currentBandwidth:3'"
                    endfor
                endif           
            
                if spectralMeasures
                    select 'iseliResultsID'
                    if msflag = 0
                        mspoint = Get value in cell... t 1
                        results$ = "'results$','mspoint:3'"
                    endif
                    for measurement from 2 to 31
                        aMeasure = Get value in cell... t 'measurement'
                        results$ = "'results$','aMeasure:3'"
                    endfor  
                endif
            
                ## FINALLY write the thing out....for this timepoint
                fileappend 'outputfile$' 'results$''newline$'
            endfor  
            ## end of writing out timepoints

			## clean up
			select all
			minus Strings fileList
			minus Sound 'basename$'
			minus TextGrid 'basename$'
			nocheck minus 'pitchID'
			nocheck minus 'formantID'
			nocheck minus 'hnr05ID'
			nocheck minus 'hnr15ID'
			nocheck minus 'hnr25ID'
			nocheck minus 'hnr35ID'
			Remove
        endif
    endfor
    ## end of check to see if we have a non-empty interval
    ## end of sub-loop processing single INTERVAL

	## save the Pitch and Formant objects, if they exist
	if pitchTracking
    	select 'pitchID'
        Write to text file... 'inputdir$''basename$'.Pitch
	endif

	if formantMeasures
    	select 'formantID'
        Write to text file... 'inputdir$''basename$'.Formant
	endif

	## clean up
    select all
    minus Strings fileList
    Remove
    ## end of loop processing single FILE

endfor
## (End main analysis loop, which cycles through ALL TOKENS)

select 'stringsListID'
Remove

echo Analysis complete: <'numTokens'> tokens measured.
