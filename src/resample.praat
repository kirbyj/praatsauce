### Resample sound file to 16 kHz

procedure resample

soundID = selected("Sound")

## second argument is "interpolation precision" -- a bit beyond my pay grade
Resample: 16000, 50

## clean up, keep only the resampled sound

resampledID = selected("Sound")
select soundID
Remove
select resampledID
soundID = selected("Sound")

endproc
