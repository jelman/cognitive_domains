################################################################################
# Calculates cognitive domains for VETSA 1.                                    #
#                                                                              #
# Based on syntax files in:                                                    #
# M:/PSYCH/KREMEN/VETSA DATA FILES_852014/Cognitive Domains_April 2015 syntax/ #
#                                                                              #
# Individual tests from each domain are filtered based on quality              #
# score ("z" rating). Tests scores are then standardized based on              #
# VETSA 1 means and standard deviations. The composite score is                #
# calculated as the mean of standardized test scores within each domain.       #
#                                                                              #
# Note: The mean of z-scored tests is not itself a z-score. Domain comprised   #
# of multiple tests may have an SD less than 1. Therefore, domains are further #
# standardized based on VETSA 1 means and SDs                                  #
################################################################################


library(sjmisc)
library(dplyr)
library(psych)

# Load vetsa 1 merged data
vetsa1Dat = read_sas("/home/jelman/netshare/K/data/VETSA1_Aug2014/vetsa1merged_25aug2015_nomiss.sas7bdat")

# Convert to dataframe to avoid problems with attributes and labels later
vetsa1Dat = tbl_df(vetsa1Dat)

##########################################
# Replace missing data and trim outliers #
##########################################

#----------------#
# Verbal Ability #
#----------------#

vetsa1Dat$VOCRAW[which(vetsa1Dat$ZVOCAB=="2")] = NA
# Transformed VOCRAW
vetsa1Dat$voctran = -1 * sqrt(80-vetsa1Dat$VOCRAW)

#---------------------#
# Visual-Spatial Data #
#---------------------#

## Mental Rotation ##

# vetsa1 MENTAL ROTATION: Total Correct PART1
vetsa1Dat$MR1COR[which(vetsa1Dat$ZMENROT==2)] = NA
vetsa1Dat$MR2COR[which(vetsa1Dat$ZMENROT==2)] = NA
# MENTAL ROTATION: Total Correct PARTS 1&2
vetsa1Dat$MRTOTCOR= vetsa1Dat$MR1COR + vetsa1Dat$MR2COR

hfCols = c("HFIGC1","HFIGC3","HFIGC5")
vetsa1Dat[which(vetsa1Dat$ZHF==2), hfCols] = NA

# vetsa1 Hidden Figures Total Correct Parts 1,3,5
vetsa1Dat$HFTOTCOR = rowSums(vetsa1Dat[hfCols])

#--------------------#
# Abstract Reasoning #
#--------------------#

vetsa1Dat$MTXRAW[which(vetsa1Dat$ZMATRIX=="2")] = NA
vetsa1Dat$MTXRAW[which(vetsa1Dat$MTXRAW=="0")] = NA

# Square-root transformed MTXRAW
vetsa1Dat$MTXTRAN = -1*sqrt(36 - vetsa1Dat$MTXRAW)


#-------------------------------#
# Short Term and Working Memory #
#-------------------------------#

## Digit Span ##
vetsa1Dat$dsfraw[which(vetsa1Dat$ZDGSPNF=="2")] = NA
vetsa1Dat$dsbraw[which(vetsa1Dat$ZDGSPNB=="2")] = NA

## Letter-Number Sequencing ##
vetsa1Dat$lntot[which(vetsa1Dat$ZLNS=="2")] = NA
vetsa1Dat$lntot[which(vetsa1Dat$lntot=="0")] = NA

## Spatial Span ##
vetsa1Dat$sspfraw[which(vetsa1Dat$ZSPSPNF=="2")] = NA
vetsa1Dat$sspbraw[which(vetsa1Dat$ZSPSPNB=="2")] = NA

## Reading Span ##
vetsa1Dat$RSATOTrev[which(vetsa1Dat$ZRDSPNA=="2")] = NA

# Square-root Transformed Reading Span
vetsa1Dat$RSATOTrevtran = -1*sqrt(46 - vetsa1Dat$RSATOTrev)

#-----------------#
# Episodic Memory #
#-----------------#

## CVLT ##
cvltiCols = c("cvatot","CVSDFR")
vetsa1Dat[which(vetsa1Dat$ZCVLTI=="2"), cvltiCols] = NA

