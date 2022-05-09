### x = your dataframe after bin_crds()

norm.time.crds <- function(x){
  # Since length of experiment varies for each individual, we don't want experimental length to bias our AUC calculations
  # Normalize length to min time within each substrate
  # Inu = 4.0667
  # Sal = 2.21667
  maxInu <- 4.06667
  maxSal <- 2.21666667
  
  # Save unique squirrels
  ids <- unique(x$ID)
  
  crds.norm <- data.frame(matrix(ncol=16, nrow=0))
  
  
  for (i in 1:length(ids)){
    ID <- ids[i]
    print(ID)
    select <- x[which(x$ID == ID),]
    # Dataframe with CRDS values for 1 squirrel
    
    # Normalize delta value to baseline
    select$DeltaNorm <- select$Delta - select$Delta[1]
    
    # Remove baseline from AUC calculation because we care about the AUC after gavage
    # Since we already normalized delta value to baseline, we don't need that value anymore
    # Set baseline to gavage time = 0
    select[1,1] <- 0
    
    
    # Normalize AUC end time
    if (select$Substrate[1] == "Inulin") {
      # Go through each Inulin squirrels
      
      max <- which(select$RelTime > maxInu)
        # Subset measurements that happened after the cutoff
      lastRowUse <- max[1]
      # Interpolate cutoff measurement
      lastDeltaNorm <- select$DeltaNorm[lastRowUse]
        # Rise
      lastTime <- select$RelTime[lastRowUse]
        # Run
      lastSlopeNorm <- lastDeltaNorm / lastTime
        # Rise / Run
      lastDelta <- select$Delta[lastRowUse]
      lastSlope <- lastDelta / lastTime
      
      select$RelTime[lastRowUse] <- maxInu
      select$BinTime[lastRowUse] <- maxInu
      select$DeltaNorm[lastRowUse] <- lastSlope * (lastRowUse - (lastRowUse-1))
      select$Delta[lastRowUse] <- lastSlope * ((lastRowUse - lastRowUse-1))
  
      if (length(max) > 1){
      select <- select[-max[2:length(max)],]
        # Remove extra measurements after cutoff
      crds.norm <- rbind(crds.norm, select)
      } else {
        crds.norm <- rbind(crds.norm, select)
      }
      
      
    } else if (select$Substrate[1] == "Saline") {
      max <- which(select$RelTime > maxSal)
      # Subset measurements that happened after the cutoff
      lastRowUse <- max[1]
      # Interpolate cutoff measurement
      lastDeltaNorm <- select$DeltaNorm[lastRowUse]
      # Rise
      lastTime <- select$RelTime[lastRowUse]
      # Run
      lastSlopeNorm <- lastDeltaNorm / lastTime
      # Rise / Run
      lastDelta <- select$Delta[lastRowUse]
      lastSlope <- lastDelta / lastTime
      
      select$RelTime[lastRowUse] <- maxSal
      select$BinTime[lastRowUse] <- maxSal
      select$DeltaNorm[lastRowUse] <- lastSlope * (lastRowUse - (lastRowUse-1))
      select$Delta[lastRowUse] <- lastSlope * ((lastRowUse - lastRowUse-1))
    
      if (length(max) > 1){
        select <- select[-max[2:length(max)],]
        # Remove extra measurements after cutoff
        crds.norm <- rbind(crds.norm, select)
      } else {
        crds.norm <- rbind(crds.norm, select)
      }
    }
  
  }
  
  return(crds.norm)
}