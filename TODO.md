In order of urgency:

- Replace all Matrix-based storage with vector/array (since Praat finally has a real vector data type, hooray)

  By doing this we can also address the issue of --undefined-- values of F1/F2 crashing the script. What should really happen is that if f0/F1/F2 is undefined, the calculation of spectral amplitudes or any other measure that relies on f0/F1/F2 should be set to --undefined-- as well; then the analyst can decide what to do about it later (throw them away, rejigger the TextGrid boundaries, something else...) but this may involve a rather fundamental re-write of how PraatSauce stores and outputs results
      
- Add option to use Mannell (1998) for formant bandwidth calculation

- add option to allow user to select autocorrelation or cross-correlation pitch estimation methods, along with associated parameters

- completely revist structure: currently we are re/saving objects over and over again (Formant objects at least) each time we find an interval to process. The object reference scheme should be completely revisited. **April 2019**: this has been temporarily worked around; we now only create/load the objects once, but this is problematic given that the logic of the scripts was designed to process each file once and once only, and we are looping through based on interval, potentially modifying the Formant object once per *interval*. This isn't scalable but then the manual-check logic also needs revisiting

- Re-do the comparisons with the latest version

- Unify the shell and GUI versions somehow - maybe through forcing everyone to specify their parameter settings in a settings file, rather than having pages and pages of forms?
