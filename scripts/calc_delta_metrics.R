### x = crds.rem dataframe

calc.delta.metrics <- function(x){
  
  # Pull out squirrel IDs
  IDs <- levels(as.factor(x$ID))
  
  # Create output dataframe
  output <- data.frame(matrix(ncol = 3, nrow = length(levels(IDs))))
  colnames(output) <- c("ID", "MaxD", "Slope")
  
  
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
    maxD_sorted <- sort(curve.df$Delta[2:nrow(curve.df)], decreasing = T)
    maxDuse <- mean(maxD_sorted[1:3])
    maxD <- which(curve.df$Delta == max(curve.df$Delta))

    
    # Calculate slope
    slope = 0
    slopeTime = 0
    for(j in 3:(nrow(curve.df) + 1)){
        # Go row-by-row through curve.df
      rise <- curve.df$Delta[j] - curve.df$Delta[j-1]
      run <- curve.df$RelTime[j] - curve.df$RelTime[j-1]
      slope <- c(slope, (rise/run) )    }
    
    slope <- slope[-1]
      # Remove initial 0
    maxSlope <- max(slope, na.rm = T)

    # Populate output dataframe
    output[i,] <- c(IDs[i], maxDuse, maxSlope)
    
  }
  
  return(output)
  
}