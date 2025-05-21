## Differences between 1.0.0 and the previous version of PraatSauce

* All parameters are passed in a csv file so we're getting rid of the 
complicated situation with a bunch of parameters windows which sometimes won't
load on monitors that are too small. This also makes PS easier to call from 
the command line.

* Much less of the work is done in the core `praatsauce` script, most of the 
labor is done in done in procedures in other scripts.

* It's no longer possible to split the file name string into variables

* The user has more freedom over which measures to return. These are all 
options: pitch, formants, bandwidths, harmonic amplitudes, uncorrected harmonic 
amplitudes, slope measures, uncorrected slope measures, CPP, HNR, intensity, and
SoE.

* There is now an option to calculate intensity and strength of excitation.

* Using TextGrids is no longer a requirement but still an option. By default the 
entire sound file is analyzed.

* If using TextGrids, `skip_these_labels` argument has been replaced by 
`includeTheseLabels` argument, which by default is just any non-empty interval.

* If using TextGrids, there's currently no support for point tiers, as most
users probably extract time series these days.

* When using TextGrids: Instead of creating pitch, formant objects, etc for the 
entire sound file, the relevant intervals are snipped out, and the signals are 
derived from those. To save time if people are processing only few intervals 
from very long sound files.
  * Actually, a bit of time (roughly corresponding to an analysis window) is 
  appended to the start and end of TextGrid intervals to avoid missing 
  measurements at the beginning and end of intervals (see below)
  
* Instead of using Praat's default "time step" settings when deriving signals, 
we use the sampling frequency that users ask for in the parameters file. This 
speeds things up when users ask for fewer samples than Praat provides by default, 
and slows things down when users ask for more. Previously this was dealt with by 
interpolating values in between calculated samples, now all samples that the 
user gets are actually derived from the audio.
  * This has the (major) advantage that we can grab values as whole vectors 
  instead of looping through time steps! I'm not sure this works entirely as 
  intended when grabbing measures at equidistant points though, this is 
  something to look into a bit more.
  * Because of the opaque way that Praat determines the time of a measures (see 
  below), this results in vectors that are of uneven length. This is fixed by 
  appending zeroes to the start and end of these vectors to make sure they're of 
  equal length. Following the overview below, this may result in time stamps 
  that are a 1-2 ms off for some measures, but shouldn't be more than that.

* Pitch is now by default calculated using the `To Pitch (filtered ac)` which is 
the new Praat gold standard, but users can also choose to use either raw 
autocorrelation or raw crosscorrelation.

* All pitch and parameter settings can now be set by the user.

* The `Kill octave jumps` routine can be applied to the pitch object.

* For simplicity, we removed the option to calculate only 2 formants. It's a 
hassle to code around and calculating the third formant is blazing fast anyways.

* When calculating HNR, Praat's "silence threshold" used to be set as 0.1. This 
means that frames with amplitude levels below this value were treated as 
"silent", and Praat automatically returns an HNR value of -200. There are a lot 
of -200s when using legacy PS, and I'm not convinced we want this, so we set the 
silence threshold to a much lower value (0.00001). 

* When calculating CPP, we now by default use the "exponential decay" trend type. 
The terminology here is a bit weird -- as I understand it, CPP is basically the 
highest residual value from a linear regression of the cepstrum (which should 
correspond to the relative strength of the first harmonic). If trend type is 
"exponential decay", the cepstral energy values are transformed to account for 
the non-linear shape of the cepstrum. This'll mean a better model fit for sure, 
and as a result probably reduces the CPP. The Praat documentation recommends 
this, but Hillenbrand et al do *not* do this. It is still a user option to get
CPP from a linear trend line.

* CPP is tabulated directly from a cepstrogram, which is probably a relatively 
new feature of Praat.

* For calculating harmonic amplitudes and spectral slopes, we first generate a 
spectrogram and then extract slices from that spectrogram. This seems more 
efficient making spectral slices one by one.

* The upper and lower limits of where to look for H2K and H5K are now just based 
on the pitch measures, where in previous versions it was based on the cepstral
peak. 

* There's no correction of H2K.
  * Previous version corrects it for the first three formants -- but that may be
  potentially problematic when third formant is below is 2000 Hz. We may well
  add in correction of H2K in the future.
  