vetsa1Dat$CVLDFR[which(vetsa1Dat$ZCVLTD=="2")] = NA
vetsa1Dat$cvatot[which(vetsa1Dat$cva5raw=="0")] = NA

cvltfrCols = c("CVSDFR","CVLDFR")
vetsa1Dat[which(vetsa1Dat$cvatot=="0"), cvltfrCols] = NA

## Logical Memory ##

logmemCols = c("lmitot","lmdtot")
vetsa1Dat[which(vetsa1Dat$ZLMI=="2"), logmemCols] = NA

vetsa1Dat$lmdtot[which(vetsa1Dat$ZLMD=="2")] = NA
vetsa1Dat$lmdtot[is.na(vetsa1Dat$lmitot)] = NA

## Visual Reproduction ##

vrCols = c("vritot","vrdtot")
vetsa1Dat[which(vetsa1Dat$ZVRI=="2"), vrCols] = NA

vetsa1Dat$vrdtot[which(vetsa1Dat$ZVRD=="2")] = NA
vetsa1Dat$vrdtot[is.na(vetsa1Dat$vritot)] = NA

#--------------------#
# Executive Function #
#--------------------#

## Trails Condition 4 ##

vetsa1Dat$TRL4T[which(vetsa1Dat$ZTRAIL4=="2")] = NA
vetsa1Dat$TRL4T[is.na(vetsa1Dat$TRL2T)] = NA
vetsa1Dat$TRL4T[is.na(vetsa1Dat$TRL3T)] = NA

# vetsa1 Trails 4 Adjusted for Trails 2&3
vetsa1Dat$TRL4TADJ = with(vetsa1Dat, 
                             (TRL4T - (TRL2T*0.7752) + (TRL3T*1.0438)))
# vetsa1 SQRT-Transformed Trails 4 Adjusted
vetsa1Dat$TRL4ADJTRAN = -1*sqrt(80 + vetsa1Dat$TRL4TADJ)

## Category Fluency Switching ##
vetsa1Dat$CFCOR[which(vetsa1Dat$ZFLUC=="2")] = NA
vetsa1Dat$CSSACC[which(vetsa1Dat$ZFLUCS=="2")] = NA

# vetsa1 Category Switching Accuracy - Adjusted
vetsa1Dat$CSSACCADJ = vetsa1Dat$CSSACC - (0 + (vetsa1Dat$CFCOR*0.1329))

## Stroop ##
vetsa1Dat$STRIT [which(vetsa1Dat$STRIT=="1")] = NA
vetsa1Dat$STRIT[which(vetsa1Dat$STRIT>90)] = NA

vetsa1Dat$strcwraw[which(vetsa1Dat$ZSTROOPCW=="2") ] = NA
vetsa1Dat$strcwraw[is.na(vetsa1Dat$strwraw)] = NA
vetsa1Dat$strcwraw[is.na(vetsa1Dat$strcraw)] = NA

vetsa1Dat[which(vetsa1Dat$vetsaid=="19885B"),"strcraw"] = 86
vetsa1Dat[which(vetsa1Dat$vetsaid=="19885B"),"strcwraw"] = 45

#----------------#
# Verbal Fluency #
#----------------#

vetsa1Dat$LFCOR[which(vetsa1Dat$ZFLUL=="2")] = NA
vetsa1Dat$CFCOR[which(vetsa1Dat$ZFLUC=="2")] = NA

#------------------#
# Processing Speed #
#------------------#

## Stroop ##
vetsa1Dat$strcraw[which(vetsa1Dat$ZSTROOPC=="2")] = NA
vetsa1Dat$strwraw[which(vetsa1Dat$ZSTROOPW=="2")] = NA

## Trails ##
vetsa1Dat$TRL2T[which(vetsa1Dat$ZTRAIL2=="2")] = NA
vetsa1Dat$TRL3T[which(vetsa1Dat$ZTRAIL3=="2")] = NA

vetsa1Dat$TRL2T[which(vetsa1Dat$TRL2T>120)] = NA
vetsa1Dat$TRL3T[which(vetsa1Dat$TRL3T>120)] = NA

