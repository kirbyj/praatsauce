## spectralMeasures.praat
## version 0.2.2
## James Kirby <j.kirby@ed.ac.uk>

## based in part on

## spectralTiltMaster.praat
## version 0.0.5
## copyright 2009-2010 Timothy Mills
## <mills.timothy@gmail.com>

## VoiceSauce 
## version 1.31
## http://www.seas.ucla.edu/spapl/voicesauce/

## These scripts are released under the GNU General Public License version 3.0 
## The included file "gpl-3.0.txt" or the URL "http://www.gnu.org/licenses/gpl.html" 
## contains the full text of the license.

## See README-CORRECTIONS.md for more information.

include getbw_HawksMiller.praat
include correct_iseli_z.praat

form Parameters for spectral tilt measure following Iseli et al.
 comment TextGrid interval to measure.  If numeric, check the box.
 natural tier 1
 integer interval_number 0
 #text interval_label v
 comment Window parameters
 real windowPosition 0.5
 positive windowLength 0.025
 comment Output
 boolean saveAsEPS 0
 boolean useBandwidthFormula 1
 sentence inputdir /home/username/data/
 comment Manually check token?
 boolean manualCheck 1
 comment Analysis parameters
 positive maxDisplayHz 4000
 positive measure 2
 positive timepoints 3
 positive timestep 1
 positive f0min 40
 positive f0max 500
endform

###
### First, check that proper objects are present and selected.
###
numSelectedSound = numberOfSelected("Sound")
numSelectedTextGrid = numberOfSelected("TextGrid")
numSelectedFormant = numberOfSelected("Formant")
numSelectedPitch = numberOfSelected("Pitch")
if (numSelectedSound<>1 or numSelectedTextGrid<>1 or numSelectedFormant<>1 or numSelectedPitch<>1)
 exit Select one Sound, one TextGrid, one Pitch, and one Formant object.
endif
name$ = selected$("Sound")
soundID = selected("Sound")
textGridID = selected("TextGrid")
pitchID = selected("Pitch")
formantID = selected("Formant")
hnr05ID = selected("Harmonicity", 1)
hnr15ID = selected("Harmonicity", 2)
hnr25ID = selected("Harmonicity", 3)
hnr35ID = selected("Harmonicity", 4)
### (end object check)

###
### Second, establish time domain.
###
select textGridID
if 'interval_number' > 0
 intervalOfInterest = interval_number
#else
# numIntervals = Get number of intervals... 'tier'
# for currentInterval from 1 to 'numIntervals'
#  currentIntervalLabel$ = Get label of interval... 'tier' 'currentInterval'
#  if currentIntervalLabel$==interval_label$
#   intervalOfInterest = currentInterval
#  endif
# endfor
endif

startTime = Get starting point... 'tier' 'intervalOfInterest'
endTime = Get end point... 'tier' 'intervalOfInterest'
### (end time domain check)

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
### column 1 holds timepoints of the measurement 
### columns 2-9 hold individual uncorrected measures
### columns 10-15 hold uncorrected differences
### columns 16-21 hold individual corrected measures
### columns 22-26 hold corrected differences
### column 27 holds CPP
### columns 28-31 hold HNRs
### 

Create simple Matrix... IseliMeasures timepoints 31 0
matrixID = selected("Matrix")
### (end build matrix object) ###

###
### Create Harmonicity objects ###
###

## here we use a 1 period window; the Praat 
## default of 4.5 periods per window produces
## much less accurate estimates

#select 'soundID'
#Filter (pass Hann band): 0, 500, 100
#Rename... 'name$'_500
#To Harmonicity (cc): 0.01, f0min, 0.1, 1.0
#hnr05ID = selected ("Harmonicity")
#select 'soundID'
#Filter (pass Hann band): 0, 1500, 100
#Rename... 'name$'_1500
#To Harmonicity (cc): 0.01, f0min, 0.1, 1.0
#hnr15ID = selected ("Harmonicity")
#select 'soundID'
#Filter (pass Hann band): 0, 2500, 100
#Rename... 'name$'_2500
#To Harmonicity (cc): 0.01, f0min, 0.1, 1.0
#hnr25ID = selected ("Harmonicity")
#select 'soundID'
#Filter (pass Hann band): 0, 3500, 100
#Rename... 'name$'_3500
#To Harmonicity (cc): 0.01, f0min, 0.1, 1.0
#hnr35ID = selected ("Harmonicity")
### (end create Harmonicity objects ###

