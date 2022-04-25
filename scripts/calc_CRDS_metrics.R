### x = dataframe output of norm.time.crds()

calc.CRDS.metrics <- function(x){
  
  # Pull out squirrel IDs
  IDs <- levels(as.factor(x$ID))
  
  # Create output dataframe
  output <- data.frame(matrix(ncol = 6, nrow = length(levels(IDs))))
  colnames(output) <- c("ID", "AvgD", "MaxD",  "MaxSlope", "AUC", "Baseline")
  
  
  # Iterate through each squirrel ID
  for(i in 1:length(IDs)){
    curve <- which(x$ID == IDs[i])
    curve.df <- x[curve,]
      # Pull out measurements for the individual squirrel
    curve.df <- curve.df[-2,]
      # Remove first measurement after gavage because it's always weird
    
    # Pull out average max delta
    maxD_sorted <- sort(curve.df$DeltaNorm[2:nrow(curve.df)], decreasing = T)
    maxDuse <- mean(maxD_sorted[1:3])
    
    # Calculate average delta
    trim <- maxD_sorted[-1:-2]
    trim <- trim[-(length(trim)-1):-length(trim)]
      # Take trimmed means --> remove top 2 and bottom 2 measurements
    meanD <- mean(trim)

    
    # Calculate average maximum slope
    slope = 0
    for(j in 3:(nrow(curve.df))){
        # Go row-by-row through curve.df
      rise <- curve.df$DeltaNorm[j] - curve.df$DeltaNorm[j-1]
      run <- curve.df$RelTime[j] - curve.df$RelTime[j-1]
      slope <- c(slope, (rise/run) )
      }
    
    slope <- slope[-1]
      # Remove initial 0
    slopeSort <- sort(slope, decreasing = T)
    maxSlope <- mean(slopeSort[1:3])

    
    
    ### Calculate AUC ###
    # Create auc variable
    AUC <- 0
    # Run trapezoid method integration - more accurate
    for(k in 2:(nrow(curve.df)-1)){
      # Ignore baseline to first measurement
      avgH <- (curve.df$DeltaNorm[k+1]+curve.df$DeltaNorm[k])/2
      # Calculates average height between start and end point
      width <- (curve.df$RelTime[k+1]-curve.df$RelTime[k])
      AUC <- AUC + (avgH*width)
    }
    



    # Populate output dataframe
    output[i,] <- c(IDs[i], meanD, maxDuse, maxSlope, AUC, curve.df$Delta[1])
    
  }
  
  return(output)
  
}