##########################################
#  extract_subset.R
##########################################
# This function extracts for a given ASV
# table a subset of the table determined by a vector of
# factor levels present in a samples' metadata file.
# INPUT
#    ASV.table = A ASV table, with ASV in columns and samples in rows
#    sample.md = A df with samples' metadata
#    factor.vec = A char vector with the factors that should be
#        considered to extract the subset of samples
#    level.vec = A char vector with the level that should be
#        considered for each factor in factor.vec to
#        subset samples. Levels should be given in the
#        same order than factors (i.e. both vectors are paired).
#    sample.id = A string with the name of the column where the
#        names of the samples are found in the metadata table
#    split.mode = A string defining the type of subset that the
#        function should perform:
#         "AND" : The final subset has all the pairs (factor, level)
#                 included in the strings (default)
#         "OR"  : The final subset has any of the pairs (factor, level)
#                 included in the strings.
# OUTPUT
#    A ASV table with the desired samples.
########################################
# author = apascualgarcia.github.io
# date = Dec 6th, 2022. ETH-Zürich
##########################################

extract_subset = function(ASV.table, sample.md = data.frame(), 
                            factor.vec = c(), level.vec = c(),
                            sample.id = c(), split.mode = "AND"){
  #browser()
  if(dim(sample.md)[1] != 0){ # subset
    Nfact = length(factor.vec)
    Nlev = length(level.vec)
    Nsamp = length(sample.md[, sample.id])
    if((Nfact == 0) | (Nlev == 0)){
      mes = "paired vectors of factors and their levels are needed to subset"
      stop(mes)
    }else if(Nfact !=  Nlev){
      mes = "the number of factors and levels must be the same (vectors must be paired)"
      stop(mes) 
    }else if(Nsamp == 0){
      mes = "the name of the column where the samples should be found must be provided"
      stop(mes)
    }
    if(split.mode == "AND"){
      sample.md.tmp = sample.md
    }
    i=0
    for(fact in factor.vec){
      i=i+1
      level = level.vec[i]
      if(split.mode == "OR"){
        id.extract = which(sample.md[, fact] == level)
        if(i == 1){
          sample.md.tmp = sample.md[id.extract, ]
        }else{
          sample.md.tmp = rbind(sample.md.tmp, sample.md[id.extract, ])
        }
      }else{ # default, split.mode == AND
        id.extract = which(sample.md.tmp[, fact] == level)
        sample.md.tmp = sample.md.tmp[id.extract, ]
      }

    }
    samples = as.character(sample.md.tmp[, sample.id])
    ASV.sub = ASV.table[samples, ]
  }else{ # do nothing
    ASV.sub = ASV.table
  }
  # remove unseen ASVs
  ASV.sub = ASV.sub[,which(colSums(ASV.sub) > 0)]
  return(ASV.sub)
}