# Log Transformed Trails
vetsa1Dat$TRL2TRAN = -1*log(vetsa1Dat$TRL2T)
vetsa1Dat$TRL3TRAN = -1*log(vetsa1Dat$TRL3T)


#########################################################
# Creating standardized scores and composite scores.    #
# Standardization is based off of VETSA1 Means and SDs  #
#########################################################

## Create function to save mean and SD of all variables ##
addScaleVals = function(df,varname, x) {
  meanVal = attr(x, which="scaled:center")
  sdVal = attr(x, which="scaled:scale")
  rbind(df, data.frame(Variable=varname, Mean=meanVal, SD=sdVal))
}

## Initialize dataframe to hold means and SDs # #
scaleValues = data.frame()


# Vetsa1 Verbal Ability 
vetsa1Dat$zvoctran = scale(vetsa1Dat$voctran)
scaleValues = addScaleVals(scaleValues, "voctran", vetsa1Dat$zvoctran)

vetsa1Dat$Verbal = vetsa1Dat$zvoctran
vetsa1Dat$zVerbal = scale(vetsa1Dat$Verbal)
scaleValues = addScaleVals(scaleValues, "Verbal", vetsa1Dat$zVerbal)

# vetsa1 Visual-Spatial Ability 
vetsa1Dat$zMR1COR = scale(vetsa1Dat$MR1COR)
scaleValues = addScaleVals(scaleValues, "MR1COR", vetsa1Dat$zMR1COR)
vetsa1Dat$zHFTOTCOR = scale(vetsa1Dat$HFTOTCOR)
scaleValues = addScaleVals(scaleValues, "HFTOTCOR", vetsa1Dat$zHFTOTCOR)

vetsa1Dat$VisSpat = rowMeans(vetsa1Dat[c("zMR1COR","zHFTOTCOR")])
vetsa1Dat$zVisSpat = scale(vetsa1Dat$VisSpat)
scaleValues = addScaleVals(scaleValues, "VisSpat", vetsa1Dat$zVisSpat)

# vetsa1 Abstract Reasoning 
vetsa1Dat$zMTXTRAN = scale(vetsa1Dat$MTXTRAN)
scaleValues = addScaleVals(scaleValues, "MTXTRAN", vetsa1Dat$zMTXTRAN)

vetsa1Dat$AbsReason = as.numeric(vetsa1Dat$zMTXTRAN)
vetsa1Dat$zAbsReason = scale(vetsa1Dat$AbsReason)
scaleValues = addScaleVals(scaleValues, "AbsReason", vetsa1Dat$zAbsReason)

# Vetsa1 Working Memory 
vetsa1Dat$zdsfraw = scale(vetsa1Dat$dsfraw)
scaleValues = addScaleVals(scaleValues, "dsfraw", vetsa1Dat$zdsfraw)
vetsa1Dat$zdsbraw = scale(vetsa1Dat$dsbraw)
scaleValues = addScaleVals(scaleValues, "dsbraw", vetsa1Dat$zdsbraw)
vetsa1Dat$zlntot = scale(vetsa1Dat$lntot)
scaleValues = addScaleVals(scaleValues, "lntot", vetsa1Dat$zlntot)
vetsa1Dat$zsspfraw = scale(vetsa1Dat$sspfraw)
scaleValues = addScaleVals(scaleValues, "sspfraw", vetsa1Dat$zsspfraw)
vetsa1Dat$zsspbraw = scale(vetsa1Dat$sspbraw)
scaleValues = addScaleVals(scaleValues, "sspbraw", vetsa1Dat$zsspbraw)
vetsa1Dat$zrsatotrevtran = scale(vetsa1Dat$RSATOTrevtran) 
scaleValues = addScaleVals(scaleValues, "RSATOTrevtran", vetsa1Dat$zrsatotrevtran)

vetsa1Dat$STWKMem = rowMeans(vetsa1Dat[,c("zdsfraw","zdsbraw",
                                              "zlntot","zsspfraw",
                                              "zsspbraw","zrsatotrevtran")])
