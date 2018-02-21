crds.test <- function(x){
  crds <- x
  crds.rem <- crds[-which(crds$RelTime < -1),]
  std.time <- seq(from=-1, to=5, by=0.25)
  crds.rem$StdTime <- findInterval(x$RelTime, std.time)
  
  for(i in i:nrow(crds.rem)){
    
  }
  
  
}



#### Below is code testing! ####
