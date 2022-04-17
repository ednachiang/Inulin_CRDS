### x = your crds dataframe (with ALL your data)
bin.crds <- function(x){
  # Remove gavage timepoint
  crds <- x[,-15]
    # Removes Ketones column due to NAs
  crds <- crds[complete.cases(crds),]
  
  # Separate Inulin, Mannitol, and Saline
  inu <- crds[which(crds$Substrate == "Inulin"),]
  sal <- crds[which(crds$Substrate == "Saline"),]
  
  # Make new col for BinTime
  inu$BinTime <- 0
  sal$BinTime <- 0
  
  # Pull out baselines
  inu.base <- inu[which(inu$RelTime < 0),]
  sal.base <- sal[which(sal$RelTime < 0),]
  
  # Calculate mean RelTime and add as new BinTime in each substrate's dataframe
  inu$BinTime[which(inu$RelTime < 0)] <- mean(inu.base$RelTime)
  sal$BinTime[which(sal$RelTime < 0)] <- mean(sal.base$RelTime)
  
  # Pull out post-gavage timepoints (a.k.a. experimental timepoints)
  inu.exp <- inu[which(inu$RelTime > 0),]
  sal.exp <- sal[which(sal$RelTime > 0),]
  
  
  # Separate data into Season + ABX groups
  inu.sum <- inu.exp[which(inu.exp$Season == "Summer"),]
  inu.sum.noabx <- inu.sum[which(inu.sum$Antibiotics == "No"),]
  inu.sum.abx <- inu.sum[which(inu.sum$Antibiotics == "Yes"),]
  inu.win <- inu.exp[which(inu.exp$Season == "Winter"),]
  inu.win.noabx <- inu.win[which(inu.win$Antibiotics == "No"),]
  inu.win.abx <- inu.win[which(inu.win$Antibiotics == "Yes"),]
  inu.spr <- inu.exp[which(inu.exp$Season == "Spring"),]
  inu.spr.noabx <- inu.spr[which(inu.spr$Antibiotics == "No"),]
  inu.spr.abx <- inu.spr[which(inu.spr$Antibiotics == "Yes"),]
  
  sal.sum <- sal.exp[which(sal.exp$Season == "Summer"),]
  sal.sum.noabx <- sal.sum[which(sal.sum$Antibiotics == "No"),]
  sal.sum.abx <- sal.sum[which(sal.sum$Antibiotics == "Yes"),]
  sal.win <- sal.exp[which(sal.exp$Season == "Winter"),]
  sal.win.noabx <- sal.win[which(sal.win$Antibiotics == "No"),]
  sal.win.abx <- sal.win[which(sal.win$Antibiotics == "Yes"),]
  sal.spr <- sal.exp[which(sal.exp$Season == "Spring"),]
  sal.spr.noabx <- sal.spr[which(sal.spr$Antibiotics == "No"),]
  sal.spr.abx <- sal.spr[which(sal.spr$Antibiotics == "Yes"),]
  
  
  # Bin data into equally spaced bins; Take mean of each bin to put into BinTime
  # Number of bins is based upon what I did previously (every 30 min) & ensures at least 3 data points per bin
  # Inulin = 9
  # Saline = 6
  # ( = open
  # [ = closed
  # https://stackoverflow.com/questions/5915916/divide-a-range-of-values-in-bins-of-equal-length-cut-vs-cut2
  inu.sum.noabx$BinTime <- ave(inu.sum.noabx$RelTime, cut(inu.sum.noabx$RelTime, breaks=9), FUN=mean)
  inu.sum.abx$BinTime <- ave(inu.sum.abx$RelTime, cut(inu.sum.abx$RelTime, breaks=9), FUN=mean)
  inu.win.noabx$BinTime <- ave(inu.win.noabx$RelTime, cut(inu.win.noabx$RelTime, breaks=9), FUN=mean)
  inu.win.abx$BinTime <- ave(inu.win.abx$RelTime, cut(inu.win.abx$RelTime, breaks=9), FUN=mean)
  inu.spr.noabx$BinTime <- ave(inu.spr.noabx$RelTime, cut(inu.spr.noabx$RelTime, breaks=9), FUN=mean)
  inu.spr.abx$BinTime <- ave(inu.spr.abx$RelTime, cut(inu.spr.abx$RelTime, breaks=9), FUN=mean)
  
  sal.sum.noabx$BinTime <- ave(sal.sum.noabx$RelTime, cut(sal.sum.noabx$RelTime, breaks=6), FUN=mean)
  sal.sum.abx$BinTime <- ave(sal.sum.abx$RelTime, cut(sal.sum.abx$RelTime, breaks=6), FUN=mean)
  sal.win.noabx$BinTime <- ave(sal.win.noabx$RelTime, cut(sal.win.noabx$RelTime, breaks=6), FUN=mean)
  sal.win.abx$BinTime <- ave(sal.win.abx$RelTime, cut(sal.win.abx$RelTime, breaks=6), FUN=mean)
  sal.spr.noabx$BinTime <- ave(sal.spr.noabx$RelTime, cut(sal.spr.noabx$RelTime, breaks=6), FUN=mean)
  sal.spr.abx$BinTime <- ave(sal.spr.abx$RelTime, cut(sal.spr.abx$RelTime, breaks=6), FUN=mean)
  

  
  
  
  # Update BinTime in dataframe containing all substrate data
  ## Inulin
  for(i in 1:nrow(inu.sum.noabx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:15], inu.sum.noabx[i,1:15])))] <- inu.sum.noabx$BinTime[i]
    # match_df goes through each row of inu.exp and finds the matching row in inu
    # Each row in inu has a unique rowname, so we take the rowname of the match_df and find that row in inu
    # Check unique rownames with sum(duplicated(rownames(inu)). If all rownames are unique, sum = 0
    # Now that we know which row in inu matches that of inu.exp, we replace inu$BinTime with inu.exp$BinTime
    # I repeat this for every row in inu.exp so each inu.exp$BinTime gets imported into inu$BinTime
  }
  for(i in 1:nrow(inu.sum.abx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:15], inu.sum.abx[i,1:15])))] <- inu.sum.abx$BinTime[i]
  }
  for(i in 1:nrow(inu.win.noabx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:15], inu.win.noabx[i,1:15])))] <- inu.win.noabx$BinTime[i]
  }
  for(i in 1:nrow(inu.win.abx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:15], inu.win.abx[i,1:15])))] <- inu.win.abx$BinTime[i]
  }
  for(i in 1:nrow(inu.spr.noabx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:15], inu.spr.noabx[i,1:15])))] <- inu.spr.noabx$BinTime[i]
  }
  for(i in 1:nrow(inu.spr.abx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:15], inu.spr.abx[i,1:15])))] <- inu.spr.abx$BinTime[i]
  }
  
  print(inu)
  
  ## Saline
  for(i in 1:nrow(sal.sum.noabx)) {
    sal$BinTime[which(rownames(sal) == rownames(match_df(sal[,1:15], sal.sum.noabx[i,1:15])))] <- sal.sum.noabx$BinTime[i]
  }
  for(i in 1:nrow(sal.sum.abx)) {
    sal$BinTime[which(rownames(sal) == rownames(match_df(sal[,1:15], sal.sum.abx[i,1:15])))] <- sal.sum.abx$BinTime[i]
  }
  for(i in 1:nrow(sal.win.noabx)) {
    sal$BinTime[which(rownames(sal) == rownames(match_df(sal[,1:15], sal.win.noabx[i,1:15])))] <- sal.win.noabx$BinTime[i]
  }
  for(i in 1:nrow(sal.win.abx)) {
    sal$BinTime[which(rownames(sal) == rownames(match_df(sal[,1:15], sal.win.abx[i,1:15])))] <- sal.win.abx$BinTime[i]
  }
  for(i in 1:nrow(sal.spr.noabx)) {
    sal$BinTime[which(rownames(sal) == rownames(match_df(sal[,1:15], sal.spr.noabx[i,1:15])))] <- sal.spr.noabx$BinTime[i]
  }
  for(i in 1:nrow(sal.spr.abx)) {
    sal$BinTime[which(rownames(sal) == rownames(match_df(sal[,1:15], sal.spr.abx[i,1:15])))] <- sal.spr.abx$BinTime[i]
  }

  
  output <- rbind(inu,sal)
  return(output)
  
  
}