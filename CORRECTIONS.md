# Notes on spectral magnitude corrections

Like VoiceSauce, PraatSauce implements spectral magnitude corrections based on the method of Iseli et al. (2007). This method aims to correct the magnitudes of the spectral harmonics by compensating for the influence of formant frequencies on the spectral magnitude estimation. From their paper (pp. 2285-6):

> The purpose of this correction formula is to “undo” the effects of
the formants on the magnitudes of the source spectrum. This is done 
by subtracting the amount by which the formants boost the spectral 
magnitudes. For example, the corrected magnitude of the first spectral
harmonic located at frequency $\omega_0 [H*(\omega_0)]$, where 
$\omega_0 = 2\pi F_0$ and $F_0$ is the fundamental frequency, is given by

> $$ \frac{(1 - 2r_i \cos(\omega_i) + r^2_i)^2
H(\omega_0) - \sum_{i=1}^{N} 10\log_{10}}
{(1 - 2r_i \cos(\omega_0 + \omega_i) + r^2_i) \times (1 - 2r_i \cos(\omega_0 - \omega_i) + r^2_i)}
$$
> with $r_i = e^{-\pi B_i/F_s}$ and $\omega_i = 2\pi F_i/F_s$ where $F_i$ and $B_i$ are the frequencies and bandwidths of the $i$th formant, $F_s$ is the sampling frequency, and $N$ is the number of formants to be corrected for. 

> $H(\omega_o)$ is the magnitude of the first harmonic from the speech
spectrum and $H\text{*}(\omega_0)$ represents the corrected magnitude and should coincide with the magnitude of the source spectrum at $\omega_0$. Note that all magnitudes are in decibels.

Note that the frequency of **all** harmonics needs to be corrected for the sampling frequency $F_s$; see Iseli and Alwan (2004), Sec. 3.

PraatSauce then applies the following formant corrections (Iseli et al. 2007, 2286-7):

> For $H1\text{*}$ and $H2\text{*}$, the correction was for the ﬁrst and second formant (F1 and F2) inﬂuence with $N=2$ in Eq. (A5). For $A3\text{*}$, the first three formants were corrected for ($N=3$) and there was no normalization to a neutral vowel; recall that our correction accounts for formant frequencies and their bandwidths.

The authors note that the measures are dependent on vowel quality (F1) and vowel type, but this is not expressly corrected for here.

### Bandwidths

Formant bandwidths in PraatSauce can be calculated in one of two ways:

- using Praat's `Get bandwidth at time...` function using linear interpolation; or,
- using the formula proposed by Hawks and Miller (1995), which is the default VoiceSauce option.

The results of both methods may differ from other implementations based more strictly on Iseli and Alwan's method, which uses the simple correction of Mannell (1998) (also implemented in VoiceSauce).

Note that accurate estimation of bandwidths is in general difficult (Hanson and Chuang 1999).

## References

Hanson, H. M., and E. S. Chuang. (1999). Glottal characteristics of male speakers: Acoustic correlates and comparison with female data.   *Journal of the Acoustical Society of America* **106**, 1064–1077.

Hawks, J.W., and J. D. Miller. (1995). A formant bandwidth 
estimation procedure for vowel synthesis. *Journal of the Acoustical Society of America* **97**(2), 1343-1344.

Iseli, M. and A. Alwan. (2004). An improved correction formula for the estimation of harmonic magnitudes and its application to open quotient estimation. *Proc. ICASSP ’04* **1**, 669–672.

Iseli, M., Y.-L Shue, and A. Alwan. (2007). Age, sex, and vowel 
  dependencies of acoustic measures related to the voice source.
  *Journal of the Acoustical Society of America* **121**(4), 2283-2295.

Mannell, R. H. (1998). Formant diphone parameter extraction utilising a labelled single speaker database. *Proceedings of the ICSLP* (ASSTA, Sydney, Australia), Vol. 5, pp. 2003–2006.

--

*Last modified: 17 January 2018*