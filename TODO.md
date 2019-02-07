In order of urgency:

- Replace all Matrix-based storage with vector/array (since Praat finally has a real vector data type, hooray)
      
      - By doing this we can also address the issue of --undefined-- values of F1/F2 crashing the script. What should really happen is that if f0/F1/F2 is undefined, the calculation of spectral amplitudes or any other measure that relies on f0/F1/F2 should be set to --undefined-- as well; then the analyst can decide what to do about it later (throw them away, rejigger the TextGrid boundaries, something else...) but this may involve a rather fundamental re-write of how PraatSauce stores and outputs results
- Load Pitch objects (if they exist) to reduce amount of time spent on (possibly redundant) pitch calculations
- add option to use Mannell (1998) for formant bandwidth calculation
