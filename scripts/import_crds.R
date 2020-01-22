# x = This is the folder where all of your csv files for each squirrel (1 file per squirrel) are located 
# y = This is your metadata.csv file
# USE ' ' AROUND BOTH X & Y!!!

import.crds <- function(x,y) {
  
  # Load in all outside variables before you start the 'for' loop
  n <- as.numeric(length(list.files(x)))
  meta <- read.csv(y, fileEncoding="UTF-8-BOM")
  crds <- data.frame(matrix(ncol=9, nrow=0))

  # Import in each squirrel as its own dataframe
  for (i in 1:n){
    filename <- list.files(x)[i]
    id <- substr(filename, 1,3)
      # Pull out squirrel ID
    wd <- paste0(x,"/",filename)
      # Path to each csv file
    df <- assign(paste0("crds.", id), read.csv(wd, header=T, fileEncoding="UTF-8-BOM"))
      # Save each csv file as a dataframe
    rw <- which(meta[,2] == id)
      # Find the metadata row which matches the squirrel ID of the csv file
    
    
    # Remove all baseline values except for the last one right before gavage
    bl <- which(df[,1] < 0)
      # Identify baseline values
    bln <- length(bl)
      # Find number of baseline values
    for (k in 1:(bln-1)){
      df <- df[-1,]
    }
    
    
    # Add squirrel number ID
    for (j in 1:6){
      cl = j
      df[,j+3] <- rep(meta[rw,cl],nrow(df))
        # Add a column of squirrel 4-digit numeric ID
      colnames(df)[j+3] <- colnames(meta)[cl]
        # Rename the new column
    }
    
    
    # Save all the data in one giant dataframe
    if (i < 2){
      crds <- df
      # Creates initial dataframe with the first file
    } else {
      crds <- rbind(crds, df)
      # Appends onto the dataframe for all subsequent files
    }
    
  }

  return(crds)
  
}
