## getbw_HawksMiller.praat
## version 0.2.2
## James Kirby <j.kirby@ed.ac.uk>

## These scripts are released under the GNU General Public License version 3.0 
## The included file "gpl-3.0.txt" or the URL "http://www.gnu.org/licenses/gpl.html" 
## contains the full text of the license.

#####################################################################
## Hawks and Miller formula for bandwidth estimation
##
## Reference: Hawks JW, Miller JD (1995) "A formant bandwidth 
## estimation procedure for vowel synthesis," JASA 97(2):1343-1344.
#####################################################################

procedure getbw_HawksMiller(f0, fmt)

    ## bandwidth scaling factor as a function of f0, 
    ## to accommodate the wider bandwidths of female speech
    s = 1 + 0.25*(f0-132)/88

    if fmt < 500
        ## coefficients for when f0<500 Hz 
        k = 165.327516
        coef# = { -6.73636734e-1, 1.80874446e-3, -4.52201682e-6, 7.49514000e-9, -4.70219241e-12 }
    else
        ## coefficients for when f0>=500 Hz
        k = 15.8146139
        coef# = { 8.10159009e-2, -9.79728215e-5, 5.28725064e-8, -1.07099364e-11, 7.91528509e-16 }
    endif

    fbw = s * (k + (coef# [1] * fmt) + (coef# [2] * fmt^2) + (coef# [3] * fmt^3) + (coef# [4] * fmt^4) + (coef# [5] * fmt^5) )
    .result = fbw

endproc
