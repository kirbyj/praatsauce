#############################################################
## 31 Jan 2018: DEPRECATED: see vs-ps-madurese.Rmd instead
#############################################################

require(ggplot2)
require(tidyr)
require(stringr)

## VoiceSauce measures
keeps <- c('Filename', 'Type', 'Item', 'seg_Start', 'seg_End', 't_ms', 'H1c', 'H2c', 'H4c', 'A1c', 'A2c', 'A3c', 'H1u', 'H2u', 'H4u', 'A1u', 'A2u', 'A3u', 'H2Ku', 'H5Ku', 'CPP', 'HNR05', 'HNR15', 'HNR25', 'HNR35', 'H1H2u', 'H2H4u', 'H1A1u', 'H1A2u', 'H1A3u', 'H1H2c', 'H2H4c', 'H1A1c', 'H1A2c', 'H1A3c', 'H2KH5Ku', 'strF0', 'sF0', 'pF0', 'sF1', 'sF2', 'sF3', 'pF1', 'pF2', 'pF3', 'pB1', 'pB2', 'pB3', 'sB1', 'sB2', 'sB3')

vs.fbw <- read.csv('/Users/jkirby/Documents/Projects/praatsauce/comp/madurese_voicesauce_formulabw.txt', sep='\t')
## get rid of .mat extention
vs.fbw$Filename <- gsub('.mat', '', vs.fbw$Filename)
vs.fbw <- vs.fbw %>% separate(Filename, c("Type", "Num", "Item"), "_", remove=FALSE)
vs.fbw <- vs.fbw[keeps]
vs.fbw$method = rep("formula")
vs.fbw$script = rep("VoiceSauce")
vs.fbw.long <- gather(vs.fbw, measure, value, H1c:sB3, factor_key=TRUE)        

vs.ebw <- read.csv('/Users/jkirby/Documents/Projects/praatsauce/comp/madurese_voicesauce_estbw.txt', sep='\t')
## get rid of .mat extention
vs.ebw$Filename <- gsub('.mat', '', vs.ebw$Filename)
vs.ebw <- vs.ebw %>% separate(Filename, c("Type", "Num", "Item"), "_", remove=FALSE)
vs.ebw <- vs.ebw[keeps]
vs.ebw$method = rep("estimated")
vs.ebw$script = rep("VoiceSauce")
vs.ebw.long <- gather(vs.ebw, measure, value, H1c:sB3, factor_key=TRUE)        


######################
## praatSauce measures
######################

## symmetric kernels
f21 <- rep(1/21,21)
f51 <- rep(1/51,51)
## lag kernel
f20 <- rep(1/20,20)

ps.fbw <- read.csv('/Users/jkirby/Documents/Projects/praatsauce/comp/madurese_praatsauce_formulabw.txt', header=TRUE)
## turn into msec
ps.fbw$seg_Start <- ps.fbw$seg_Start * 1000
ps.fbw$seg_End <- ps.fbw$seg_End* 1000
ps.fbw$t_ms <- ps.fbw$t_ms* 1000
drops <- c('t', 'Label', 'var2')
ps.fbw <- ps.fbw[, !(names(ps.fbw) %in% drops)]

names(ps.fbw) <- c('Filename', 'Type', 'Item', 'seg_Start', 'seg_End', 't_ms', 'pF0', 'pF1', 'pF2', 'pF3', 'pB1', 'pB2', 'pB3', 'H1u', 'H2u', 'H4u', 'H2Ku', 'H5Ku', 'A1u','A2u', 'A3u', 'H1H2u', 'H2H4u', 'H1A1u', 'H1A2u', 'H1A3u', 'H2KH5Ku', 'H1c', 'H2c', 'H4c', 'A1c', 'A2c', 'A3c', 'H1H2c', 'H2H4c', 'H1A1c', 'H1A2c', 'H1A3c', 'CPP', 'HNR05', 'HNR15', 'HNR25',  'HNR35')

