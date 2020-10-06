In semi-order of urgency:

- Replace all Matrix-based storage with vector/array (since Praat finally has a real vector data type, hooray)

  By doing this we can also address the issue of --undefined-- values of F1/F2 crashing the script. What should really happen is that if f0/F1/F2 is undefined, the calculation of spectral amplitudes or any other measure that relies on f0/F1/F2 should be set to --undefined-- as well; then the analyst can decide what to do about it later (throw them away, rejigger the TextGrid boundaries, something else...) but this may involve a rather fundamental re-write of how PraatSauce stores and outputs results
      
- Add option to use Mannell (1998) for formant bandwidth calculation

- Split out spectral measures so that they don't all have to be computed. Actually the whole thing could be more modular; right now different aspects of different functions are spread out all over the place

- add option to allow user to select autocorrelation or cross-correlation pitch estimation methods, along with associated parameters

- completely revist structure: currently we are re/saving objects over and over again (Formant objects at least) each time we find an interval to process. The object reference scheme should be completely revisited. **April 2019**: this has been temporarily worked around; we now only create/load the objects once, but this is problematic given that the logic of the scripts was designed to process each file once and once only, and we are looping through based on interval, potentially modifying the Formant object once per *interval*. This isn't scalable but then the manual-check logic also needs revisiting **August 2020**: Formant object generation is now done only once per audio file, but that means tracking is only done once per file too (there's no obvious way to extract a portion of a Formant object?), so in some/long files there will be some frames where F3 can't be estimated and therefore you'll get no F3 measurements for *any intervals in the entire file*. If Formant objects are built (and tracked) once per interval, then this usually won't happen, but there is a non-trivial performance hit in doing this.

- Re-do the comparisons with the latest version

- Unify the shell and GUI versions somehow - maybe through forcing everyone to specify their parameter settings in a settings file, rather than having pages and pages of forms?

- 27.3.20: there appear to be issues with loading Formant/Pitch objects; need to investigate

- SSFF output/emuR integration? https://ips-lmu.github.io/The-EMU-SDMS-Manual/app-chap-wrassp.html#sec:app-chap-wrassp-praatsSigProc **August 2020**: simpler to read in and convert to ASSP file internally in emuR.

- Figure out what the Praat "Get CPPS" function does, compare it with manual smoothing of CPP and with VS

- Hook to integrate **praatdet** or EGGWorks EGG measures?
