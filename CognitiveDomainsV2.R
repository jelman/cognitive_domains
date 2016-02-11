library(sjmisc)
library(dplyr)
library(psych)

# Load vetsa 2 merged data
vetsa2Dat = read_sas("K:/data/VETSA2_April2015/vetsa2merged_1dec2015_edits.sas7bdat")

##########################################
# Replace missing data and trim outliers #
##########################################

#------------------#
# Processing Speed #
#------------------#

## Stroop ##
vetsa2Dat$strcraw_V2[which(vetsa2Dat$ZSTROOPC_v2=="2")] = NA
vetsa2Dat$strwraw_V2[which(vetsa2Dat$ZSTROOPW_v2=="2")] = NA

## Trails ##
vetsa2Dat$TRL2T_v2[which(vetsa2Dat$ZTRAIL2_v2=="2")] = NA
vetsa2Dat$TRL3T_v2[which(vetsa2Dat$ZTRAIL3_v2=="2")] = NA

vetsa2Dat$TRL2T_v2[which(vetsa2Dat$TRL2T_v2>120)] = NA
vetsa2Dat$TRL3T_v2[which(vetsa2Dat$TRL3T_v2>120)] = NA

# Log Transformed Trails
vetsa2Dat$TRL2TRAN_v2 = -1*log(vetsa2Dat$TRL2T_v2)
vetsa2Dat$TRL3TRAN_v2 = -1*log(vetsa2Dat$TRL3T_v2)

#---------------------#
# Visual-Spatial Data #
#---------------------#

## Mental Rotation ##

# VETSA2 MENTAL ROTATION: Total Correct PART1
vetsa2Dat$MR1COR_v2[which(vetsa2Dat$ZMENROT_v2==2)] = NA

hfCols = c("HFIGC1_v2","HFIGC3_v2","HFIGC5_v2")
vetsa2Dat[which(vetsa2Dat$ZHF_v2==2), hfCols] = NA

# VETSA2 Hidden Figures Total Correct Parts 1,3,5
vetsa2Dat$HFTOTCOR_V2 = rowSums(vetsa2Dat[hfCols])

#--------------------#
# Abstract Reasoning #
#--------------------#

vetsa2Dat$MTXRAW_v2[which(vetsa2Dat$ZMATRIX_v2=="2")] = NA
vetsa2Dat$MTXRAW_v2[which(vetsa2Dat$MTXRAW_v2=="0")] = NA

# Square-root transformed MTXRAW_v2
vetsa2Dat$MTXTRAN_v2 = -1*sqrt(36 - vetsa2Dat$MTXRAW_v2)

#-------------------------------#
# Short Term and Working Memory #
#-------------------------------#

## Digit Span ##
vetsa2Dat$dsfraw_V2[which(vetsa2Dat$ZDGSPNF_v2=="2")] = NA
vetsa2Dat$dsbraw_V2[which(vetsa2Dat$ZDGSPNB_v2=="2")] = NA

## Letter-Number Sequencing ##
vetsa2Dat$lntot_V2[which(vetsa2Dat$ZLNS_v2=="2")] = NA
vetsa2Dat$lntot_V2[which(vetsa2Dat$lntot_V2=="0")] = NA

## Spatial Span ##
vetsa2Dat$sspfraw_V2[which(vetsa2Dat$ZSPSPNF_v2=="2")] = NA
vetsa2Dat$sspbraw_V2[which(vetsa2Dat$ZSPSPNB_v2=="2")] = NA

## Reading Span ##
vetsa2Dat$RSATOT_V2[which(vetsa2Dat$ZRDSPNA_v2=="2")] = NA

# Square-root Transformed Reading Span
vetsa2Dat$RSATOTTRAN_V2 = -1*sqrt(46 - vetsa2Dat$RSATOT_V2)

#-----------------#
# Episodic Memory #
#-----------------#

## CVLT ##
cvltiCols = c("cvatot_v2","CVSDFR_v2")
vetsa2Dat[which(vetsa2Dat$ZCVLTI_v2=="2"), cvltiCols] = NA

vetsa2Dat$CVLDFR_v2[which(vetsa2Dat$ZCVLTD_v2=="2")] = NA
vetsa2Dat$cvatot_v2[which(vetsa2Dat$cva5raw_v2=="0")] = NA

cvltfrCols = c("CVSDFR_v2","CVLDFR_v2")
vetsa2Dat[which(vetsa2Dat$cvatot_v2=="0"), cvltfrCols] = NA

## Logical Memory ##

logmemCols = c("lmitot_V2","lmdtot_V2")
vetsa2Dat[which(vetsa2Dat$ZLMI_v2=="2"), logmemCols] = NA

