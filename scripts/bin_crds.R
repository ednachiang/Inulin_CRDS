### x = your crds dataframe (with ALL your data)

bin.crds <- function(x){
  crds <- x
  bin.time <- seq(from=-0.5, to=5, by=0.5)
  bl <- which(crds$RelTime < 0)
    # Find baseline
  
  # Make all baseline binned to the very first bin (-0.5)
  crds$NewTime <- crds$RelTime
  crds$NewTime[bl] <- -0.5
  
  #Remove NA
  rem <- which(is.na(crds$Delta))
  crds <- crds[-rem,]
  
  
  crds$BinTime <- bin.time[findInterval(crds$NewTime, bin.time)]
    # Closed on lower cutoff, open on upper cutoff
  
  crds <- crds[,-10]
    # Remove NewTime col
  
  # All final bin for each substrate get binned with the second to last bin
    # inulin 4.5 = inulin 4.0;   mannitol 2.5 = manniotl 2.0;   saline 3.0 = saline 2.5
    # Many final bins have only 1 sample because we began anesthetizing the squirrel before that last time point.
    # We collect organs at the end of the time point, not collect a last breath
  inu <- which(crds$Substrate=="Inulin" & crds$BinTime > 4)
  man <- which(crds$Substrate=="Mannitol" & crds$BinTime > 2)
  sal <- which(crds$Substrate=="Saline" & crds$BinTime > 2.5)
  
  crds$BinTime[inu] <- 4.0
  crds$BinTime[man] <- 2.0
  crds$BinTime[sal] <- 2.5
  
  
  
  return(crds)
}

  