### x = your crds dataframe (with ALL your data)

bin.crds <- function(x){
  crds <- x
  bin.time <- seq(from=-1, to=5, by=0.25)
  crds$BinTime <- findInterval(x$RelTime, bin.time)
  
  for(i in 1:length(bin.time)){
    time <- bin.time[i]
    bin <- which(crds$BinTime == i)
    crds[bin,10] <- time
  }
  
  return(crds)
}

  