vetsa2Dat$lmdtot_V2[which(vetsa2Dat$ZLMD_v2=="2")] = NA
vetsa2Dat$lmdtot_V2[is.na(vetsa2Dat$lmitot_V2)] = NA

## Visual Reproduction ##

vrCols = c("vritot_V2","vrdtot_V2")
vetsa2Dat[which(vetsa2Dat$ZVRI_v2=="2"), vrCols] = NA

vetsa2Dat$vrdtot_V2[which(vetsa2Dat$ZVRD_v2=="2")] = NA
vetsa2Dat$vrdtot_V2[is.na(vetsa2Dat$vritot_V2)] = NA

#--------------------#
# Executive Function #
#--------------------#

## Trails Condition 4 ##

vetsa2Dat$TRL4T_v2[which(vetsa2Dat$ZTRAIL4_v2=="2")] = NA
vetsa2Dat$TRL4T_v2[is.na(vetsa2Dat$TRL2T_v2)] = NA
vetsa2Dat$TRL4T_v2[is.na(vetsa2Dat$TRL3T_v2)] = NA

# VETSA2 Trails 4 Adjusted for Trails 2&3
vetsa2Dat$TRL4TADJ_v2 = with(vetsa2Dat, 
                        (TRL4T_v2 - (TRL2T_v2*0.7623) + (TRL3T_v2*1.3343)))
# VETSA2 SQRT-Transformed Trails 4 Adjusted
vetsa2Dat$TRL4ADJTRAN_v2 = -1*sqrt(80 + vetsa2Dat$TRL4TADJ_v2)

## Category Fluency Switching ##
vetsa2Dat$CFCOR_V2[which(vetsa2Dat$ZFLUC_v2=="2")] = NA
vetsa2Dat$CSSACC_v2[which(vetsa2Dat$ZFLUCS_v2=="2")] = NA

# VETSA2 Category Switching Accuracy - Adjusted
vetsa2Dat$CSSACCADJ_v2 = vetsa2Dat$CSSACC_v2 - (0 + (vetsa2Dat$CFCOR_V2*0.1400))

## Stroop ##
vetsa2Dat$strit_V2[which(vetsa2Dat$strit_V2=="1")] = NA
vetsa2Dat$strit_V2[which(vetsa2Dat$strit_V2>90)] = NA

vetsa2Dat$strcwraw_V2[which(vetsa2Dat$ZSTROOPCW_v2=="2") ] = NA
vetsa2Dat$strcwraw_V2[is.na(vetsa2Dat$strwraw_V2)] = NA
vetsa2Dat$strcwraw_V2[is.na(vetsa2Dat$strcraw_V2)] = NA

# VETSA2 Stroop Color/Word Adjusted
vetsa2Dat$strcwadj_v2 = with(vetsa2Dat, 
                    strcwraw_V2 - (0 + (strwraw_V2*0.1390) + (strcraw_V2*0.3269)))

## Verbal Fluency ##

vetsa2Dat$LFCOR_V2[which(vetsa2Dat$ZFLUL_v2=="2")] = NA
vetsa2Dat$CFCOR_V2[which(vetsa2Dat$ZFLUC_v2=="2")] = NA


#########################################################
# Creating standardized scores and composite scores.    #
# Satandardization is based off of VETSA1 Means and SDs #
#########################################################

# Standardized MR1COR_v2
vetsa2Dat$zMR1COR_v2 = (vetsa2Dat$MR1COR_v2 - 47.5498) / 13.4463

# Standardized HFTOTCOR_v2
vetsa2Dat$zHFTOTCOR_v2 = (vetsa2Dat$HFTOTCOR_V2 - 21.2055) / 9.0907

# VETSA2 Visual-Spatial Ability
vetsa2Dat$zVisSpat_v2 = rowMeans(vetsa2Dat[c("zMR1COR_v2","zHFTOTCOR_v2")])

# VETSA2 Abstract Reasoning
vetsa2Dat$zAbsReason_v2 = (vetsa2Dat$MTXTRAN_v2 - (-3.5041)) / 0.7799

vetsa2Dat$zdsfraw_v2 = (vetsa2Dat$dsfraw_V2 - 10.1910)/2.2851
vetsa2Dat$zdsbraw_v2 = (vetsa2Dat$dsbraw_V2 - 6.5109)/2.1673
vetsa2Dat$zlntot_v2 = (vetsa2Dat$lntot_V2 - 10.1434)/2.3546
vetsa2Dat$zsspfraw_v2 = (vetsa2Dat$sspfraw_V2 - 8.0273)/1.6550
vetsa2Dat$zsspbraw_v2 = (vetsa2Dat$sspbraw_V2 - 7.4063)/1.8013
# Standardized/Transformed Reading Span
vetsa2Dat$zrsatottran_v2 = (vetsa2Dat$RSATOTTRAN_V2 - (-3.2157))/0.7699 

