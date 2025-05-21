# PraatSauce

This is a suite of [Praat](https://fon.hum.uva.nl/praat/) scripts that 
facilitate the analysis of voice quality. They are used to extract measures such 
as f0, formants, spectral measures such as H1-H2, H1-A3 etc, cepstral peak 
prominence, harmonics-to-noise-ratios in select frequency bands, and amplitude 
from acoustic data. 

## Citation information

If you use PraatSauce in your research, you can cite the current version as 
follows:

Kirby, James & Rasmus Puggaard-Rode (2025) *PraatSauce. Praat-based tools for
spectral processing.* Version 1.0.0. GitHub: [kirbyj/praatsauce](https://github.com/kirbyj/praatsauce).

## Getting started

For an overview of the workflow, parameters, and methods used by PraatSauce,
see [this introductory text](https://kirbyj.github.io/praatsauce/).

## Background

These scripts are inspired by the [VoiceSauce](https://www.phonetics.ucla.edu/voicesauce/) 
suite for Matlab developed by Shue et al. (2011). PraatSauce extracts many of the 
same measures as VoiceSauce (although not all!), most of them by calling Praat's 
internal signal processing routines (Boersma & Weenink 2023). While VoiceSauce 
is in many ways more sophisticated than PraatSauce, PraatSauce arguably has 
advantages in terms of speed, stability, active development, and open-source 
software which allows anyone to edit the code base as they please. (While the 
VoiceSauce code is also open source, it relies on Matlab libraries that are not, 
and you cannot run a user-edited version of VoiceSauce without a Matlab license).

This version of PraatSauce is a fully rewritten version of the previous code base 
by James Kirby which is available as the 
[`praatsauce 0.2.7` release](https://github.com/kirbyj/praatsauce/tree/0.2.7). 
Results should be very similar, but the workflow is quite different. 
An overview of changes can be found 
[here](https://github.com/kirbyj/praatsauce/blob/master/NEWS.md).

## Requirements

These scripts have been tested on Praat version 6.4.01. The scripts make 
extensive use of vectorized operations that are only available in newer versions 
of Praat, as well as the state-of-the-art filtered auto-correlation pitch 
tracking routine which is a relatively recent addition to Praat. So if your 
version of Praat is several years old, you should update it before running 
PraatSauce.

## Basic workflow

All the PraatSauce files are in the `src` directory. There are bunch of 
parameters to toggle, and this is simply done using the `params.csv` file, also 
in the `src` directory, which is a comma-separated file that can be opened and 
edited in a simple text editor or spreadsheet editor (Excel or similar). You can 
run the PraatSauce scripts by running the code in the `praatsauce.praat` file, 
which will open a window that prompts the location of your parameters file.

If your workflow typically involves a combination of Praat and R, consider 
exploring the developmental R package 
[`sauceshelf`](https://github.com/rpuggaardrode/sauceshelf) which wraps the
PraatSauce scripts from R and provides various methods for combining them with
other sources of signal processing. 


## References

Boersma, Paul & David Weenink (2023) *Praat. Doing phonetics by computer*, version 6.4.01.

Shue, Yen-Liang, Patricia A. Keating, Chad Vicenik & Kristine Yu (2011) VoiceSauce. 
A program for voice analysis. *Proceedings of the 17th International Congress of Phonetic Sciences*, 
1846--1849. Hong Kong. 