* It is now possible to pass a list of files if files are spread across 
different directories. This is very useful fx when working with EMU databases.

## Time

If we really want to speed up things in Praat, it's crucial that we don't have 
to gather values through a loop when we don't have to. This is nicely solved for 
`Pitch` objects, which have an actual `List values at times` function where we 
can pass a vector of times. Unfortunately it doesn't work like that for any of 
the other object types, so we have to settle for one of the Next Best Solutions:

- Grabbing values by calling `Get value at time` (slow)
- Converting the object to a matrix and just grabbing the values directly from 
there

The second solution is obviously less computationally wasteful, but leads to a 
problem: it's really opaque where Praat determines to take the first sample. 

This is all super easy with the `wrassp` functions -- if you ask `wrassp` to 
return measures at 5 ms intervals, then it'll return measures taken at 
`0.005 0.010 0.015 0.020` etc. This has the obvious disadvantage that some of 
these measures will logically be bogus. You can't possibly have a good formant 
estimate 5 ms into a sound file if your analysis window is 25 ms. But it sure 
makes it easier to produce a large matrix with comparable time series! Here's 
what I've been able to find out:

### Pitch

The location of the first pitch sample depends on window length. Window length 
is *supposed to* be just long enough to capture three periods, i.e. 
$3 \frac{1}{minPitch}$, i.e. 60 ms if $minPitch$ is 50 Hz. 
You'd expect the first pitch sample to be at the centre of the first window, 
i.e. `0.030` with a 50 Hz $minPitch$. That's *almost* true, but it's a bit 
later, because it also depends on the sampling frequency (time step). The first 
measure seems to be taken at approx. 
$\frac{3 \frac{1}{minPitch}}{2} + \frac{timeStep}{2} - 0.182$ ms.

We can check this with any sound file:

```
minPitch = 50
timeStep = 0.005

To Pitch (filtered ac): timeStep, minPitch, 800, 15, 0, 0.03, 0.09, 0.5, 0.055, 0.35, 0.14
firstMeasure = Get time from frame number: 1

writeInfoLine: "We expect: ", ((3 * (1 / minPitch)) / 2) + (timeStep / 2) - 0.000182
appendInfoLine: "We get: ", firstMeasure
```

returns

```
We expect: 0.032318
We get: 0.03231859410430832
```

With `minPitch = 100` and `timeStep = 0.001`:

```
We expect: 0.015318
We get: 0.015318594104308414
```

With `minPitch = 75` and `timeStep = 0.01`:

```
We expect: 0.024818
We get: 0.024818594104308308
```

So far so good. *But* ... with `minPitch = 88` and `timeStep = 0.005`:

```
We expect: 0.01936345454545454
We get: 0.017318594104308412
```

Why? Because instead of actually determining the window size with 
$3 \frac{1}{minPitch}$, as far as I can gather, the window size is 
$3 \frac{1}{minPitch}$ *rounded to the nearest 5 ms*. $3 \frac{1}{minPitch}$ 
suggests a window size of approx $3 \frac{1}{88} \approx 34ms$, but Praat 
*actually* uses a 30 ms window. Here with 
`minPitch = 100` ($3 \frac{1}{100} = 30ms$) and `timeStep = 0.005`:

```
We expect: 0.017317999999999997
We get: 0.017318594104308412
```

Note that this doesn't mean that the minimum pitch value is just ignored! It's 
not like setting a minimum pitch of 88 Hz effectively ignores pitch values 
between 88--100 Hz, although I can only imagine that this reduces the precision 
in the 88--100 Hz range a bit.

### HNR

The location of the first HNR sample is also based on a combination of the 
window length and sampling frequency. Boersma (1993) writes that the window 
length for measuring harmonics-to-noise ratio should be enough to capture six 
periods, but this is the auto-correlation based method (`To Harmonicity (ac)`), 
and Praat documentation now recommends the cross-correlation method 
(`To Harmonicity (cc)`). The window length used for the `cc` method seems to be 
much shorter, just enough to capture two periods, i.e. $2 \frac{1}{minPitch}$.
The effect of sampling frequency is the same as pitch, so the first measure 
should be taken at $\frac{2 \frac{1}{minPitch}}{2} + \frac{timeStep}{2} - 0.182$.