# VETSA2 Working Memory
vetsa2Dat$zSTWKMem_v2 = rowMeans(vetsa2Dat[,c("zdsfraw_v2","zdsbraw_v2",
                                              "zlntot_v2","zsspfraw_v2",
                                              "zsspbraw_v2","zrsatottran_v2")])

vetsa2Dat$zcvatot_v2 = (vetsa2Dat$cvatot_v2 - 42.8466)/8.5101
vetsa2Dat$zcvsdfr_v2 = (vetsa2Dat$CVSDFR_v2 - 8.6420)/2.7382 
vetsa2Dat$zcvldfr_v2 = (vetsa2Dat$CVLDFR_v2 - 9.0669)/2.8865 
vetsa2Dat$zlmitot_v2 = (vetsa2Dat$lmitot_V2 - 23.4731)/6.1563
vetsa2Dat$zlmdtot_v2 = (vetsa2Dat$lmdtot_V2 - 20.0125)/6.6278
vetsa2Dat$zvritot_v2 = (vetsa2Dat$vritot_V2 - 78.2430)/12.4047
vetsa2Dat$zvrdtot_v2 = (vetsa2Dat$vrdtot_V2 - 54.7521)/19.5090
#VETSA2 Episodic Memory
vetsa2Dat$zEpsMem_v2 = rowMeans(vetsa2Dat[,c("zcvatot_v2","zcvsdfr_v2",
                                             "zcvldfr_v2","zlmitot_v2",
                                             "zlmdtot_v2","zvritot_v2",
                                             "zvrdtot_v2")])

vetsa2Dat$zlfcor_v2 = (vetsa2Dat$LFCOR_V2 - 36.8792)/10.6089
vetsa2Dat$zcfcor_v2 = (vetsa2Dat$CFCOR_V2 - 38.2818)/7.5251 
# VETSA2 Verbal Fluency
vetsa2Dat$zVerbFlu_v2 = rowMeans(vetsa2Dat[,c("zlfcor_v2","zcfcor_v2")])


vetsa2Dat$zstrwraw_v2 = (vetsa2Dat$strwraw_V2 - 93.4668)/14.3125
vetsa2Dat$zstrcraw_v2 = (vetsa2Dat$strcraw_V2 - 69.2195)/11.3414
vetsa2Dat$ztrl2tran_v2 = (vetsa2Dat$TRL2TRAN_v2 - (-3.4530))/0.3138
vetsa2Dat$ztrl3tran_v2 = (vetsa2Dat$TRL3TRAN_v2 - (-3.4520))/0.3274
vetsa2Dat$ztrl4tran_v2 = (vetsa2Dat$TRL4ADJTRAN_v2 - (-10.3190))/1.2969
# VETSA2 Processing Speed
vetsa2Dat$zProcSpeed_v2 = rowMeans(vetsa2Dat[,c("zstrwraw_v2","zstrcraw_v2",
                                            "ztrl2tran_v2","ztrl3tran_v2")])

# VETSA2 Executive Functioning - Trails Switching
vetsa2Dat$zExecTrailsSwitch_v2 = vetsa2Dat$ztrl4tran_v2 

# VETSA2 Executive Functioning - Category Switching
vetsa2Dat$zExecCategorySwitch_v2 = (vetsa2Dat$CSSACCADJ_v2 - 6.4447)/2.8568

# VETSA2 Executive Functioing - Inhibition
vetsa2Dat$zExecInhibit_v2 = (vetsa2Dat$strit_V2 - 47.1756)/6.8088 


#-------------------#
#  Save out datset  #
#-------------------#

# Select cognitive domain variables
vetsa2CogDomains = vetsa2Dat %>%
  dplyr::select(vetsaid,zVisSpat_v2,zMR1COR_v2,zHFTOTCOR_v2,zSTWKMem_v2,
                zdsfraw_v2,zdsbraw_v2,zlntot_v2,zsspfraw_v2,zsspbraw_v2,
                zrsatottran_v2,zEpsMem_v2,zcvatot_v2,zcvsdfr_v2,zcvldfr_v2,
                zlmitot_v2,zlmdtot_v2,zvritot_v2,zvrdtot_v2,zAbsReason_v2,
                zVerbFlu_v2,zlfcor_v2,zcfcor_v2,zExecTrailsSwitch_v2,
                zExecCategorySwitch_v2,zExecInhibit_v2,zProcSpeed_v2,
                zstrwraw_v2,zstrcraw_v2,ztrl2tran_v2,ztrl3tran_v2,ztrl4tran_v2) 

# Save out data
write.csv(vetsa2CogDomains, 
          "K:/Projects/Cognitive Domains/data/V2_CognitiveDomains.csv",
          row.names = F)