crds.test <- function(x){
  crds <- x
  crds.rem <- crds[-which(crds$RelTime < -1),]
  std.time <- seq(from=-1, to=5, by=0.25)
  crds.rem$StdTime <- findInterval(x$RelTime, std.time)
  
  for(i in i:nrow(crds.rem)){
    
  }
  
  
}



#### Below is code testing! ####


test <- crds
gav <- which(test$RelTime == 0)
rem <- gav - 4


for (i in 1:length(rem)){
  
  if(test[rem[i],1] < 0){
    print(i)
    test <- test[-rem[i],]
    gav <- which(test$RelTime == 0)
    rem <- gav - 4
  } else{
    print(i)
    return(test)
  }
  #return(test1)
  print(i)
}




test.rem <- crds[-which(test$RelTime < -1),]
std.time <- seq(from=-1, to=5, by=0.25)
crds.rem$StdTime <- findInterval(x$RelTime, std.time)
