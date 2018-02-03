# Comparisons between PraatSauce and VoiceSauce

The [comp](./comp) directory contains R Markdown and PDF documents, and associated measurement files, for three small data sets, illustrating how PraatSauce and VoiceSauce perform on each. The PDF rendering is not ideal, but Github currently won't display R Markdown documents (or rendered HTML files) of this size. Thus, these are best viewed locally in R (where you can also generate new plots of your own).

The sample size is extremely small and so clearly no firm conclusions cannot be drawn from this comparison However, some observations:

- Praat F0 estimation looks to be generally pretty OK

- VoiceSauce does a much nicer job with cepstral peaks and harmonic to noise ratios. It might be worth implementing these in PraatSauce rather than just using the built-in Praat functions

- VoiceSauce's smoothing (by dint of Matlab's filter() behaviour) can do strange things to the left edges. But estimates of anything at the edges are probably unreliable anyways.

- In some cases (esp. with low vowels), items that 'should be' breathy are sometimes estimated by VoiceSauce as having (much) smaller (negative) tilts vis-a-vis PraatSauce

- Formula vs. Praat/Snack bandwidth estimation often doesn't seem to have a huge impact on corrections. This may be because the bandwidth only enters the I&A correction formula in the term $e^{-\pi B_i/F_s}$, so even changes of an order of magnitude do not radically affect the output.

- Not only do different spectral measures appear to be better at distinguishing VQ-based contrasts in different languages, but different measures also do better for different vowels/tokens/speakers

- VoiceSauce corrections are always going to be more smoothed than smoothed PraatSauce estimates, since VoiceSauce reports smoothed corrections that have themselves been calculated using smoothed amplitude estimates. This could be replicated in PraatSauce by computing the amplitude differences in R rather than in Praat
 
- The effects of binning and window size on estimates has not been investigated.

## Recommendations

- Changing the formant and pitch ceilings based on speaker age/gender is important for either method

- Formula bandwidths are probably in general OK, but result in less aggressive corrections in general

- Estimates based on the first and last 10-15% of vocalic intervals are probably not to be trusted
