require(ggplot2)
require(tidyr)
require(plyr)
require(scales)
require(stringr)

## VoiceSauce measures
keeps <- c('Filename', 'Label', 'Item', 'seg_Start', 'seg_End', 't_ms', 'H1c', 'H2c', 'H4c', 'A1c', 'A2c', 'A3c', 'H1u', 'H2u', 'H4u', 'A1u', 'A2u', 'A3u', 'H2Ku', 'H5Ku', 'CPP', 'HNR05', 'HNR15', 'HNR25', 'HNR35', 'H1H2u', 'H2H4u', 'H1A1u', 'H1A2u', 'H1A3u', 'H1H2c', 'H2H4c', 'H1A1c', 'H1A2c', 'H1A3c', 'H2KH5Ku', 'strF0', 'sF0', 'pF0', 'sF1', 'sF2', 'sF3', 'pF1', 'pF2', 'pF3', 'pB1', 'pB2', 'pB3', 'sB1', 'sB2', 'sB3')

## VoiceSauce, formula bandwidths
vs.fbw <- read.csv('/Users/jkirby/Documents/Projects/praatsauce/comp/hmong_female_voicesauce_formulabw.txt', sep='\t')
## get rid of .mat extention
vs.fbw$Filename <- gsub('.mat', '', vs.fbw$Filename)
vs.fbw <- vs.fbw %>% separate(Filename, c("Num", "Item", "Junk"), "-", remove=FALSE)
vs.fbw <- vs.fbw[keeps]
vs.fbw$method = rep("vs.fbw")
## scaled time
vs.fbw<-ddply(vs.fbw, .(Filename), mutate, t=rescale(t_ms))
vs.fbw.long <- gather(vs.fbw, measure, value, H1c:sB3, factor_key=TRUE)        

## VoiceSauce, estimated bandwidths (maybe)
vs.ebw <- read.csv('/Users/jkirby/Documents/Projects/praatsauce/comp/hmong_female_voicesauce_estbw.txt', sep='\t')
## get rid of .mat extention
vs.ebw$Filename <- gsub('.mat', '', vs.ebw$Filename)
vs.ebw <- vs.ebw %>% separate(Filename, c("Num", "Item", "Junk"), "-", remove=FALSE)
vs.ebw <- vs.ebw[keeps]
## scaled time
vs.ebw<-ddply(vs.ebw, .(Filename), mutate, t=rescale(t_ms))
vs.ebw$method = rep("vs.ebw")
vs.ebw.long <- gather(vs.ebw, measure, value, H1c:sB3, factor_key=TRUE)        


######################
## praatSauce measures
######################

## symmetric kernels
f21 <- rep(1/21,21)
f51 <- rep(1/51,51)
## lag kernel
f20 <- rep(1/20,20)

## PraatSauce, formula bandwidths
ps.fbw <- read.csv('/Users/jkirby/Documents/Projects/praatsauce/comp/hmong_female_praatsauce_formulabw.txt', header=TRUE)
## turn into msec
ps.fbw$seg_Start <- ps.fbw$seg_Start * 1000
ps.fbw$seg_End <- ps.fbw$seg_End* 1000
ps.fbw$t_ms <- ps.fbw$t_ms* 1000
drops <- c('t', 'var1', 'var3')
ps.fbw <- ps.fbw[, !(names(ps.fbw) %in% drops)]

names(ps.fbw) <- c('Filename', 'Item', 'Label', 'seg_Start', 'seg_End', 't_ms', 'pF0', 'pF1', 'pF2', 'pF3', 'pB1', 'pB2', 'pB3', 'H1u', 'H2u', 'H4u', 'H2Ku', 'H5Ku', 'A1u','A2u', 'A3u', 'H1H2u', 'H2H4u', 'H1A1u', 'H1A2u', 'H1A3u', 'H2KH5Ku', 'H1c', 'H2c', 'H4c', 'A1c', 'A2c', 'A3c', 'H1H2c', 'H2H4c', 'H1A1c', 'H1A2c', 'H1A3c', 'CPP', 'HNR05', 'HNR15', 'HNR25',  'HNR35')

