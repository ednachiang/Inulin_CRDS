### x = your crds dataframe (with ALL your data)
bin.crds2 <- function(x){
  # Remove gavage timepoint
  crds <- x[complete.cases(x),]
  
  # Separate Inulin, Mannitol, and Saline
  inu <- crds[which(crds$Substrate == "Inulin"),]
  man <- crds[which(crds$Substrate == "Mannitol"),]
  sal <- crds[which(crds$Substrate == "Saline"),]
  
  # Make new col for BinTime
  inu$BinTime <- 0
  man$BinTime <- 0
  sal$BinTime <- 0
  
  # Pull out baselines
  inu.base <- inu[which(inu$RelTime < 0),]
  man.base <- man[which(man$RelTime < 0),]
  sal.base <- sal[which(sal$RelTime < 0),]
  
  # Calculate mean RelTime and add as new BinTime in each substrate's dataframe
  inu$BinTime[which(inu$RelTime < 0)] <- mean(inu.base$RelTime)
  man$BinTime[which(man$RelTime < 0)] <- mean(man.base$RelTime)
  sal$BinTime[which(sal$RelTime < 0)] <- mean(sal.base$RelTime)
  
  # Pull out post-gavage timepoints (a.k.a. experimental timepoints)
  inu.exp <- inu[which(inu$RelTime > 0),]
  man.exp <- man[which(man$RelTime > 0),]
  sal.exp <- sal[which(sal$RelTime > 0),]
  
  # Bin data into equally spaced bins; take mean of each bin to put into BinTime
  # Number of bins is based upon what I did previously (every 30 min)
  # ( = open
  # [ = closed
  # https://stackoverflow.com/questions/5915916/divide-a-range-of-values-in-bins-of-equal-length-cut-vs-cut2
  inu.exp$BinTime <- ave(inu.exp$RelTime, cut(inu.exp$RelTime, breaks=10), FUN=mean)
  man.exp$BinTime <- ave(man.exp$RelTime, cut(man.exp$RelTime, breaks=5), FUN=mean)
  sal.exp$BinTime <- ave(sal.exp$RelTime, cut(sal.exp$RelTime, breaks=7), FUN=mean)
  
  # Update BinTime in dataframe containing all substrate data
  for(i in 1:nrow(inu.exp)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:9], inu.exp[i,1:9])))] <- inu.exp$BinTime[i]
      # match_df goes through each row of inu.exp and finds the matching row in inu
      # Each row in inu has a unique rowname, so we take the rowname of the match_df and find that row in inu
        # Check unique rownames with sum(duplicated(rownames(inu)). If all rownames are unique, sum = 0
      # Now that we know which row in inu matches that of inu.exp, we replace inu$BinTime with inu.exp$BinTime
      # I repeat this for every row in inu.exp so each inu.exp$BinTime gets imported into inu$BinTime
  }
  for(i in 1:nrow(man.exp)) {
    man$BinTime[which(rownames(man) == rownames(match_df(man[,1:9], man.exp[i,1:9])))] <- man.exp$BinTime[i]
    # match_df goes through each row of man.exp and finds the matching row in man
    # Each row in man has a unique rowname, so we take the rowname of the match_df and find that row in man
      # Check unique rownames with sum(duplicated(rownames(man)). If all rownames are unique, sum = 0
    # Now that we know which row in man matches that of man.exp, we replace man$BinTime with man.exp$BinTime
    # I repeat this for every row in man.exp so each man.exp$BinTime gets imported into man$BinTime
  }
  for(i in 1:nrow(sal.exp)) {
    sal$BinTime[which(rownames(sal) == rownames(match_df(sal[,1:9], sal.exp[i,1:9])))] <- sal.exp$BinTime[i]
    # match_df goes through each row of sal.exp and finds the matching row in sal
    # Each row in sal has a unique rowname, so we take the rowname of the match_df and find that row in sal
    # Check unique rownames with sum(duplicated(rownames(sal)). If all rownames are unique, sum = 0
    # Now that we know which row in sal matches that of sal.exp, we replace sal$BinTime with sal.exp$BinTime
    # I repeat this for every row in sal.exp so each sal.exp$BinTime gets imported into sal$BinTime
  }
  
  output <- rbind(inu,man,sal)
  return(output)

  
}