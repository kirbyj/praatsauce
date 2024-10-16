### Extract one channel from sound file

procedure extract_channel: .channel

soundID = selected("Sound")
Extract one channel: .channel

## the rest is just clean-up

monoID = selected("Sound")
select soundID
Remove
select monoID
soundID = selected("Sound")

endproc
