# x = This is the folder where all of your kaiju files are located
# y = Output directory
# USE ' ' AROUND X and Y!!!

library(plyr)
library(dplyr)
library(tidyr)

kaiju_big_OTU_table <- function(x,y) {
  
  # Load in all outside variables before you start the 'for' loop
  filePrefix <- substr(list.files(x), 1, 5)
  n <- length(filePrefix)
  
  output <- data.frame(matrix(nrow = 0, ncol = n))
  
  for(i in 1:n){
    
    if(i == 1){
      inputPath <- paste(x, list.files(x)[i], sep = "")
      print(inputPath)
      input <- read.table(inputPath, sep = "\t", header = T)
      input$OTU <- paste(input[,2], input[,3], input[,4], input[,5], input[,6], input[,7], input[,8], sep = "*")
      input <- input[,-2:-8]
      output <- input
      colnames(output) <- c(filePrefix[i], "OTU")
      
    } else{
      inputPath <- paste(x, list.files(x)[i], sep = "")
      print(inputPath)
      input <- read.table(inputPath, sep = "\t", header = T)
      input$OTU <- paste(input[,2], input[,3], input[,4], input[,5], input[,6], input[,7], input[,8], sep = "*")
      input <- input[,-2:-8]
      
      output$new <- NA
      colnames(output) <- c( colnames(output)[1:(ncol(output) - 1)], filePrefix[i])
      
      for(j in 1:nrow(input)){
        match <- which(output$OTU == input$OTU[j])
        
        if(length(match != 0)){
          output[match, ncol(output)] <- input$reads[j]
          
        } else if(length(match == 0)){
          output[(nrow(output) + 1),] <- NA
          output$OTU[nrow(output) + 1] <- input$OTU[j]
          output[,ncol(output)] <- input$reads[j]
          empty <- which(is.na(output[nrow(output),]) == T)
          output[nrow(output), empty] <- 0
        } 
      }
      
      output[which(is.na(output[,ncol(output)]) == T), ncol(output)] <- 0
      
    } # Closes first if/else loop


    
  } # Closes file-by-file for loop
  
  
  write.table(output, file = y, sep = "\t", row.names = F)
  
  
}