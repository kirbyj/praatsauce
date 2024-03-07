In semi-order of urgency:

- Introduce a check such that *if* a delimiter is specified, that every filename can be split into the same number of chunks based on this delimiter. Right now if this is not the case but the delimiter is specified/exists, Praat crashes horribly.

- Right now, a TextGrid is *required* and an interval needs to be specified for any of this to work. It would be nice to be able to just process a
  .wav file without having to have an accompanying TextGrid at all. (See also [issue 8](https://github.com/kirbyj/praatsauce/issues/8))
  
- Related to this, since the TextGrids are used to generate the file list, if you have a stray TextGrid that doesn't have an accompanying .wav file, I think the process fails silently in some horrible way.

- Add an option to record labels of *all* intervals tiers at each measurement point (see [issue 8](https://github.com/kirbyj/praatsauce/issues/8))

- Replace all Matrix-based storage with vector/array (since Praat finally has a real vector data type, hooray)

  By doing this we can also address the issue of --undefined-- values of F1/F2 crashing the script. What should really happen is that if f0/F1/F2 is undefined, the calculation of spectral amplitudes or any other measure that relies on f0/F1/F2 should be set to --undefined-- as well; then the analyst can decide what to do about it later (throw them away, rejigger the TextGrid boundaries, something else...) but this may involve a rather fundamental re-write of how PraatSauce stores and outputs results
      
- Add option to use Mannell (1998) for formant bandwidth calculation

- Split out spectral measures so that they don't all have to be computed. Actually the whole thing could be more modular; right now different aspects of different functions are spread out all over the place

- add option to allow user to select autocorrelation or cross-correlation pitch estimation methods, along with associated parameters

- calculate harmonics pitch-synchronously, like VoiceSauce does

- completely revisit structure: currently we are re/saving objects over and over again (Formant objects at least) each time we find an interval to process. The object reference scheme should be completely revisited. **April 2019**: this has been temporarily worked around; we now only create/load the objects once, but this is problematic given that the logic of the scripts was designed to process each file once and once only, and we are looping through based on interval, potentially modifying the Formant object once per *interval*. This isn't scalable but then the manual-check logic also needs revisiting **August 2020**: Formant object generation is now done only once per audio file, but that means tracking is only done once per file too (there's no obvious way to extract a portion of a Formant object?), so in some/long files there will be some frames where F3 can't be estimated and therefore you'll get no F3 measurements for *any intervals in the entire file*. If Formant objects are built (and tracked) once per interval, then this usually won't happen, but there is a non-trivial performance hit in doing this.

- Re-do the comparisons with the latest version

- Unify the shell and GUI versions somehow - maybe through forcing everyone to specify their parameter settings in a settings file, rather than having pages and pages of forms?

- 27.3.20: there appear to be issues with loading Formant/Pitch objects; need to investigate **June 2023**: this seems to work now? but Bert is saying it doesn't load objects from disk even when asked to. I tested and it seems to be OK; but objects are *always* written back to disk at the end of each run, even if loaded from disk/unchanged.

- SSFF output/emuR integration? https://ips-lmu.github.io/The-EMU-SDMS-Manual/app-chap-wrassp.html#sec:app-chap-wrassp-praatsSigProc **August 2020**: simpler to read in and convert to ASSP file internally in emuR.

- Figure out what the Praat "Get CPPS" function does, compare it with manual smoothing of CPP and with VS

- Intensity/RMS energy (see [issue #9](https://github.com/kirbyj/praatsauce/issues/9))
  
- Hook to integrate **praatdet** or EGGWorks EGG measures?
