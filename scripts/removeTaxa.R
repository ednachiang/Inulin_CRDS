# x = folder where your summarized kaiju files are (output of kaijuSummarize.py)
# USE ' ' AROUND X!!!

removeTaxa <- function(x) {
  files <- list.files(x, pattern = ".csv")
    # List of all .csv files
  
  for(taxon in 1:length(files)){
    
    path <- paste(x, files[taxon], sep = '')
    df <- read.csv(path)
    rem <- list()
    print(files[taxon])
    
    for(i in 1:nrow(df)){
      
      empty <- length(which(df[i,] == 0))
        # Identify # of samples w/o taxon
      if(empty > 15){
          # If taxon appears in < 3 samples
        rem <- append(rem, i)
          # Create list of taxa that appear in < 3 samples
      }
    }
    
    rem.row <- as.numeric(rem)
      # Convert list to numeric
    df.rem <- df[-rem.row,]
      # Remove taxa that appear in < 3 samples
    
    # Remove unused taxa
    df.rem <- df.rem[-which(df.rem[,1] == "unclassified"),]
    removeRow <- which(grepl("cannot be assigned", df.rem[,1]) == T)
    df.rem <- df.rem[-removeRow,]
    
    df.unclass <- list()
    
    # Calculate Unclassified rel abund after removing taxa
    for(j in 2:ncol(df.rem)){
      class <- sum(df.rem[,j])
      unclass <- 100 - class
      df.unclass <- append(df.unclass, unclass)
    }
    
    # Add correct Unclassified
    df.Unclass <- as.numeric(df.unclass)
    df.rem[(1 + nrow(df.rem)),] <- c("Unclassified", df.Unclass)
    
    # Return dataframe
    fileName <- strsplit(files[taxon], split = "[.]")
    taxonLevel <- unlist(fileName)[2]
    output <- paste(x, taxonLevel, ".csv", sep = "")
    write.csv(df.rem, output, row.names = T)
    print(output)

    
  }
}