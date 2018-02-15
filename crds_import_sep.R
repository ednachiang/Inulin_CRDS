# x = This is the folder where all of your csv files for each squirrel (1 file per squirrel) are located 
# y = This is your metadata.csv file
# USE ' ' AROUND BOTH X & Y!!!

import.crds.sep <- function(x,y) {
  
  # Load in all outside variables before you start the 'for' loop
  n <- as.numeric(length(list.files(x)))
  meta <- read.csv(y, fileEncoding="UTF-8-BOM")
  crds <- data.frame(matrix(ncol=9, nrow=0))
  print(n)
  print(meta)
  
  # Import in each squirrel as its own dataframe
  for (i in 1:n){
    filename <- list.files(x)[i]
    id <- substr(filename, 1,4)
    wd <- paste0(x,"/",filename)
    df <- assign(paste0("crds.", id), read.csv(wd, header=T, fileEncoding="UTF-8-BOM"))
    rw <- which(meta[,1] == id)
    print(filename)
    print(id)
    print(wd)
    print(i)
    
    for (j in 1:6){
      cl = j
      df[,j+3] <- rep(meta[rw,cl],nrow(df))
      colnames(df)[j+3] <- colnames(meta)[cl]
      print(j)
    }
    
    print(df)
    crds <- vector("list", n)
    
    if (i < 2){
      crds[[i]] <- assign(paste0("crds.", id), df)
      #crds <- list[assign(paste0("crds.", id), df)]
      return(crds)
    } else {
      crds[[i]] <- assign(paste0("crds.", id), df)
      return(crds)
    }
    
  
    }
}
