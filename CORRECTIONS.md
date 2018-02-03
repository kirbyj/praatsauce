# Notes on spectral magnitude corrections

Like VoiceSauce, PraatSauce implements spectral magnitude corrections based on the method of Iseli et al. (2007). This method aims to correct the magnitudes of the spectral harmonics by compensating for the influence of formant frequencies on the spectral magnitude estimation. From their paper (pp. 2285-6):

> The purpose of this correction formula is to “undo” the effects of
the formants on the magnitudes of the source spectrum. This is done 
by subtracting the amount by which the formants boost the spectral 
magnitudes. For example, the corrected magnitude of the first spectral
harmonic located at frequency <img alt="$\omega_0 [H*(\omega_0)]$" src="https://rawgit.com/kirbyj/praatsauce (fetch/master/svgs/4cbf38470c8135e31ee2ad01bd6910a4.svg?invert_in_darkmode" align=middle width="87.41601pt" height="24.56553pt"/>, where 
<img alt="$\omega_0 = 2\pi F_0$" src="https://rawgit.com/kirbyj/praatsauce (fetch/master/svgs/f4f4700c2c88210910423e85c672b56b.svg?invert_in_darkmode" align=middle width="74.611185pt" height="22.38192pt"/> and <img alt="$F_0$" src="https://rawgit.com/kirbyj/praatsauce (fetch/master/svgs/db34e0e2fc81754d6678afef6e5d3856.svg?invert_in_darkmode" align=middle width="17.05935pt" height="22.38192pt"/> is the fundamental frequency, is given by

> <p align="center"><img alt="$$ \frac{(1 - 2r_i \cos(\omega_i) + r^2_i)^2&#10;H(\omega_0) - \sum_{i=1}^{N} 10\log_{10}}&#10;{(1 - 2r_i \cos(\omega_0 + \omega_i) + r^2_i) \times (1 - 2r_i \cos(\omega_0 - \omega_i) + r^2_i)}&#10;$$" src="https://rawgit.com/kirbyj/praatsauce (fetch/master/svgs/78381a6309aeeb99d5352e5552eacc9e.svg?invert_in_darkmode" align=middle width="397.05105pt" height="43.29897pt"/></p>
> with <img alt="$r_i = e^{-\pi B_i/F_s}$" src="https://rawgit.com/kirbyj/praatsauce (fetch/master/svgs/3f081957e8061703906b600d0db925fa.svg?invert_in_darkmode" align=middle width="96.26958pt" height="29.12679pt"/> and <img alt="$\omega_i = 2\pi F_i/F_s$" src="https://rawgit.com/kirbyj/praatsauce (fetch/master/svgs/b5cd975442105892e0f95a21d9b0c2eb.svg?invert_in_darkmode" align=middle width="96.55536pt" height="24.56553pt"/> where <img alt="$F_i$" src="https://rawgit.com/kirbyj/praatsauce (fetch/master/svgs/e17c35f619f835117e1ff8e25d5f8a9c.svg?invert_in_darkmode" align=middle width="15.16482pt" height="22.38192pt"/> and <img alt="$B_i$" src="https://rawgit.com/kirbyj/praatsauce (fetch/master/svgs/72f4aab7f49593ada1f6b406b90a8a94.svg?invert_in_darkmode" align=middle width="17.05572pt" height="22.38192pt"/> are the frequencies and bandwidths of the <img alt="$i$" src="https://rawgit.com/kirbyj/praatsauce (fetch/master/svgs/77a3b857d53fb44e33b53e4c8b68351a.svg?invert_in_darkmode" align=middle width="5.642109pt" height="21.60213pt"/>th formant, <img alt="$F_s$" src="https://rawgit.com/kirbyj/praatsauce (fetch/master/svgs/2dd5ff1eccc020fcdb711a69856a17c5.svg?invert_in_darkmode" align=middle width="16.71252pt" height="22.38192pt"/> is the sampling frequency, and <img alt="$N$" src="https://rawgit.com/kirbyj/praatsauce (fetch/master/svgs/f9c4988898e7f532b9f826a75014ed3c.svg?invert_in_darkmode" align=middle width="14.94405pt" height="22.38192pt"/> is the number of formants to be corrected for. 

> <img alt="$H(\omega_o)$" src="https://rawgit.com/kirbyj/praatsauce (fetch/master/svgs/628292aa0fe68ad71d73449277375680.svg?invert_in_darkmode" align=middle width="45.191025pt" height="24.56553pt"/> is the magnitude of the first harmonic from the speech
spectrum and <img alt="$H\text{*}(\omega_0)$" src="https://rawgit.com/kirbyj/praatsauce (fetch/master/svgs/c12810e7ad2db40a80b8cc578157d6d2.svg?invert_in_darkmode" align=middle width="53.47419pt" height="24.56553pt"/> represents the corrected magnitude and should coincide with the magnitude of the source spectrum at <img alt="$\omega_0$" src="https://rawgit.com/kirbyj/praatsauce (fetch/master/svgs/747fe3195e03356f846880df2514b93e.svg?invert_in_darkmode" align=middle width="16.72209pt" height="14.10255pt"/>. Note that all magnitudes are in decibels.

Note that the frequency of **all** harmonics needs to be corrected for the sampling frequency <img alt="$F_s$" src="https://rawgit.com/kirbyj/praatsauce (fetch/master/svgs/2dd5ff1eccc020fcdb711a69856a17c5.svg?invert_in_darkmode" align=middle width="16.71252pt" height="22.38192pt"/>; see Iseli and Alwan (2004), Sec. 3.

PraatSauce then applies the following formant corrections (Iseli et al. 2007, 2286-7):

> For <img alt="$H1\text{*}$" src="https://rawgit.com/kirbyj/praatsauce (fetch/master/svgs/488a91e55a5884aea41bdd4e9ba3990b.svg?invert_in_darkmode" align=middle width="31.32591pt" height="24.56553pt"/> and <img alt="$H2\text{*}$" src="https://rawgit.com/kirbyj/praatsauce (fetch/master/svgs/9568c45f72190dadf02a4988b6190dcd.svg?invert_in_darkmode" align=middle width="31.32591pt" height="24.56553pt"/>, the correction was for the ﬁrst and second formant (F1 and F2) inﬂuence with <img alt="$N=2$" src="https://rawgit.com/kirbyj/praatsauce (fetch/master/svgs/224e6819744eb493dfcc2829e9ab013e.svg?invert_in_darkmode" align=middle width="45.00903pt" height="22.38192pt"/> in Eq. (A5). For <img alt="$A3\text{*}$" src="https://rawgit.com/kirbyj/praatsauce (fetch/master/svgs/22816102ddd342e34c809830f409623a.svg?invert_in_darkmode" align=middle width="28.65984pt" height="24.56553pt"/>, the first three formants were corrected for (<img alt="$N=3$" src="https://rawgit.com/kirbyj/praatsauce (fetch/master/svgs/9aad22a1f10eb2f672ffc52c46eac498.svg?invert_in_darkmode" align=middle width="45.00903pt" height="22.38192pt"/>) and there was no normalization to a neutral vowel; recall that our correction accounts for formant frequencies and their bandwidths.

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