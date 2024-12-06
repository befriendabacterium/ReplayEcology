##################################################
# remove_Choroplasts.R
##################################################
# In this script I read the OTU table and the list of
# ASVs classified as Chloroplasts and I remove them.
# Zürich, August 2022
# Theoretical Biology, ETH
# apascualgarcia.github.io

#This script was later edited by Matt Lloyd Jones to work 
# with new 'matchedandfiltered.csv' output of match_sets_and_filter
# and output the final _readyforanalysis suffixed files
# without overwriting anything, to enable better tracking of reads
# through objects in the pipeline


###################################################

this.dir=strsplit(rstudioapi::getActiveDocumentContext()$path, "/src/")[[1]][1]
dirSrc=paste(this.dir,"/src/",sep="") # Directory where the code is
#dirSrc=here::here() # src of the repository
setwd(dirSrc)

setwd("../6_finalfiles")

# --- Read taxa table
filetaxa="taxa_wsp_matchedandfiltered.csv"
taxa.table=read.table(filetaxa,sep="\t", header = 1)

# --- Read ASVs table

fileOTU="seqtable_matchedandfiltered.csv"
ASV.table=read.table(fileOTU,sep="\t")
dim(ASV.table)
ASV.table=as.matrix(ASV.table)
colnames(ASV.table)[1:5]
rownames(ASV.table)[1:5]

fileOTU="seqtable_matchedandfiltered.allsam.csv"
ASV.table.all=read.table(fileOTU,sep="\t")
dim(ASV.table.all)
ASV.table.all=as.matrix(ASV.table.all)
colnames(ASV.table.all)[1:5]
rownames(ASV.table.all)[1:5]

# --- Read list  of Chloroplasts
fileChloro="ASVs_Chloroplasts.list"
ASV.chloro=read.table(fileChloro)
dim(ASV.chloro)

# --- Remove them from the table
matched=match(colnames(ASV.table),ASV.chloro$V1)
ASV.table.clean=ASV.table[,is.na(matched)]
ASV.table.clean.all = ASV.table.all[,is.na(matched)]
dim(ASV.table.clean)

# --- Read list  of Mitochondria
fileMito="ASVs_Mitochondria.list"
ASV.mito=read.table(fileMito)
dim(ASV.mito)

# --- Remove them from the table
matched=match(colnames(ASV.table.clean),ASV.mito$V1)
ASV.table.clean=ASV.table.clean[,is.na(matched)]
ASV.table.clean.all = ASV.table.all[,is.na(matched)]
dim(ASV.table.clean)

# --- Write final ASV table
fileOTU="seqtable_readyforanalysis.csv"
write.table(ASV.table.clean,file=fileOTU,quote=FALSE,sep="\t")

fileOTUt="seqtable_readyforanalysis.t.csv"
write.table(t(ASV.table.clean),file=fileOTUt,quote=FALSE,sep="\t")

fileOTU="seqtable_readyforanalysis.allsam.csv"
write.table(ASV.table.clean.all,file=fileOTU,quote=FALSE,sep="\t")

fileOTUt="seqtable_readyforanalysis.allsam.t.csv"
write.table(t(ASV.table.clean.all),file=fileOTUt,quote=FALSE,sep="\t")

# --- Write final taxa table

#match ASVs in final ASV table to those in taxa table
matched=match(taxa.table$ASV_names, colnames(ASV.table.clean))
#remove non-matches to get final taxa table
taxa.table.clean=taxa.table[!is.na(matched),]

filetaxa="taxa_wsp_readyforanalysis.csv"
write.table(taxa.table.clean,file=filetaxa,quote=FALSE,sep="\t", row.names = F)


