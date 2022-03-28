# x = This is the folder where all of your csv files for each squirrel (1 file per squirrel) are located 
# y = This is your metadata.csv file
# USE ' ' AROUND BOTH X & Y!!!


import.crds <- function(x,y) {
  
  # Load in all outside variables before you start the 'for' loop
  n <- as.numeric(length(list.files(x)))
  meta <- read.csv(y)
  crds <- data.frame(matrix(ncol=15, nrow=0))

  
  # Import in each squirrel as its own dataframe
  for (i in 1:n){
    filename <- list.files(x)[i]
    id <- substr(filename, 1,3)
    # Pull out squirrel ID
    wd <- paste0(x,"/",filename)
    # Path to each csv file
    print(wd)
    df <- assign(paste0("crds.", id), read.csv(wd, header=T, fileEncoding="UTF-8-BOM"))
    # Save each csv file as a dataframe
    rw <- which(meta[,2] == id)
    # Find the metadata row which matches the squirrel ID of the csv file

    # Remove all measurements that are out of CO2 range (allowable = 0.5 - 1.2)
    co2.low <- which(df[,3] < 0.5)
    # Identify CO2 measuresments below range
    co2.high <- which(df[,3] > 1.2)
    # Identify CO2 measurements above range
    co2.rem <- c(co2.low, co2.high)
    # All CO2 measurements out of range
    if (length(co2.rem) > 0){
      df <- df[-co2.rem,]
    }
    
    
    # Remove all baseline values except for the last one right before gavage
    bl <- which(df[,1] < 0)
    # Identify baseline values
    bln <- length(bl)
    # Find number of baseline values
    if (bln > 1){
    # If there's more than 1 baseline value
      for (k in 1:(bln-1)){
        df <- df[-1,]
        # Remove baseline values except for the last one right before gavage
      }
    }

    
    # Add squirrel number ID
    for (j in 1:13){
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