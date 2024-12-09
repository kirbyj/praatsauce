### Extract one channel from sound file

procedure extract_channel: .channel

snd = selected("Sound")
mono = Extract one channel: .channel

## the rest is just clean-up

removeObject: snd

endproc