## remove zeros
ps.fbw[ps.fbw == 0] <- NA

## smoothing
#ps.fbw <- cbind(ps.fbw[1:6], apply(ps.fbw[7:43], 2, filter, filter=f21, sides=2))

ps.fbw$method = rep("estimated")
ps.fbw$script = rep("PraatSauce")
ps.fbw.long <- gather(ps.fbw, measure, value, pF0:HNR35, factor_key=TRUE)

ps.ebw <- read.csv('/Users/jkirby/Documents/Projects/praatsauce/comp/madurese_praatsauce_estbw.txt', header=TRUE)
## turn into msec
ps.ebw$seg_Start <- ps.ebw$seg_Start * 1000
ps.ebw$seg_End <- ps.ebw$seg_End* 1000
ps.ebw$t_ms <- ps.ebw$t_ms* 1000
ps.ebw <- ps.ebw[, !(names(ps.ebw) %in% drops)]

names(ps.ebw) <- c('Filename', 'Type', 'Item', 'seg_Start', 'seg_End', 't_ms', 'pF0', 'pF1', 'pF2', 'pF3', 'pB1', 'pB2', 'pB3', 'H1u', 'H2u', 'H4u', 'H2Ku', 'H5Ku', 'A1u','A2u', 'A3u', 'H1H2u', 'H2H4u', 'H1A1u', 'H1A2u', 'H1A3u', 'H2KH5Ku', 'H1c', 'H2c', 'H4c', 'A1c', 'A2c', 'A3c', 'H1H2c', 'H2H4c', 'H1A1c', 'H1A2c', 'H1A3c', 'CPP', 'HNR05', 'HNR15', 'HNR25',  'HNR35')

## remove zero
ps.ebw[ps.ebw == 0] <- NA

## smooth
#ps.ebw <- cbind(ps.ebw[1:6], apply(ps.ebw[7:43], 2, filter, filter=f21, sides=2))

