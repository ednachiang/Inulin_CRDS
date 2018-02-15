x <- 'CSV'
# This is the folder where all of your csv files for each squirrel (1 file per squirrel) are located
n <- as.numeric(length(list.files(x)))
meta <- read.csv('metadata_practice.csv', fileEncoding="UTF-8-BOM")
crds <- data.frame(matrix(ncol=9, nrow=0))


## Import in each squirrel as its own dataframe
for (i in 1:n){
  filename <- list.files(x)[i]
  id <- substr(filename, 1,4)
  wd <- paste0(x,"/",filename)
  df <- assign(paste0("crds.", id), read.csv(wd, header=T, fileEncoding="UTF-8-BOM"))
  rw <- which(meta[,1] == id)
  
  for (i in 1:6){
    cl = i
    df[,i+3] <- rep(meta[rw,cl],nrow(df))
    colnames(df)[i+3] <- colnames(meta)[cl]
    print(df)
  }
  
  assign(paste0("crds.", id), df)
  rownum <- nrow(df)
  
  if (i < 2){
    crds <- df
    print(crds)
  } else {
    #crds[(nrow(crds)+1):(nrow(crds) + rownum),] <- df
    crds <- rbind(crds, df)
    print(crds)
  }
  
}
