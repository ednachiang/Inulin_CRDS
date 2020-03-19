### x = your crds dataframe (with ALL your data)
bin.crds3 <- function(x){
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
  
  man.sum <- man.exp[which(man.exp$Season == "Summer"),]
  man.sum.noabx <- man.sum[which(man.sum$Antibiotics == "No"),]
  man.sum.abx <- man.sum[which(man.sum$Antibiotics == "Yes"),]
  man.win <- man.exp[which(man.exp$Season == "Winter"),]
  man.win.noabx <- man.win[which(man.win$Antibiotics == "No"),]
  man.win.abx <- man.win[which(man.win$Antibiotics == "Yes"),]
  man.spr <- man.exp[which(man.exp$Season == "Spring"),]
  man.spr.noabx <- man.spr[which(man.spr$Antibiotics == "No"),]
  man.spr.abx <- man.spr[which(man.spr$Antibiotics == "Yes"),]
  
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
  # Mannitol = 4
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
  
  man.sum.noabx$BinTime <- ave(man.sum.noabx$RelTime, cut(man.sum.noabx$RelTime, breaks=4), FUN=mean)
  man.sum.abx$BinTime <- ave(man.sum.abx$RelTime, cut(man.sum.abx$RelTime, breaks=4), FUN=mean)
  man.win.noabx$BinTime <- ave(man.win.noabx$RelTime, cut(man.win.noabx$RelTime, breaks=4), FUN=mean)
  man.win.abx$BinTime <- ave(man.win.abx$RelTime, cut(man.win.abx$RelTime, breaks=4), FUN=mean)
  man.spr.noabx$BinTime <- ave(man.spr.noabx$RelTime, cut(man.spr.noabx$RelTime, breaks=4), FUN=mean)
  man.spr.abx$BinTime <- ave(man.spr.abx$RelTime, cut(man.spr.abx$RelTime, breaks=4), FUN=mean)
  
  sal.sum.noabx$BinTime <- ave(sal.sum.noabx$RelTime, cut(sal.sum.noabx$RelTime, breaks=6), FUN=mean)
  sal.sum.abx$BinTime <- ave(sal.sum.abx$RelTime, cut(sal.sum.abx$RelTime, breaks=6), FUN=mean)
  sal.win.noabx$BinTime <- ave(sal.win.noabx$RelTime, cut(sal.win.noabx$RelTime, breaks=6), FUN=mean)
  sal.win.abx$BinTime <- ave(sal.win.abx$RelTime, cut(sal.win.abx$RelTime, breaks=6), FUN=mean)
  sal.spr.noabx$BinTime <- ave(sal.spr.noabx$RelTime, cut(sal.spr.noabx$RelTime, breaks=6), FUN=mean)
  sal.spr.abx$BinTime <- ave(sal.spr.abx$RelTime, cut(sal.spr.abx$RelTime, breaks=6), FUN=mean)
  

  
  
  
  # Update BinTime in dataframe containing all substrate data
  # Inulin
  for(i in 1:nrow(inu.sum.noabx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:9], inu.sum.noabx[i,1:9])))] <- inu.sum.noabx$BinTime[i]
    # match_df goes through each row of inu.exp and finds the matching row in inu
    # Each row in inu has a unique rowname, so we take the rowname of the match_df and find that row in inu
    # Check unique rownames with sum(duplicated(rownames(inu)). If all rownames are unique, sum = 0
    # Now that we know which row in inu matches that of inu.exp, we replace inu$BinTime with inu.exp$BinTime
    # I repeat this for every row in inu.exp so each inu.exp$BinTime gets imported into inu$BinTime
  }
  for(i in 1:nrow(inu.sum.abx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:9], inu.sum.abx[i,1:9])))] <- inu.sum.abx$BinTime[i]
  }
  for(i in 1:nrow(inu.win.noabx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:9], inu.win.noabx[i,1:9])))] <- inu.win.noabx$BinTime[i]
  }
  for(i in 1:nrow(inu.win.abx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:9], inu.win.abx[i,1:9])))] <- inu.win.abx$BinTime[i]
  }
  for(i in 1:nrow(inu.spr.noabx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:9], inu.spr.noabx[i,1:9])))] <- inu.spr.noabx$BinTime[i]
  }
  for(i in 1:nrow(inu.spr.abx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:9], inu.spr.abx[i,1:9])))] <- inu.spr.abx$BinTime[i]
  }
  
  # Mannitol
  for(i in 1:nrow(man.sum.noabx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:9], man.sum.noabx[i,1:9])))] <- man.sum.noabx$BinTime[i]
  }
  for(i in 1:nrow(man.sum.abx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:9], man.sum.abx[i,1:9])))] <- man.sum.abx$BinTime[i]
  }
  for(i in 1:nrow(man.win.noabx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:9], man.win.noabx[i,1:9])))] <- man.win.noabx$BinTime[i]
  }
  for(i in 1:nrow(man.win.abx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:9], man.win.abx[i,1:9])))] <- man.win.abx$BinTime[i]
  }
  for(i in 1:nrow(man.spr.noabx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:9], man.spr.noabx[i,1:9])))] <- man.spr.noabx$BinTime[i]
  }
  for(i in 1:nrow(man.spr.abx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:9], man.spr.abx[i,1:9])))] <- man.spr.abx$BinTime[i]
  }
  
  # Saline
  for(i in 1:nrow(sal.sum.noabx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:9], sal.sum.noabx[i,1:9])))] <- sal.sum.noabx$BinTime[i]
  }
  for(i in 1:nrow(sal.sum.abx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:9], sal.sum.abx[i,1:9])))] <- sal.sum.abx$BinTime[i]
  }
  for(i in 1:nrow(sal.win.noabx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:9], sal.win.noabx[i,1:9])))] <- sal.win.noabx$BinTime[i]
  }
  for(i in 1:nrow(sal.win.abx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:9], sal.win.abx[i,1:9])))] <- sal.win.abx$BinTime[i]
  }
  for(i in 1:nrow(sal.spr.noabx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:9], sal.spr.noabx[i,1:9])))] <- sal.spr.noabx$BinTime[i]
  }
  for(i in 1:nrow(sal.spr.abx)) {
    inu$BinTime[which(rownames(inu) == rownames(match_df(inu[,1:9], sal.spr.abx[i,1:9])))] <- sal.spr.abx$BinTime[i]
  }

  
  output <- rbind(inu,man,sal)
  return(output)
  
  
}