ps.ebw$method = rep("estimated")
ps.ebw$script = rep("PraatSauce")
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
ggplot(subset(df, value > 0 & method %in% c('ps.fbw', 'vs.fbw') & measure %in% c('strF0', 'pF0', 'sF0')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales='free') + ggtitle("PraatSauce and VoiceSauce F0 measures")
## PraatSauce is more conservative (less accurate?) at left edge;
## not clear why VoiceSauce's pF0 estimate differs so dramatically

## formants
ggplot(subset(df, method %in% c('ps.ebw', 'vs.ebw') & measure %in% c('pF1', 'pF2', 'pF3')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales='free')
## again, the VoiceSauce estimates based on Praat are much less consistent 
## then the PraatSauce estimates

## cf. Snack
ggplot(subset(df, (method == 'ps.ebw' & measure %in% c('pF1', 'pF2', 'pF3')) | (method== 'vs.ebw' & measure %in% c('sF1', 'sF2', 'sF3'))), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales='free')
## These look very similar

#############################
## Bandwidths
#############################
ggplot(subset(df, method %in% c('ps.ebw', 'ps.fbw') & measure %in% c('pB1', 'pB2', 'pB3', 'sB1', 'sB2', 'sB3')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales='free') + ggtitle("PraatSauce formula vs. estimated bandwidths")
## PraatSauce estimated bandwidths are huge...

ggplot(subset(df, method %in% c('ps.ebw', 'vs.ebw') & measure %in% c('pB1', 'pB2', 'pB3')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales='free') + ggtitle("VoiceSauce vs. PraatSauce estimated bandwidths")
## ... but VoiceSauce Praat-estimated bandwidths are an order of magnitude huger

ggplot(subset(df, method %in% c('vs.ebw') & measure %in% c('pB1', 'pB2', 'pB3', 'sB1', 'sB2', 'sB3')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales='free') + ggtitle("VoiceSauce Praat vs. Snack estimated bandwidths")
## Snack estimates look less erratic

ggplot(subset(df, (method == 'ps.ebw' & measure %in% c('pB1', 'pB2', 'pB3')) | (method== 'vs.ebw' & measure %in% c('sB1', 'sB2', 'sB3'))), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales='free') + ggtitle("VoiceSauce Snack vs. PraatSauce estimated bandwidths")  
## PraatSauce estimates not completely off from Snack -- is VS reversing these
## in output? Or are we doing something wrong above?

## upshot: may be best to use formula estimates in most cases for consistency

#############################
## uncorrected amplitudes
#############################
## effects of PS (unsmoothed) vs VS (smoothed) estimates 
## choice of bandwidth irrelevant here
ggplot(subset(df, method %in% c('ps.fbw', 'vs.fbw') & measure %in% c('H1u', 'H2u', 'H4u')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales="free_x") + ggtitle("VoiceSauce vs. PraatSauce uncorrected harmonic amplitudes, H1-H4")

ggplot(subset(df, method %in% c('ps.fbw', 'vs.fbw') & measure %in% c('A1u', 'A2u', 'A3u')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales='free_x') + ggtitle("VoiceSauce vs. PraatSauce uncorrected harmonic amplitudes, A1-A3")
## PS estimates are ~ 20-25 dB higher than VS estimates
## Smoothing PS might be a good idea

#############################
## corrected amplitudes
#############################
## here choice of formant bandwidth estimator potentially matters
## PS is using Praat and VS is using Snack
ggplot(subset(df, method %in% c('ps.ebw', 'vs.ebw') & measure %in% c('H1c', 'H2c', 'H4c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales="free_x") + ggtitle("VoiceSauce vs. PraatSauce corrected harmonic amplitudes, estimated bandwidths, H1-H4")

ggplot(subset(df, method %in% c('ps.fbw', 'vs.fbw') & measure %in% c('H1c', 'H2c', 'H4c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales="free_x") + ggtitle("VoiceSauce vs. PraatSauce corrected harmonic amplitudes, formula bandwidths, H1-H4")
## doesn't change VS estimates but PS estimates change slightly

ggplot(subset(df, method %in% c('ps.ebw', 'vs.ebw') & measure %in% c('A1c', 'A2c', 'A3c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales='free_x') + ggtitle("VoiceSauce vs. PraatSauce uncorrected harmonic amplitudes, estimated bandwidths, A1-A3")

ggplot(subset(df, method %in% c('ps.fbw', 'vs.fbw') & measure %in% c('A1c', 'A2c', 'A3c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales='free_x') + ggtitle("VoiceSauce vs. PraatSauce uncorrected harmonic amplitudes, formula bandwithds, A1-A3")

## PS formula vs. estimate
ggplot(subset(df, method %in% c('ps.ebw', 'ps.fbw') & measure %in% c('H1c', 'H2c', 'H4c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales="free_x") + ggtitle("PraatSauce corrected harmonic amplitudes, formula vs. estimated bandwidths, H1*, H2*, H4*")
## very nearly identical 

ggplot(subset(df, method %in% c('ps.ebw', 'ps.fbw') & measure %in% c('A1c', 'A2c', 'A3c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales="free_x") + ggtitle("PraatSauce corrected harmonic amplitudes, formula vs. estimated bandwidths, A1*, A2*, A3*")
## greater differences. Formula corrections are to some extent more erratic

## PS corrected vs. uncorrected
ggplot(subset(df, method %in% c('ps.ebw', 'ps.fbw') & measure %in% c('H1u', 'H2u', 'H4u', 'H1c', 'H2c', 'H4c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales="free_x") + ggtitle("PraatSauce corrected vs. uncorrected harmonic amplitudes, formula vs. estimated bandwidths, H1-H4")

ggplot(subset(df, method %in% c('ps.ebw', 'ps.fbw') & measure %in% c('A1u', 'A2u', 'A3u', 'A1c', 'A2c', 'A3c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales="free_x") + ggtitle("PraatSauce corrected vs. uncorrected harmonic amplitudes, formula vs. estimated bandwidths, A1-A3")

# VS formula vs. estimate
ggplot(subset(df, method %in% c('vs.ebw', 'vs.fbw') & measure %in% c('H1c', 'H2c', 'H4c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales="free_x") + ggtitle("VoiceSauce corrected harmonic amplitudes, formula vs. estimated bandwidths, H1*, H2*, H4*")
## even more very nearly identical

ggplot(subset(df, method %in% c('vs.ebw', 'vs.fbw') & measure %in% c('A1c', 'A2c', 'A3c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales="free_x") + ggtitle("VoiceSauce corrected harmonic amplitudes, formula vs. estimated bandwidths, A1*, A2*, A3*")
## even more very nearly identical


#############################
## corrected differences
#############################
## here choice of formant bandwidth estimator potentially matters
## PS is using Praat and VS is using Snack
ggplot(subset(df, method %in% c('ps.ebw', 'vs.ebw') & measure %in% c('H1H2c', 'H2H4c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales="free_x") + ggtitle("VoiceSauce vs. PraatSauce corrected harmonic amplitude differences, estimated bandwidths, H1*-H2* & H2*-H4*")

ggplot(subset(df, method %in% c('ps.fbw', 'vs.fbw') & measure %in% c('H1H2c', 'H2H4c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales="free_x") + ggtitle("VoiceSauce vs. PraatSauce corrected harmonic amplitude differences, formula bandwidths, H1*-H2* & H2*-H4*")

ggplot(subset(df, method %in% c('ps.ebw', 'vs.ebw', 'ps.fbw', 'vs.fbw') & measure %in% c('H1H2c')), aes(t_ms, value, colour=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales="free_x") + ggtitle("VoiceSauce vs. PraatSauce corrected harmonic amplitude differences, formula bandwidths, H1*-H2* & H2*-H4*")
## estimated BW reduces amplitiude more for both methods

ggplot(subset(df, method %in% c('ps.ebw', 'vs.ebw') & measure %in% c('H1A1c', 'H1A2c', 'H1A3c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales='free_x') + ylim(-10,50) + ggtitle("VoiceSauce vs. PraatSauce corrected harmonic amplitude differences, estimated bandwidths, H1*-A1*, A2*, A3*")

ggplot(subset(df, method %in% c('ps.fbw', 'vs.fbw') & measure %in% c('H1A1c', 'H1A2c', 'H1A3c')), aes(t_ms, value, colour=measure, linetype=method, group=interaction(method,measure,script))) + geom_line() + facet_wrap(~Filename, scales='free_x') + ggtitle("VoiceSauce vs. PraatSauce corrected harmonic amplitude differences, formula bandwidths, H1*-A1*, A2*, A3*")
## again, estimated BW reduces amplitudes more for both methods

## the general ramp-up of VS measures is likely due to the
## peculiar property of Matlab's filter() function

#############################
## CPP
#############################

ggplot(subset(df, method %in% c('vs.fbw', 'ps.fbw') & measure %in% c('CPP')), aes(t_ms, value, group=method, colour=method, linetype=method)) + geom_line() + facet_wrap(~Filename, scales='free_x') + ggtitle("Cepstral peak prominence")
## OK if smoothed

#############################
## HNR
#############################

ggplot(subset(df, value>-10 & method %in% c('vs.fbw', 'ps.fbw') & measure %in% c('HNR05', 'HNR15')), aes(t_ms, value, group=interaction(measure,method), colour=measure, linetype=method)) + geom_line() + facet_wrap(~Filename, scales='free_x') + ggtitle("Praat bandwidths, corrected vs. uncorrected")
## again the Praat estimates differ in amplitude - here lower than VS