## remove zeros
ps.fbw[ps.fbw == 0] <- NA

## smoothing
ps.fbw <- cbind(ps.fbw[1:6], apply(ps.fbw[7:43], 2, filter, filter=f21, sides=2))

## scaled time
ps.fbw<-ddply(ps.fbw, .(Filename), mutate, t=rescale(t_ms))
ps.fbw$method = rep("ps.fbw") 
ps.fbw.long <- gather(ps.fbw, measure, value, pF0:HNR35, factor_key=TRUE)

## PraatSauce, estimated bandwidths
ps.ebw <- read.csv('/Users/jkirby/Documents/Projects/praatsauce/comp/hmong_female_praatsauce_estbw.txt', header=TRUE)
## turn into msec
ps.ebw$seg_Start <- ps.ebw$seg_Start * 1000
ps.ebw$seg_End <- ps.ebw$seg_End* 1000
ps.ebw$t_ms <- ps.ebw$t_ms* 1000
ps.ebw <- ps.ebw[, !(names(ps.ebw) %in% drops)]

names(ps.ebw) <- c('Filename', 'Item', 'Label', 'seg_Start', 'seg_End', 't_ms', 'pF0', 'pF1', 'pF2', 'pF3', 'pB1', 'pB2', 'pB3', 'H1u', 'H2u', 'H4u', 'H2Ku', 'H5Ku', 'A1u','A2u', 'A3u', 'H1H2u', 'H2H4u', 'H1A1u', 'H1A2u', 'H1A3u', 'H2KH5Ku', 'H1c', 'H2c', 'H4c', 'A1c', 'A2c', 'A3c', 'H1H2c', 'H2H4c', 'H1A1c', 'H1A2c', 'H1A3c', 'CPP', 'HNR05', 'HNR15', 'HNR25',  'HNR35')

## remove zeros
ps.ebw[ps.ebw == 0] <- NA

## smooth
ps.ebw <- cbind(ps.ebw[1:6], apply(ps.ebw[7:43], 2, filter, filter=f21, sides=2))

ps.ebw<-ddply(ps.ebw, .(Filename), mutate, t=rescale(t_ms))
ps.ebw$method = rep("ps.ebw") 
ps.ebw.long <- gather(ps.ebw, measure, value, pF0:HNR35, factor_key=TRUE)

## combine
df <- rbind(ps.fbw.long,ps.ebw.long,vs.fbw.long,vs.ebw.long)

#####################
## plots
#####################

#quartz()

theme_set(theme_bw())

