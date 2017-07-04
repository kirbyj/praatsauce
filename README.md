# praatSauce

This is a set of scripts designed to facilitate the extraction of spectral and durational measurements from acoustic data.

Not all of the scripts may be necessary for your use case.


## Acknowledgments
Mills
Lennes
Crosswhite
Boersma
Shue

## Reuse and license

## July 2017

Maybe not under explicit development? getting close to VS but not there just yet.

## Old/unknown below here


## Contents

There are eight 'core' scripts:

- ```1_mark_pauses.praat```
- ```2_label_from_text_file.praat```                     
- ```3_save_labeled_intervals_to_wav_sound_files.praat```
- ```4_text_grid_reviewer.praat```                   
- ```5_snap_to_zerocross.praat```                  
- ```7_praatSauce.praat```
- ```8_extract_duration_info.praat```

There are also some other scripts that are not normally accessed directly:

- ```formantMeasures-notracking.praat```
- ```pitchTracking.praat```
- ```voicesauceMeasures.praat```

## Basic workflow

The scripts assume that you have a set of individual audio files and 
### If you have multiple utterances in one long soundfile

1. Call ```1_mark_pauses.praat```. This is a script by Mietta Lennes and is available [here](http://www.helsinki.fi/~lennes/praat-scripts/public/mark_pauses.praat). It will create a TextGrid 

2. 

3. ```3_save_labeled_intervals_to_wav_sound_files.praat``` is another heavily modified Miette Lennes script.  

### If you already have one target phrase/item per file, or once you have completed steps 1-3

Note that the assumption is that the filenames will have a particular type of general structure, with relevant linguistic/demographic information separated by a separator field like ```_``` or ```-```. So for example the file

    talam-iso-3-mis.wav

contains four fields, corresponding to item, context (*iso*lation), repetition (3) and speaker code (mis). There 


4. Run ```4_text_grid_reviewer.praat```. This venerable little script was written by [Katherine Crosswhite](crosswhi@ling.rochester.edu). It will allow you to edit the TextGrids together with the corresponding audio files.

### A special note regarding EGG files

These scripts were designed to be used either on their own, or together with an accompanying set of EGG scripts that make similar assumptions about filename structure, etc. 
