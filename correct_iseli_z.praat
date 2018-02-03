## correct_iseli_z.praat
## version 0.2.2
## James Kirby <j.kirby@ed.ac.uk>

## Adapted from VoiceSauce func_correct_iseli_z.m

## This script is designed to work as part of the "praatsauce" script suite,
## which can be obtained from:
##
##      https://github.com/kirbyj/praatsauce
##
## This script is released under the GNU General Public License version 3.0 
## The included file "gpl-3.0.txt" or the URL "http://www.gnu.org/licenses/gpl.html" 
## contains the full text of the license.


################################################################
##
## For a given set of inputs, the values returned by this 
## function and VoiceSauce should be identical
##
## f: the frequency in question: f0 for H1, 2f0 for H2, etc.
## fx: the x-th formant frequency
## bx: the x-th formant bandwidth
## fs: the sampling frequency
##
################################################################

procedure correct_iseli_z (f, fx, bx, fs)
   r = exp(-pi*bx/fs)
   omega_x = 2*pi*fx/fs
   omega  = 2*pi*f/fs
   a = r ^ 2 + 1 - 2*r*cos(omega_x + omega)
   b = r ^ 2 + 1 - 2*r*cos(omega_x - omega)
   corr = -10*(log10(a)+log10(b));  # not normalized: H(z=0)~=0
   numerator = r ^ 2 + 1 - 2 * r * cos(omega_x);   # sqrt of numerator, omega=0
   corr = -10*(log10(a)+log10(b)) + 20*log10(numerator);  # normalized: H(z=0)=1
   .result = corr
endproc

###############################################################
##
## For comparison: Patrick Collier's adaptation of the VoiceSauce 
## procedure, taken from praat_voice_measures.praat
## https://github.com/pcallier/livingroom/blob/master/scripts/utilities/praat_voice_measures.praat
##
###############################################################

## It looks to me like there is a problem here. Compared to the above, 
## for a given magnitude, this doesn't hold the frequency constant;
## the fx variable is changed on each pass through the loop.
## Comparing with VoiceSauce, the same frequency (F0, 2*F0, 
## F1, F2, F3...) is passed to each run of the script - it is only
## the formant frequency and bandwidth that change.

## He seems to have anticipated this by passing hz in but...
## 'hz' is never referenced, and f is set to dB(c) for some reason

procedure correct_iseli (dB, hz, f1hz, f1bw, f2hz, f2bw, f3hz, f3bw, fs)
    dBc = dB
    for corr_i from 1 to 3
        fx = f'corr_i'hz
        bx = f'corr_i'bw
        f = dBc
        if fx <> 0
            r = exp(-pi*bx/fs)
            omega_x = 2*pi*fx/fs
            omega  = 2*pi*f/fs
            a = r ^ 2 + 1 - 2*r*cos(omega_x + omega)
            b = r ^ 2 + 1 - 2*r*cos(omega_x - omega)
            corr = -10*(log10(a)+log10(b));   # not normalized: H(z=0)~=0

            numerator = r ^ 2 + 1 - 2 * r * cos(omega_x)
            corr = -10*(log10(a)+log10(b)) + 20*log10(numerator)
            dBc = dBc - corr
        endif
    endfor
    .result = dBc
endproc