###
### Finally, get sample rate ###
###
select 'soundID'
sample_rate = Get sampling frequency
### (end of get sample rate)

for i from 1 to timepoints

	## Generate a slice around the measurement point ##
	sliceStart = mid'i' - ('windowLength' / 2)
	sliceEnd = mid'i' + ('windowLength' / 2)

	############################
	# Create slice-based objects 
	############################
	select 'soundID'
	Extract part... 'sliceStart' 'sliceEnd' Hanning 1 yes
	windowedSoundID = selected("Sound")
	To Spectrum... yes
	spectrumID = selected("Spectrum")
	To Ltas (1-to-1)
	ltasID = selected("Ltas")
	select 'spectrumID'
	To PowerCepstrum
	cepstrumID = selected("PowerCepstrum")

	################
	# Get f0
	################
	select 'pitchID'
    # pitch estimate at timepoint i
    n_f0md = Get value at time... mid'i' Hertz Linear

	################
	# Get F1, F2, F3
	################
    select 'formantID'
	f1hzpt = Get value at time... 1 mid'i' Hertz Linear
	f2hzpt = Get value at time... 2 mid'i' Hertz Linear

    if useBandwidthFormula = 1
        @getbw_HawksMiller(n_f0md, f1hzpt)
        f1bw = getbw_HawksMiller.result 
        @getbw_HawksMiller(n_f0md, f2hzpt)
        f2bw = getbw_HawksMiller.result
    else
	    f1bw = Get bandwidth at time... 1 mid'i' Hertz Linear
	    f2bw = Get bandwidth at time... 2 mid'i' Hertz Linear
    endif

	minFormants = Get minimum number of formants
	if minFormants > 2
		f3hzpt = Get value at time... 3 mid'i' Hertz Linear
        if useBandwidthFormula = 1
            @getbw_HawksMiller(n_f0md, f3hzpt)
            f3bw = getbw_HawksMiller.result 
		else
            f3bw = Get bandwidth at time... 3 mid'i' Hertz Linear
        endif
	else
		f3hzpt = 0
		f3bw = 0
	endif

	###########################
    # Cepstral peak prominence
	###########################
    select 'cepstrumID'
    cpp = Get peak prominence... 'f0min' 'f0max' "Parabolic" 0.001 0 "Straight" Robust
    #Smooth... 0.0005 1
    #smoothed_cepstrumID = selected("PowerCepstrum")
    #cpps = Get peak prominence... 'f0min' 'f0max' "Parabolic" 0.001 0 "Straight" Robust

	########################## 
    # Harmonic-to-noise ratios
	########################## 
    select 'hnr05ID'
    hnr05db = Get value at time: mid'i', "Cubic"
    if (hnr05db = undefined)
        hnr05db = 0
    endif
    select 'hnr15ID'
    hnr15db = Get value at time: mid'i', "Cubic"
    if (hnr15db = undefined)
        hnr15db = 0
    endif
    select 'hnr25ID'
    hnr25db = Get value at time: mid'i', "Cubic"
    if (hnr25db = undefined)
        hnr25db = 0
    endif
    select 'hnr35ID'
    hnr35db = Get value at time: mid'i', "Cubic"
    if (hnr35db = undefined)
        hnr35db = 0
    endif
                    
	#############
    # H2k and H5k 
	#############
    ## Search window--harmonic location should be based on F0, 
    ## but would throw out a lot.  Base it on cepstral peak instead
    select 'cepstrumID'
    peak_quef = Get quefrency of peak: 50, 550, "Parabolic"
    peak_freq = 1/peak_quef
    lowerb2k = 2000 - peak_freq
    upperb2k = 2000 + peak_freq
    lowerb5k = 5000 - peak_freq
    upperb5k = 5000 + peak_freq
    select 'ltasID'
    twokdb = Get maximum: lowerb2k, upperb2k, "Cubic"
    fivekdb = Get maximum: lowerb5k, upperb5k, "Cubic"

	####################
	# Measure H1, H2, H4
	####################
   
    # if f0 and/or formants are undefined no point in doing any of this
    if (n_f0md <> undefined and f1hzpt <> undefined and f2hzpt <> undefined and f3hzpt <> undefined)
	    p10_nf0md = 'n_f0md' / 10

        # ltasID is a slice based on i and the window size
        select 'ltasID'
        lowerbh1 = n_f0md - p10_nf0md
        upperbh1 = n_f0md + p10_nf0md
        lowerbh2 = (n_f0md * 2) - p10_nf0md
        upperbh2 = (n_f0md * 2) + p10_nf0md
        lowerbh4 = (n_f0md * 4) - p10_nf0md
        upperbh4 = (n_f0md * 4) + p10_nf0md

        # note that while we get the frequencies of the harmonics with 
        # the greatest amplitude, we don't explicitly use them for
        # anything at the moment. could in theory compare them to
        # the values of n_f0md, 2n_f0md, etc.
        
        h1db = Get maximum... 'lowerbh1' 'upperbh1' None
        h1hz = Get frequency of maximum... 'lowerbh1' 'upperbh1' None
        h2db = Get maximum... 'lowerbh2' 'upperbh2' None
        h2hz = Get frequency of maximum... 'lowerbh2' 'upperbh2' None
        h4db = Get maximum... 'lowerbh4' 'upperbh4' None
        h4hz = Get frequency of maximum... 'lowerbh4' 'upperbh4' None

        #######################
        # Measure A1, A2, A3 
        #######################
        p10_f1hzpt = 'f1hzpt' * 0.2
        p10_f2hzpt = 'f2hzpt' * 0.1
        p10_f3hzpt = 'f3hzpt' * 0.1
        lowerba1 = 'f1hzpt' - 'p10_f1hzpt'
        upperba1 = 'f1hzpt' + 'p10_f1hzpt'
        lowerba2 = 'f2hzpt' - 'p10_f2hzpt'
        upperba2 = 'f2hzpt' + 'p10_f2hzpt'
        lowerba3 = 'f3hzpt' - 'p10_f3hzpt'
        upperba3 = 'f3hzpt' + 'p10_f3hzpt'
        a1db = Get maximum... 'lowerba1' 'upperba1' None
        a1hz = Get frequency of maximum... 'lowerba1' 'upperba1' None
        a2db = Get maximum... 'lowerba2' 'upperba2' None
        a2hz = Get frequency of maximum... 'lowerba2' 'upperba2' None
        a3db = Get maximum... 'lowerba3' 'upperba3' None
        a3hz = Get frequency of maximum... 'lowerba3' 'upperba3' None
                                
        ##########################################
        # Calculate adjustments relative to F1-F3
        ##########################################
        
        # Jan 2018: I don't know what the following means. As best I can tell, 
        # this is *not* the way VoiceSauce does it; that is, VoiceSauce uses
        # the F0, 2F0 etc. estimate at the timepoint in question, and not
        # the h1hz, a1hz etc.
        #
        # ### FOLLOWING COMMENT SEEMS WRONG ###
        # the way it was done here was to use the maximum frequences in the windows
        # the way VoiceSauce does it is based solely on the F0 estimate of the timepoint
        # (h1hz, a1hz, etc)
        # ### PRECEDING COMMENT SEEMS WRONG ###
        
        # correct H1 for effects of first 2 formants
        @correct_iseli_z (n_f0md, f1hzpt, f1bw, sample_rate)
        h1adj = h1db - correct_iseli_z.result
        @correct_iseli_z (n_f0md, f2hzpt, f2bw, sample_rate)
        h1adj = h1adj - correct_iseli_z.result
        # correct H2 for effects of first 2 formants
        @correct_iseli_z (2*n_f0md, f1hzpt, f1bw, sample_rate)
        h2adj = h2db - correct_iseli_z.result
        @correct_iseli_z (2*n_f0md, f2hzpt, f2bw, sample_rate)
        h2adj = h2adj - correct_iseli_z.result
        # correct H4 for effects of first 2 formants
        @correct_iseli_z (4*n_f0md, f1hzpt, f1bw, sample_rate)
        h4adj = h4db - correct_iseli_z.result
        @correct_iseli_z (4*n_f0md, f2hzpt, f2bw, sample_rate)
        h4adj = h4adj - correct_iseli_z.result
        # correct A1 for effects of first 2 formants
        @correct_iseli_z (f1hzpt, f1hzpt, f1bw, sample_rate)
        a1adj = a1db - correct_iseli_z.result
        @correct_iseli_z (f1hzpt, f2hzpt, f2bw, sample_rate)
        a1adj = a1adj - correct_iseli_z.result
        # correct A2 for effects of first 2 formants
        @correct_iseli_z (f2hzpt, f1hzpt, f1bw, sample_rate)
        a2adj = a2db - correct_iseli_z.result
        @correct_iseli_z (f2hzpt, f2hzpt, f2bw, sample_rate)
        a2adj = a2adj - correct_iseli_z.result
        # correct A3 for effects of first 3 formants
        @correct_iseli_z (f3hzpt, f1hzpt, f1bw, sample_rate)
        a3adj = a3db - correct_iseli_z.result
        @correct_iseli_z (f3hzpt, f2hzpt, f2bw, sample_rate)
        a3adj = a3adj - correct_iseli_z.result
        @correct_iseli_z (f3hzpt, f3hzpt, f3bw, sample_rate)
        a3adj = a3adj - correct_iseli_z.result
        # correct H2K for effects of first 3 formants
        @correct_iseli_z (f3hzpt, f1hzpt, f1bw, sample_rate)
        a3adj = a3db - correct_iseli_z.result
        @correct_iseli_z (f3hzpt, f2hzpt, f2bw, sample_rate)
        a3adj = a3adj - correct_iseli_z.result
        @correct_iseli_z (f3hzpt, f3hzpt, f3bw, sample_rate)
        a3adj = a3adj - correct_iseli_z.result

    else
    # can't store undefineds in Praat Matrices
        h1db = 0
        h2db = 0
        h4db = 0
        a1db = 0
        a2db = 0
        a3db = 0
        h1adj = 0
        h2adj = 0
        h4adj = 0
        a1adj = 0
        a2adj = 0
        a3adj = 0
    endif

    # if for some reason couldn't get a3adj...
    if (a3adj = undefined)
        a3adj = 0
    endif

	select 'matrixID'

    ## set first value to ms time
    Set value... i 1 mid'i'
   
 header$ = "'header$',H1u,H2u,H4u,H2Ku,H5Ku,A1u,A2u,A3u,H1H2u,H2H4u,H1A1u,H1A2u,H1A3u,H2KH5Ku,H1c,H2c,H4c,A1c,A2c,A3c,H1H2c,H2H4c,H1A1c,H1A2c,H1A3c,CPP,HNR05,HNR15,HNR25,HNR35"

 
    ## set subsequent value to measurements
	Set value... i 2 'h1db'
	Set value... i 3 'h2db'
	Set value... i 4 'h4db'
	Set value... i 5 'twokdb'
	Set value... i 6 'fivekdb'
	Set value... i 7 'a1db'
	Set value... i 8 'a2db'
	Set value... i 9 'a3db'
	Set value... i 10 'h1db'-'h2db'
	Set value... i 11 'h2db'-'h4db'
	Set value... i 12 'h1db'-'a1db'
	Set value... i 13 'h1db'-'a2db'
	Set value... i 14 'h1db'-'a3db'
	Set value... i 15 'twokdb'-'fivekdb'
	Set value... i 16 'h1adj'
	Set value... i 17 'h2adj'
	Set value... i 18 'h4adj'
	Set value... i 19 'a1adj'
	Set value... i 20 'a2adj'
	Set value... i 21 'a3adj'
	Set value... i 22 'h1adj'-'h2adj'
	Set value... i 23 'h2adj'-'h4adj'
	Set value... i 24 'h1adj'-'a1adj'
	Set value... i 25 'h1adj'-'a2adj'
	Set value... i 26 'h1adj'-'a3adj'
	Set value... i 27 'cpp'
	Set value... i 28 'hnr05db'
	Set value... i 29 'hnr15db'
	Set value... i 30 'hnr25db'
	Set value... i 31 'hnr35db'
	## end of outputToMatrix

	###
	# Clean up generated objects
	###
	select 'windowedSoundID'
	plus 'spectrumID'
	plus 'cepstrumID'
	plus 'ltasID'
	Remove

    select 'soundID'
	plus 'textGridID'
	plus 'formantID'
endfor
