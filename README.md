# PraatSauce

This set of Praat scripts is designed to facilitate the extraction of spectral measures such as H1-H2, H1-A3, cepstral peak prominence, etc. from acoustic data. 

## Background and acknowledgments

As the name suggests, these scripts owe a debt to the [VoiceSauce](http://www.phonetics.ucla.edu/voicesauce/) suite of Matlab scripts developed by Shue et al. (2011). PraatSauce is not as full-featured as VoiceSauce, but has what some might regard as the advantage of not requiring/being reliant on a Matlab license. Also, thanks to Praat's general Unicode compliance, it permits the use of non-ASCII elements in filenames and in TextGrids. 

Most importantly, developing PraatSauce has helped me to appreciate many of the challenges posed by the (semi)automatic analysis of spectral amplitude measurements.

While I referenced the VoiceSauce codebase when developing PraatSauce, be aware that this is not a direct "translation"; PraatSauce makes use of many Praat-internal functions such as `To Harmonicity (cc)`, `To PowerCepstrum`, etc. As such, identical results cannot be expected, even when using the Praat estimation methods for formants and f0 provided by VoiceSauce. Determining precisely where and why the approaches diverge is the subject of ongoing research; some [comparison](./COMPARISONS.md) data are provided for those interested.

The general architecture of PraatSauce is based on a suite of Praat scripts developed by Tim Mills [(2010)](#mills2010spectral), and as a result PraatSauce is released under the same license as these tools. 

Please note that these acknowledgements do not imply any culpability on the part of the named developers. I alone remain responsible for any errors in the present code (but see [Reuse and license](#license), below).

I hope PraatSauce will soon be made obsolete by [opensauce-python](https://github.com/voicesauce/opensauce-python), a Python port of VoiceSauce. However, PraatSauce may still be useful for users who for whatever reason prefer to work in Praat, and/or who find Praat's visualization tools to be useful.

<a name="license"></a>
## Reuse and license


All scripts are released under the GNU General Public License, version 2.0 or later (the same license as the Praat software).  A copy of the latest version of the licence, version 3.0, is provided with the scripts as the file "gpl-3.0.txt".  It can also be downloaded from the following URL:

[http://www.gnu.org/copyleft/gpl.html](http://www.gnu.org/copyleft/gpl.html)

These scripts are provided as-is, without any warranty regarding their suitability or safety for use in any particular application.  Users are advised to observe all prudent safety protocols when using these scripts. Neither the author nor the authors of any of the software mentioned above take any responsibility for anything you do or publish based on the results obtained with this software.


## Why PraatSauce?

1. **Reusability**. I learned a lot by implementing the various predecessor scripts to PraatSauce I have created over the years.  There are a lot of decisions one needs to make when implementing tools for extraction of voice quality measurements, and it's useful to see how they interact. Putting everything together in a relatively user-friendly fashion seemed like a good way to document my current state of understanding.

2. **Reproducibility**. If we are going to say in print that it is H1\*-A1\* that distinguishes voice qualities in Modern Standard Shoggoth, and not some other measure, it would be nice to know that this assertion is robust to at least some degree of variability in the precise measurement technique. It is not currently clear to me that this is the case.

3. **Convenience**. Matlab is powerful and has excellent signal processing capabilities, but it is not so nice when your site license expires while you are in the field and you can't renew it remotely because it requries an on-campus log-on with an admin key that you don't have. Lots of people use Praat for lots of things so it is often handy to have a Praat-based tool for various tasks. In addition, Matlab doesn't seem to allow Unicode/non-Western characters in TextGrids, anywhere, even if you're not looking at that tier. I have thousands of TextGrids with non-Western characters in them (orthography, usually) and while it's possible to create VoiceSauce-able verisons of those TextGrids, it's a pain in the neck.
	
4. **Curiosity.** VoiceSauce includes Praat-based methods for estimating most parameters [[1]](#fn1). How big of a difference can/does implementation make? In theory we should get identical results from identical parameter settings. In practice there seem to be some differences. Not necessarily a problem, but perhaps useful to know.

	<small><a name="fn1">[1]</a> Although perhaps crucially, the method of determining harmonic amplitudes is always handled in the same way, which is never Praat-based, regardless of where the formant and bandwidth estimates come from.</small>

<!--5. **Open source**. Feature request? Something you want to implement/try yourself? Submit a pull request.-->


### What PraatSauce doesn't do

- Many of the fancier things implemented in VoiceSauce: epochs, Sun's SHR methods, etc. 
- Alternative methods of estimating F0 (STRAIGHT, Snack)
- Correct H2K or H5K for formant frequencies and bandwidths (because this is based on cepstral peak rather than F0 window). Note that VoiceSauce doesn't correct for H5K either, though it does correct H2K.
- Integrate EGG measurements


## Requirements

These scripts have been tested with Praat 6.0.36 on macOS Sierra 10.12.6 and Windows 7 Enterprise (SP1). YMMV.

Please note that **version 6.0.30 or higher** of Praat is required to make use of the new *numeric vector* object type in the scripts.

### Included files

Presently, PraatSauce consists of 8 files, found in the `src` directory:

- `praatSauce.praat`, the master script
- `shellSauce.praat`, a version of the master script with all parameters in a single form, for easy shell scripting
- `pitchTracking.praat`, which measures f0
- `formantMeasures.praat`, which measures F1-F3
- `spectralMeasurements.praat`, which measures harmonic amplitudes, formant bandwidths, harmonics-to-noise ratios, and cepstral peak amplitudes, returning corrections where appropriate
- `getbw_HawksMiller.praat`, which computes formant bandwidths according to the method of [Hawks and Miller (1995)](#hawks1995formant)
- `correct_iseli_z.praat`, which implements the spectral magnitude corrections of [Iseli and Alwan (2007)](#iseli2007age)
- `splitstring.praat`, a helper script which parses a string based on a user-defined separator


## Basic workflow

Open and run the `praatSauce.praat` script. There are several pages of parameters that need to be specified.

### Page 1: directory and measures

#### Input directory and results file

- `inputdir` is the directory containing your (segmented) **audio** files.

- `textgriddir` is the directory containing your **TextGrid** files. These are expected to have the same name as your audio files, but with the extention `.TextGrid`. Note that `textgriddir` can be the same as `inputdir`.

- `outputdir` is the directory where the output files will be stored. 

- `outputfile` is the name of the output file. The default is `spectral_measures.txt`.

#### session

If you want to start from a specific token (e.g. because the script was interrupted due to some kind of error and you don't want to start all over from the beginning), you can change the value of `startToken`. You will need to watch the info window to see the token number, or you can figure it out from the Strings list. If you do this, make sure to rename the existing version of `spectral_measures.txt` as it will be silently overwritten.

#### channel

If you only want to produce analysis measures for a single channel of a stereo file, enter the channel number here. This is useful if e.g. you have (mono) audio on channel 1 and EGG or another co-registered signal on channel 2. Otherwise, enter `0` to process the stereo `Sound` file.

#### interval tier

The `tier` variable is the tier of interest. Note that **every labelled interval on this tier will be analyzed**. This means if you have intervals for both e.g. stop closure and rime, you will get spectral measurements for both intervals. 

#### skip these labels

If there are interval labels you don't want PraatSauce to extract measurements for, enter them here as a well-formed regex. `^$` is the empty string (an interval without a label). `^\s$` is a whitespace character (an interval that you meant to leave blank, but has an accidental, invisible space in it). Separate multiple labels with a pipe `|`. The default regex skips empty intervals, blank intervals, and intervals containing `r`. See the Praat manual for further details.

#### point tier

If you have events recorded on a point tier, enter the tier number here. Otherwise leave as 0 (the default).

#### point tier labels

If `point_tier` != 0, enter the labels of the events marked on the point tier, separated by spaces. One header column will be added for each label. All other labels will be ignored. 

<a name="sep"></a>
#### separator

Enter a `separator` used in the filename (e.g. `_` or `-` or `.` or similar).

<a name="check"></a>
#### manualCheckFrequency

Although PraatSauce is designed to process data in a 'batch' fashion, formant tracking errors can be common. At least some manual checking of the output is recommended.

Note that presently if the user elects to manually check tokens, the correction will be limited to a single window at midpoint of each labelled interval. Obviously, this is not necessarily going to representative of the harmonic structure at other points in the interval.

#### measure

This variable allows the user to choose to measure either at *n* equidistant points, or every *n* milliseconds. In either case, the *n* in question is determined by the value of following variable.

#### points

If `points` is set to e.g. 5 and `measure` is `every n milliseconds`, a measurement will be taken every 5 msec. If `measure` is `n equidistant points` than this will take 5 evenly spaced measurements, the precise times of which will depend on the length of the interval of interest.

### Page 2: Select measures

The second window allows you to choose the spectral measures you are interested in, along with some analysis window properties. Unlike VoiceSauce, PraatSauce currently just returns a fixed set of measurements. There is also an option to resample to 16 KHz, although this is not really necessary as (a) VoiceSauce does it mostly for STRAIGHT and (b) resampling will occur when formants are estimated in any event.

If you select `spectralMeasures` but leave `formantMeasures` and/or `pitchTracking` unchecked, they will be checked for you anyways, since the spectral balance measures require both Pitch and Formant objects. But it is possible to just get f0 and/or F1-F3 and bandwidths, if you would like (but see Page 4, below).

If you have existing Praat `.Formant` objects in your `inputdir`, you may find that PraatSauce is faster if you uncheck the `formantMeasures` box; you will then load the existing `.Formant` objects and use these for bandwidth estimation, etc. You can select this option on the following page.

The `windowLength` and `maxAnalysisHz` options are used by the formant and spectral amplitude measurement procedures. For formant estimation, `windowLength` specifies the effective duration of the analysis window in seconds, while `maxAnalysisHz` gives the ceiling of the formant search range; see Praat documentation for details. `windowLength` is also used in the estimation of spectral amplitudes to create a 'slice' around a timepoint used to create a long-term average spectrum object. `windowPosition` is not currently used.

### Page 3: Pitch tracking options

Here you can:

- use existing Pitch objects if you have them, or explictly ignore and overwrite them even if you do have them (by leaving the box unchecked)
- change the lower and upper limits for estimated f0. You probably want to change these depending on the speaker's pitch range.

### Page 4: Formant measurement options

Here you have the options to:

- play the sound each time a file is processed
- change the time step for the spacing of analysis frames in the formant measurement
- set the maximum number of formants estimated and the point of pre-emphasis
- smooth formant tracks using Praat's `Smooth...` function, and change the reference formant values for a neutral vowel
- save the visual output as an EPS file
- use existing Formant objects if you have them, or explictly ignore and overwrite them even if you do have them (by leaving the box unchecked)
- decide whether to use Praat's estimates of formant bandwidths, or the Hawks and Miller formula which is the VoiceSauce default. Note that if you haven't selected Pitch estimation two pages previously, the script will exit with an error (because Hawks and Miller's formula relies on a pitch esimate).


### Page 5: Got all that?

This pause allows you to save the previous parameter selections as a text file for reference. After this, PraatSauce will begin processing all files in `inputdir`, pausing only if there is an error or if you have set [`manualCheckFrequency`](#check) to be something greater than 0.

<!--

## Measuring harmonics

- For H1, H2, H4, search in range ±10% of the harmonic (so F0, 2F0, 4F0)
- For A1, search in range ±20% of the F1 estimate
- For A2 and A3, search in range ±10% of F2/F3 estimate

## Manual checking of formants

In the `demo` file `naa_f_sen_3_pnn` for example, compare the difference in the A1 estimate if you change `maxFormantHz` from its default value to 3000.
-->

<a name="output"></a>
## Output format

PraatSauce assumes that your filenames contain useful information such as subject codes, repetition number, and so forth, separated by a [`separator`](#sep). The output file will include a column for each separator. For example, if your input file has the name `12-cab-w_Audio.wav` and the separator is `-`, the first few of the the output file will look like this:

```
Filename,var1,var2,var3,Label,seg_Start,seg_End,t,t_ms,f0...
12-cab-w_Audio,12,cab,w_Audio,a,0.648166,0.902471,1,0.648166,136.096...
12-cab-w_Audio,12,cab,w_Audio,a,0.648166,0.902471,2,0.649166,136.192...
```

`t` is the rank order of the measurement taken in a `Filename` for a given `Label`. `t_ms` is the absolute time in the file when the measurement was taken.

The abbreviations in the header otherwise follow the VoiceSauce conventions. `B1, B2, B3` are formant bandwidths; `H1u, H1H2u...` are uncorrected harmonic amplitudes or differences; and `H1c, H1A1c...` are corrected harmonic amplitudes or differences. For more details on the implementation of the corrections, see the [CORRECTIONS.md](./CORRECTIONS.md) file.

## A note on smoothing
VoiceSauce has a smoothing parameter and smooths harmonic amplitudes (but not formants or F0) using a (lagged) moving-average window filter [[2]](#fn2). Currently, there is no smoothing option implemented in PraatSauce, as most data analysis software such as R offers a greater range of easily accessible smoothing options that are fiddly to implement in Praat. 

In terms of comparing between VoiceSauce and PraatSauce output: one thing to note is that VoiceSauce appears to first smooths all amplitude measures (H1u, H1c...), uses these smoothed vectors to compute the difference measures (H1H2u, H1H2c...) and then smooths the resulting differences again. 


<small><a name="fn2">[2]</a> Actually, F0 is smoothed, but using a different procedure.</small>

## Calling from the command line

If you would like to script **praatSauce** from the shell, use ```shellSauce.praat```, which collapses all argument windows into a single window. (If all arguments are included in a single form, which is what is needed for Praat to process all command line arguments when called from the shell due to the [single form requirement](http://praat-users.yahoogroups.co.narkive.com/UF4twWwZ/size-of-the-form-windows-in-scipts), the resulting form window will be too big for most screens (since resizing the window is [not possible](http://praat-users.yahoogroups.co.narkive.com/UF4twWwZ/size-of-the-form-windows-in-scipts)).

For details of how to use Praat from the command line on your operating system, see the Praat manual (currently section 6.9 in Praat version 6.0.37).

## References

<!--Kirby, James and Đinh Lư Giang. 2017. On the r>h shift in Kiên Giang Khmer. *Journal of the Southeast Asian Linguistics Society* 10(2), 66-85.-->

<a name="hawks1995formant"></a>
Hawks, J.W., and J. D. Miller. (1995). A formant bandwidth 
estimation procedure for vowel synthesis. *Journal of the Acoustical Society of America* **97**(2), 1343-1344.

<a name="iseli2007age"></a>
Iseli, M., Y.-L Shue, and A. Alwan. (2007). Age, sex, and vowel dependencies of acoustic measures related to the voice source. *Journal of the Acoustical Society of America* **121**(4), 2283-2295.
  
<a name="mills2010spectral"></a>
Mills, T. (2010). SpectralTilt-0.0.5 [computer program]. See [https://sites.google.com/a/ualberta.ca/timothy-mills/downloads](https://sites.google.com/a/ualberta.ca/timothy-mills/downloads).

Shue, Y.-L., P. Keating, C. Vicenik, and K. Yu. (2011). VoiceSauce: a program for voice analysis. *Proceedings of the 17th International Congress of Phonetic Sciences*, 1846–1849.



*Last modified: Berlin, 18 August 2020*