vetsa1Dat$zSTWKMem = scale(vetsa1Dat$STWKMem)
scaleValues = addScaleVals(scaleValues, "STWKMem", vetsa1Dat$zSTWKMem)

# vetsa1 Episodic Memory 
vetsa1Dat$zcvatot = scale(vetsa1Dat$cvatot)
scaleValues = addScaleVals(scaleValues, "cvatot", vetsa1Dat$zcvatot)
vetsa1Dat$zcvsdfr = scale(vetsa1Dat$CVSDFR)
scaleValues = addScaleVals(scaleValues, "CVSDFR", vetsa1Dat$zcvsdfr)
vetsa1Dat$zcvldfr = scale(vetsa1Dat$CVLDFR)
scaleValues = addScaleVals(scaleValues, "CVLDFR", vetsa1Dat$zcvldfr)
vetsa1Dat$zlmitot = scale(vetsa1Dat$lmitot)
scaleValues = addScaleVals(scaleValues, "lmitot", vetsa1Dat$zlmitot)
vetsa1Dat$zlmdtot = scale(vetsa1Dat$lmdtot)
scaleValues = addScaleVals(scaleValues, "lmdtot", vetsa1Dat$zlmdtot)
vetsa1Dat$zvritot = scale(vetsa1Dat$vritot)
scaleValues = addScaleVals(scaleValues, "vritot", vetsa1Dat$zvritot)
vetsa1Dat$zvrdtot = scale(vetsa1Dat$vrdtot)
scaleValues = addScaleVals(scaleValues, "vrdtot", vetsa1Dat$zvrdtot)

vetsa1Dat$EpsMem = rowMeans(vetsa1Dat[,c("zcvatot","zcvsdfr",
                                             "zcvldfr","zlmitot",
                                             "zlmdtot","zvritot",
                                             "zvrdtot")])
vetsa1Dat$zEpsMem = scale(vetsa1Dat$EpsMem)
scaleValues = addScaleVals(scaleValues, "EpsMem", vetsa1Dat$zEpsMem)

# Vetsa1 Verbal Fluency 
vetsa1Dat$zlfcor = scale(vetsa1Dat$LFCOR)
scaleValues = addScaleVals(scaleValues, "LFCOR", vetsa1Dat$zlfcor)
vetsa1Dat$zcfcor = scale(vetsa1Dat$CFCOR)
scaleValues = addScaleVals(scaleValues, "CFCOR", vetsa1Dat$zcfcor)

vetsa1Dat$VerbFlu = rowMeans(vetsa1Dat[,c("zlfcor","zcfcor")])
vetsa1Dat$zVerbFlu = scale(vetsa1Dat$VerbFlu)
scaleValues = addScaleVals(scaleValues, "VerbFlu", vetsa1Dat$zVerbFlu)

# Vetsa1 Processing Speed
vetsa1Dat$zstrwraw = scale(vetsa1Dat$strwraw)
scaleValues = addScaleVals(scaleValues, "strwraw", vetsa1Dat$zstrwraw)
vetsa1Dat$zstrcraw = scale(vetsa1Dat$strcraw)
scaleValues = addScaleVals(scaleValues, "strcraw", vetsa1Dat$zstrcraw)
vetsa1Dat$ztrl2tran = scale(vetsa1Dat$TRL2TRAN)
scaleValues = addScaleVals(scaleValues, "TRL2TRAN", vetsa1Dat$ztrl2tran)
vetsa1Dat$ztrl3tran = scale(vetsa1Dat$TRL3TRAN)
scaleValues = addScaleVals(scaleValues, "TRL3TRAN", vetsa1Dat$ztrl3tran)

vetsa1Dat$ProcSpeed = rowMeans(vetsa1Dat[,c("zstrwraw","zstrcraw",
                                                "ztrl2tran","ztrl3tran")],na.rm=T)
vetsa1Dat$zProcSpeed = scale(vetsa1Dat$ProcSpeed)
scaleValues = addScaleVals(scaleValues, "ProcSpeed", vetsa1Dat$zProcSpeed)

# Vetsa1 Executive Functioning - Trails Switching 
vetsa1Dat$ztrl4adjtran = scale(vetsa1Dat$TRL4ADJTRAN) 
scaleValues = addScaleVals(scaleValues, "TRL4ADJTRAN", vetsa1Dat$ztrl4adjtran)