#############################
## F0
#############################
ggplot(subset(df, method %in% c('ps.fbw', 'vs.fbw') & measure %in% c('strF0', 'pF0', 'sF0')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales='free') + ggtitle("PraatSauce and VoiceSauce F0 measures")
## PraatSauce is more conservative (less accurate?) at left edge;
## not clear why VoiceSauce's pF0 estimate differs so dramatically
## some octave est problems in cim

## formants
ggplot(subset(df, method %in% c('ps.ebw', 'vs.ebw') & measure %in% c('pF1', 'pF2', 'pF3')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales='free')
## again, the VoiceSauce estimates based on Praat are much less consistent 
## then the PraatSauce estimates

## cf. Snack
ggplot(subset(df, (method == 'ps.ebw' & measure %in% c('pF1', 'pF2', 'pF3')) | (method== 'vs.ebw' & measure %in% c('sF1', 'sF2', 'sF3'))), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales='free')
## These look very similar, but PS has problems with the 2nd half of cug (Male)


#############################
## Bandwidths
#############################
ggplot(subset(df, method %in% c('ps.ebw', 'ps.fbw') & measure %in% c('pB1', 'pB2', 'pB3', 'sB1', 'sB2', 'sB3')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales='free') + ggtitle("PraatSauce formula vs. estimated bandwidths")
## PraatSauce estimated bandwidths are huge...

ggplot(subset(df, method %in% c('ps.ebw', 'vs.ebw') & measure %in% c('pB1', 'pB2', 'pB3')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales='free') + ggtitle("VoiceSauce vs. PraatSauce estimated bandwidths")
## ... but VoiceSauce Praat-estimated bandwiths are an order of magnitude huger

ggplot(subset(df, method %in% c('vs.ebw') & measure %in% c('pB1', 'pB2', 'pB3', 'sB1', 'sB2', 'sB3')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales='free') + ggtitle("VoiceSauce Praat vs. Snack estimated bandwidths")
## Snack estimates look less erratic

ggplot(subset(df, (method == 'ps.ebw' & measure %in% c('pB1', 'pB2', 'pB3')) | (method== 'vs.ebw' & measure %in% c('sB1', 'sB2', 'sB3'))), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales='free') + ggtitle("VoiceSauce Snack vs. PraatSauce estimated bandwidths")  

## upshot: may be best to use formula estimates in most cases for consistency

#############################
## uncorrected amplitudes
#############################
## effects of PS vs VS (smoothed) estimates 
## choice of bandwidth irrelevant here
ggplot(subset(df, method %in% c('ps.fbw', 'vs.fbw') & measure %in% c('H1u', 'H2u', 'H4u')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales="free_x") + ggtitle("VoiceSauce vs. PraatSauce uncorrected harmonic amplitudes, H1-H4")

ggplot(subset(df, method %in% c('ps.fbw', 'vs.fbw') & measure %in% c('A1u', 'A2u', 'A3u')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales='free_x') + ggtitle("VoiceSauce vs. PraatSauce uncorrected harmonic amplitudes, A1-A3")
## PS estimates are ~ 20-25 dB higher than VS estimates
## Smoothing PS might be a good idea

#############################
## corrected amplitudes
#############################
## here choice of formant bandwidth estimator potentially matters
## PS is using Praat and VS is using Snack
ggplot(subset(df, method %in% c('ps.ebw', 'vs.ebw') & measure %in% c('H1c', 'H2c', 'H4c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales="free_x") + ggtitle("VoiceSauce vs. PraatSauce corrected harmonic amplitudes, estimated bandwidths, H1-H4")

ggplot(subset(df, method %in% c('ps.fbw', 'vs.fbw') & measure %in% c('H1c', 'H2c', 'H4c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales="free_x") + ggtitle("VoiceSauce vs. PraatSauce corrected harmonic amplitudes, formula bandwidths, H1-H4")
## doesn't change VS estimates but PS estimates change slightly

ggplot(subset(df, method %in% c('ps.ebw', 'vs.ebw') & measure %in% c('A1c', 'A2c', 'A3c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales='free_x') + ggtitle("VoiceSauce vs. PraatSauce corrected harmonic amplitudes, estimated bandwidths, A1-A3")

ggplot(subset(df, method %in% c('ps.fbw', 'vs.fbw') & measure %in% c('A1c', 'A2c', 'A3c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales='free_x') + ggtitle("VoiceSauce vs. PraatSauce corrected harmonic amplitudes, formula bandwidths, A1-A3")


## PS formula vs. estimate
ggplot(subset(df, method %in% c('ps.ebw', 'ps.fbw') & measure %in% c('H1c', 'H2c', 'H4c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales="free_x") + ggtitle("PraatSauce corrected harmonic amplitudes, formula vs. estimated bandwidths, H1*, H2*, H4*")
## very nearly identical. for female pog, poj we can see the issue introduced
## by the formula calculation on H4

ggplot(subset(df, method %in% c('ps.ebw', 'ps.fbw') & measure %in% c('A1c', 'A2c', 'A3c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales="free_x") + ggtitle("PraatSauce corrected harmonic amplitudes, formula vs. estimated bandwidths, A1*, A2*, A3*")
## greater differences. Formula corrections are to some extent more erratic, at
## least for the male speaker

## PS corrected vs. uncorrected
ggplot(subset(df, method %in% c('ps.ebw', 'ps.fbw') & measure %in% c('H1u', 'H2u', 'H4u', 'H1c', 'H2c', 'H4c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales="free_x") + ggtitle("PraatSauce corrected vs. uncorrected harmonic amplitudes, formula vs. estimated bandwidths, H1-H4")

ggplot(subset(df, method %in% c('ps.ebw', 'ps.fbw') & measure %in% c('A1u', 'A2u', 'A3u', 'A1c', 'A2c', 'A3c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales="free_x") + ggtitle("PraatSauce corrected vs. uncorrected harmonic amplitudes, formula vs. estimated bandwidths, A1-A3")

# VS formula vs. estimate
ggplot(subset(df, method %in% c('vs.ebw', 'vs.fbw') & measure %in% c('H1c', 'H2c', 'H4c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales="free_x") + ggtitle("VoiceSauce corrected harmonic amplitudes, formula vs. estimated bandwidths, H1*, H2*, H4*")
## even more very nearly identical

ggplot(subset(df, method %in% c('vs.ebw', 'vs.fbw') & measure %in% c('A1c', 'A2c', 'A3c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales="free_x") + ggtitle("VoiceSauce corrected harmonic amplitudes, formula vs. estimated bandwidths, A1*, A2*, A3*")
## even more very nearly identical. I find it hard to believe it's really using
## different estimates


#############################
## corrected differences
#############################
## here choice of formant bandwidth estimator potentially matters
## PS is using Praat and VS is using Snack
ggplot(subset(df, method %in% c('ps.ebw', 'vs.ebw') & measure %in% c('H1H2c', 'H2H4c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales="free_x") + ggtitle("VoiceSauce vs. PraatSauce corrected harmonic amplitude differences, estimated bandwidths, H1*-H2* & H2*-H4*")

ggplot(subset(df, method %in% c('ps.fbw', 'vs.fbw') & measure %in% c('H1H2c', 'H2H4c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales="free_x") + ggtitle("VoiceSauce vs. PraatSauce corrected harmonic amplitude differences, formula bandwidths, H1*-H2* & H2*-H4*")
## estimated BW reduces amplitiude more for both methods
## not clear where erraticness in female cav is coming from; formant estimates
## are quite robust. must lie in the Praat method for detecting harmonic peaks

ggplot(subset(df, method %in% c('ps.ebw', 'vs.ebw') & measure %in% c('H1A1c', 'H1A2c', 'H1A3c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales='free_x') + ggtitle("VoiceSauce vs. PraatSauce corrected harmonic amplitude differences, estimated bandwidths, H1*-A1*, A2*, A3*")

ggplot(subset(df, method %in% c('ps.fbw', 'vs.fbw') & measure %in% c('H1A1c', 'H1A2c', 'H1A3c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure))) + geom_line() + facet_wrap(~Filename, ncol=3, scales='free_x') + ggtitle("VoiceSauce vs. PraatSauce corrected harmonic amplitude differences, formula bandwidths, H1*-A1*, A2*, A3*")
## again, estimated BW reduces amplitudes more for both methods


#############################
## CPP
#############################

ggplot(subset(df, method %in% c('vs.fbw', 'ps.fbw') & measure %in% c('CPP')), aes(t_ms, value, group=method, colour=method, linetype=method)) + geom_line() + facet_wrap(~Filename, scales='free_x') + ggtitle("Praat bandwidths, corrected vs. uncorrected")
## OK if smoothed

#############################
## HNR
#############################

ggplot(subset(df, value>-10 & method %in% c('vs.fbw', 'ps.fbw') & measure %in% c('HNR05', 'HNR15', 'HNR25', 'HNR35')), aes(t_ms, value, group=interaction(measure,method), colour=measure, linetype=method)) + geom_line() + facet_wrap(~Filename, scales='free_x') + ggtitle("Praat bandwidths, corrected vs. uncorrected")
## again the Praat estimates differ in amplitude - here lower than VS

#############################
## can we distinguish modal
## from breathy?
#############################

gj <- subset(df, Item %in% c('tis', 'tig', 'tim'))
#gj <- subset(df, Item %in% c('cab', 'cag', 'cav'))
#gj <- subset(df, Item %in% c('pob', 'pog', 'poj'))

ggplot(subset(gj, measure %in% c('H1H2u')), aes(t, value, colour=Item, group=interaction(Item,measure))) + geom_line() + facet_wrap(~method, ncol=2, scales="free_x") + ggtitle("VoiceSauce vs. PraatSauce uncorrected harmonic amplitude differences, H1-H2")

ggplot(subset(gj, measure %in% c('H1H2c')), aes(t, value, colour=Item, group=interaction(Item,measure))) + geom_line() + facet_wrap(~method, ncol=2, scales="free_x") + ggtitle("VoiceSauce vs. PraatSauce corrected harmonic amplitude differences, H1*-H2*")

ggplot(subset(gj, measure %in% c('H1A1u')), aes(t, value, colour=Item, group=interaction(Item,measure))) + geom_line() + facet_wrap(~method, ncol=2, scales="free_x") + ggtitle("VoiceSauce vs. PraatSauce uncorrected harmonic amplitude differences, H1-A1")

ggplot(subset(gj, measure %in% c('H1A1c')), aes(t, value, colour=Item, group=interaction(Item,measure))) + geom_line() + facet_wrap(~method, ncol=2, scales="free_x") + ggtitle("VoiceSauce vs. PraatSauce corrected harmonic amplitude differences, H1*-A1*")

ggplot(subset(gj, measure %in% c('H1A2u')), aes(t, value, colour=Item, group=interaction(Item,measure))) + geom_line() + facet_wrap(~method, ncol=2, scales="free_x") + ggtitle("VoiceSauce vs. PraatSauce uncorrected harmonic amplitude differences, H1-A2")

ggplot(subset(gj, measure %in% c('H1A2c')), aes(t, value, colour=Item, group=interaction(Item,measure))) + geom_line() + facet_wrap(~method, ncol=2, scales="free_x") + ggtitle("VoiceSauce vs. PraatSauce corrected harmonic amplitude differences, H1*-A2*")

ggplot(subset(gj, measure %in% c('H1A3c')), aes(t, value, colour=Item, group=interaction(Item,measure))) + geom_line() + facet_wrap(~method, ncol=2, scales="free_x") + ggtitle("VoiceSauce vs. PraatSauce corrected harmonic amplitude differences, H1*-A3*")

ggplot(subset(gj, measure %in% c('CPP')), aes(t, value, colour=Item, group=interaction(Item,measure))) + geom_line() + facet_wrap(~method, ncol=2, scales="free_x") + ggtitle("VoiceSauce vs. PraatSauce, cepstral peak prominence")

ggplot(subset(gj, measure %in% c('HNR05')), aes(t, value, colour=Item, group=interaction(Item,measure))) + geom_line() + facet_wrap(~method, ncol=2, scales="free_x") + ggtitle("VoiceSauce vs. PraatSauce, HNR05")


### Some thoughts ###

## - Praat F0 estimation is generally pretty OK

## - PraatSauce's harmonic amplitude detection is not as robust/smooth - should
##   be investigated further

## - VoiceSauce's smoothing (by dint of Matlab's filter() behaviour) makes the 
##   left edges of corrections potentially questionable

## - VoiceSauce may correct too strongly -- at least, things that are 'known'
##   to be breathy are sometimes estimated with having smaller tilts vis-a-vis
##   PraatSauce

## - Formula vs. Praat/Snack bandwidth estimation doesn't seem to have a 
##   huge impact on corrections; this is probably because the bandwidth only
##   enters the I&A correction formula in the term $e^{-\pi B_i/F_s}$, so even
##   changes of an order of magnitude do not radically affect the output

## - Not only do different spectral measures appear to be better at 
##   distinguishing VQ-based contrasts in different languages, but different
##   measures also do better for different vowels/tokens/speakers???

## - Binning? Window sizes?