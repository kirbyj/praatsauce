### Resample sound file to 16 kHz

procedure resample

snd = selected("Sound")

## second argument is "interpolation precision" -- a bit beyond my pay grade
Resample: 16000, 50

## clean up, keep only the resampled sound

resamp = selected("Sound")
removeObject: snd
selectObject: resamp
snd = selected("Sound")

endproc