vetsa1Dat$ExecTrailsSwitch = as.numeric(vetsa1Dat$ztrl4adjtran )
vetsa1Dat$zExecTrailsSwitch = scale(vetsa1Dat$ExecTrailsSwitch)
scaleValues = addScaleVals(scaleValues, "ExecTrailsSwitch", vetsa1Dat$zExecTrailsSwitch)

# vetsa1 Executive Functioning - Category Switching
vetsa1Dat$zCSSACCADJ = scale(vetsa1Dat$CSSACCADJ)
scaleValues = addScaleVals(scaleValues, "CSSACCADJ", vetsa1Dat$zCSSACCADJ)

vetsa1Dat$ExecCategorySwitch = as.numeric(vetsa1Dat$zCSSACCADJ)
vetsa1Dat$zExecCategorySwitch = scale(vetsa1Dat$ExecCategorySwitch)
scaleValues = addScaleVals(scaleValues, "ExecCategorySwitch", vetsa1Dat$zExecCategorySwitch)

# vetsa1 Executive Functioing - Inhibition
vetsa1Dat$zstrit = scale(vetsa1Dat$STRIT) 
scaleValues = addScaleVals(scaleValues, "strit", vetsa1Dat$zstrit)

vetsa1Dat$ExecInhibit = as.numeric(vetsa1Dat$zstrit)
vetsa1Dat$zExecInhibit = scale(vetsa1Dat$ExecInhibit)
scaleValues = addScaleVals(scaleValues, "ExecInhibit", vetsa1Dat$zExecInhibit)

#-------------------#
#  Save out datset  #
#-------------------#
zVars = c("zVerbal","zvoctran","zVisSpat","zMR1COR","zHFTOTCOR","zSTWKMem","zdsfraw",
          "zdsbraw","zlntot","zsspfraw","zsspbraw","zrsatotrevtran","zEpsMem",
          "zcvatot","zcvsdfr","zcvldfr","zlmitot","zlmdtot","zvritot","zvrdtot",
          "zAbsReason","zMTXTRAN","zVerbFlu","zlfcor","zcfcor","zExecTrailsSwitch",
          "ztrl4adjtran","zProcSpeed","zstrwraw","zstrcraw","ztrl2tran","ztrl3tran",
          "zExecCategorySwitch","zCSSACCADJ","zExecInhibit","zstrit")
rawVars = c("Verbal","voctran","VisSpat","MR1COR","STWKMem","HFTOTCOR","AbsReason","MTXTRAN",
            "dsfraw","dsbraw","lntot","sspfraw","sspbraw","RSATOTrevtran","EpsMem","cvatot",
            "CVSDFR","CVLDFR","lmitot","lmdtot","vritot","vrdtot","VerbFlu","LFCOR","CFCOR",
            "strwraw","strcraw","TRL2TRAN","TRL3TRAN","ExecTrailsSwitch","TRL4ADJTRAN",
            "ExecCategorySwitch","CSSACCADJ","ExecInhibit","STRIT")

# Select all cognitive domain variables
vetsa1CogDomainsAll = vetsa1Dat %>%
 dplyr::select(vetsaid,one_of(zVars,rawVars))

# Save out all data
write.csv(vetsa1CogDomainsAll,
         "/home/jelman/netshare/K/Projects/Cognitive Domains/data/V1_CognitiveDomains_All.csv",
         row.names = F)

# Select only z-scored variables
vetsa1CogDomainsZ = vetsa1Dat %>%
 dplyr::select(vetsaid,one_of(zVars))

# Save out z-scored data only
write.csv(vetsa1CogDomainsZ, 
          "/home/jelman/netshare/K/Projects/Cognitive Domains/data/V1_CognitiveDomains_Zscored.csv",
          row.names = F)

# Save out Means and SDs for use in scaling Vetsa 2 data
write.csv(scaleValues, 
          "/home/jelman/netshare/K/Projects/Cognitive Domains/data/V1_CognitiveDomains_Means_SDs.csv",
          row.names = F)
