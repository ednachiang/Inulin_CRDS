### x = crds.rem dataframe

calc.delta.metrics <- function(x){
  
  # Pull out squirrel IDs
  IDs <- levels(as.factor(x$ID))
  
  # Create output dataframe
  output <- data.frame(matrix(ncol = 4, nrow = length(levels(IDs))))
  colnames(output) <- c("ID", "TimeMaxD", "Slope", "SlopeTime")
  
  
  # Iterate through each squirrel ID
  for(i in 1:length(IDs)){
    curve <- which(x$ID == IDs[i])
    curve.df <- x[curve,]
      # Pull out measurements for the individual squirrel
    curve.df$Delta <- curve.df$Delta - curve.df$Delta[1]
      # Normalize to baseline
    curve.df <- curve.df[-2,]
      # Remove first measurement after gavage
    
    # Pull out time of max value
    maxD <- which(curve.df$Delta == max(curve.df$Delta))
    timeMaxD <- curve.df$RelTime[maxD]
    if(timeMaxD < 0){
      sortDelta <- sort(curve.df$Delta, decreasing = T)
      newD <- sortDelta[2]
      newMaxD <- which(curve.df$Delta == newD)
      timeMaxD <- curve.df$RelTime[newMaxD]
    }
    
    # Calculate slope
    slope = 0
    slopeTime = 0
    for(j in 3:(nrow(curve.df) + 1)){
        # Go row-by-row through curve.df
      rise <- curve.df$Delta[j] - curve.df$Delta[j-1]
      run <- curve.df$RelTime[j] - curve.df$RelTime[j-1]
      slope <- c(slope, (rise/run) )
      slopeTime <- c(slopeTime, curve.df$RelTime[j])
    }
    
    slope <- slope[-1]
      # Remove initial 0
    slopeTime <- slopeTime[-1]
      # Remove initial 0
    maxSlope <- max(slope, na.rm = T)
    useSlopeTime <- slopeTime[which(slope == maxSlope)]

    # Populate output dataframe
    output[i,] <- c(IDs[i], timeMaxD, maxSlope, useSlopeTime)
    
  }
  
  return(output)
  
}