We can test that as above with any sound file:

```
minPitch = 50
timeStep = 0.005

To Harmonicity (cc): timeStep, minPitch, 0.1, 1
firstMeasure = Get time from frame number: 1

writeInfoLine: "We expect: ", ((2 * (1 / minPitch)) / 2) + (timeStep / 2) - 0.000182
appendInfoLine: "We get: ", firstMeasure
```

returns

```
We expect: 0.022317999999999998
We get: 0.022318594104308306
```

With `minPitch = 100` and `timeStep = 0.001`:

```
We expect: 0.010318
We get: 0.01031859410430841
```

As with pitch though, the window size is rounded to the nearest 5 ms. The fact 
that the same `minPitch` value yields a different window size when calculating 
pitch and HNR is a hassle, and the rounding only makes this relationship more 
opaque!

### Intensity

I get the gist at this point. The documentation tells me that the effective 
analysis window used for calculating intensity is enough to capture 3.2 pitch 
periods (for some reason!). The actual analysis window is twice that -- I don't 
know why this isn't the case for pitch and HNR, I was under the impression that 
the same Gaussian window with sidelobes is used for all derived signals in Praat, 
maybe not?

This means that we can predict the first frame duration as 
$\frac{6.4 \frac{1}{minPitch}}{2} + \frac{timeStep}{2} - 0.182$. This checks out 
with `minPitch = 50` and `timeStep = 0.005`:

```
minPitch = 50
timeStep = 0.001

To Intensity: minPitch, timeStep, 1
firstMeasure = Get time from frame number: 1

writeInfoLine: "We expect: ", ((6.4 * (1 / minPitch)) / 2) + (timeStep / 2) - 0.000182
appendInfoLine: "We get: ", firstMeasure
```

returns

```
We expect: 0.064318
We get: 0.06431859410430835
```

Which is actually a little surprising, since $6.4 \frac{1}{50} = 64ms$, 
suggesting that window sizes for calculating intensity are *not* rounded to the 
nearest 5 ms. There is definitely *some* rounding going on, because we can't 
straightforwardly predict the window size with, say, `minPitch = 110`, which 
should be $6.4 \frac{1}{50} \approx 29ms$:

```
We expect: 0.02940890909090909
We get: 0.029318594104308315
```

Close enough, but a little off, which suggests to me that the window size is 
rounded to the nearest 2 ms.

### Formants

Formants are a bit easier because you actually specify the window length 
directly. With the default window length of 25 ms, the first sample is taken at 
approx. $windowLength + \frac{timeStep}{2} - 0.182$. We can test this:

```
windowLength = 0.025
timeStep = 0.005

To Formant (burg): timeStep, 5, 5500, windowLength, 50
firstMeasure = Get time from frame number: 1

writeInfoLine: "We expect: ", windowLength + (timeStep / 2) - 0.000182
appendInfoLine: "We get: ", firstMeasure
```

returns

```
We expect: 0.037318000000000004
We get: 0.03731859410430838
```

Note that these window sizes *still appear to be rounded*. They appear to be 
rounded to the nearest 2.5 ms. We can't correctly predict the location of the 
first sample for a 33 ms window `windowLength = 0.033` with `timeStep = 0.005`:

```
We expect: 0.035318
We get: 0.03481859410430832
```

.... because it's the same as a 32.5 ms `windowLength = 0.0325`, `timeStep = 0.005`:

```
We expect: 0.034818
We get: 0.03481859410430832
```

### Thoughts

All this to say that sampling different derived signals along the exact same 
grid in Praat is not at all straightforward, and Praat currently isn't making it 
easy for us to get around that. Especially because window sizes can't actually 
be specified directly, but are typically determined based on a minimum pitch 
value. We might want to use a larger-than-required window to calculate HNR just 
to make sure that samples are equally spaced, but the only way to increase the 
sample size is to reduce the minimum pitch, which will of course have unwanted 
consequences. One thing to discuss going forward is whether we just want to live 
with a slight (1--2 ms) displacement of measures. The displacement is 
predictable, but I would've been happier if it was a bit more straightforwardly 
predictable.

### Interim solution

So far I've solved this with zero padding in a way that should make sure that 
all results vectors are equally long and use **roughly** the same times.
