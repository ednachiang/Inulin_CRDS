# x = This is the folder where all of your kaiju files are located
# y = Output directory
# USE ' ' AROUND X and Y!!!

library(plyr)
library(dplyr)
library(tidyr)

kaiju_to_OTU_table <- function(x,y) {
  
  # Load in all outside variables before you start the 'for' loop
  filePrefix <- substr(list.files(x), 1, 5)
  n <- length(filePrefix)
  
  for(i in 1:n){
    
    inputPath <- paste(x, list.files(x)[i], sep = "")
    print(inputPath)
    input <- read.table(inputPath, sep = "\t", header = T)
    print(head(input))
    
    weirdo <- which(input$Domain == "cannot be assigned to a (non-viral) phylum")
    unclass <- which(input$Domain == "unclassified")[1]
    input$reads[unclass] <- input$reads[unclass] + input$reads[weirdo]
    input <- input[-weirdo,]
    
    output <- data.frame(matrix(nrow = 0, ncol = 8))
    colnames(output) <- colnames(input)
    output <- rbind(output, input[which(input$Domain == "unclassified")[1],])
    output <- rbind(output, input[which(input$Domain == "Viruses")[1],])
    
    allPhy <- unique(input$Phylum)
    
##################### TEST PHYLUM FOR LOOP HERE ##################### 
    for(phy in 1:length(allPhy)){
      # Go phylum-by-phylum
      
      phyMatch <- input[which(input$Phylum == allPhy[phy]),]


      
##################### TEST MINI FOR LOOP HERE ##################### 
      for(j in 1:nrow(phyMatch)){
        # Pull out everything that matches the phylum and go row-by-row
        
        empty <- is.na(phyMatch[j,])
        emptyTaxa <- which(empty == T)
        #print(emptyTaxa)
        #notSeq <- which(diff(emptyTaxa) != 1)
        #print(emptyTaxa)

        
##################### 4 empty ##################### 
        if(length(emptyTaxa) == 4){
          # If there are 4 empty columns
          # Normal rows have Order --> Species empty; we don't have to worry about those
          
          #print(phyMatch[j,])
          
          if(is.na(phyMatch[j,4]) == T){
            # If Class is empty, that means Species is filled
              # Class, Order, Family, and Genus should be empty
            # So we want to delete reads of Species from Phylum
            ammend <- phyMatch[j,3]
            ammendRow <- which(phyMatch[,3] == ammend)[1]
            phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
            #print(phyMatch[j,])
          } else{
            if(sum(is.na(phyMatch[j,5:8])) == 0){
              # If I miss something that's extra wonky, print it out
              print(phyMatch[j,])
            }
          }
          
          
##################### 3 Empty ##################### 
          
        } else if(length(emptyTaxa) == 3){
          # If there are 3 empty columns
          # Normal rows have Family --> Species empty; we don't need to worry about those
          
          #print(phyMatch[j,])
          
          if(is.na(phyMatch[j,4]) == T){
            # If Class is empty
            
            if(is.na(phyMatch[j,5]) == T){
              # If both Class and Order are empty
              
              if(is.na(phyMatch[j,6]) == T){
                # If Class, Order, and Family are empty
                # That means Genus and Species are filled
                # Subtract Species from Genus
                ammend<- phyMatch[j,7]
                ammendRow <- which(phyMatch[,7] == ammend)[1]
                phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
              } else if(is.na(phyMatch[j,7]) == T){
                # If Class, Order, and Genus are empty
                # That means Species and Family are filled
                # Subtract this Species from Family
                ammend<- phyMatch[j,6]
                ammendRow <- which(phyMatch[,6] == ammend)[1]
                phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
              } else if(is.na(phyMatch[j,8]) == T){
                # If Class, Order, and Species are empty
                # That means Family and Genus are filled
                # Subtract this Genus from Family
                ammend<- phyMatch[j,6]
                ammendRow <- which(phyMatch[,6] == ammend)[1]
                phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
              } else{
                # If I missed something, print it out
                print(phyMatch[j,])
              }
              
            } else if(is.na(phyMatch[j,6]) == T){
              # If both Class and Family are empty
              # But Order is filled
              #print(phyMatch[j,])
              if(is.na(phyMatch[j,7]) == T){
                # If Class, Family, and Genus are empty
                # Order and Species are filled
                # Subtract this Species from Order
                ammend<- phyMatch[j,5]
                ammendRow <- which(phyMatch[,5] == ammend)[1]
                phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
              } else if(is.na(phyMatch[j,8]) == T){
                # If Class, Family, and Species are empty
                # Order and Genus are filled
                # Subtract this Genus from Order
                ammend<- phyMatch[j,5]
                ammendRow <- which(phyMatch[,5] == ammend)[1]
                phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
              } else{
                # If I missed something, print it out
                print(phyMatch[j,])
              }
            } else if(is.na(phyMatch[j,7]) == T){
              # If both Class and Genus are empty
                # But Order and Family are filled
                # So Species should be empty too
              # Subtract this Family from Order
              if(is.na(phyMatch[j,8]) == T){
                # Double check that Species is also Empty
                # Subtract this Family from Order
                ammend <- phyMatch[j,5]
                ammendRow <- which(phyMatch[,5] == ammend)[1]
                phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
              }
            } else{
              # If I missed something, print it out
              print(phyMatch[j,])
            }
            
          } else if(is.na(phyMatch[j,5]) == T){
            # If Order is empty
              # But Class is filled
            
            if(is.na(phyMatch[j,6]) == T){
              # If both Order and Family are empty
              
              if(is.na(phyMatch[j,7]) == T){
                # If Order, Family, and Genus are empty
                # Species and Class are filled
                # Subtract this Species from Class
                ammend <- phyMatch[j,4]
                ammendRow <- which(phyMatch[,4] == ammend)[1]
                phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
              } else if(is.na(phyMatch[j,8]) == T){
                # If Order, Family, and Species are empty
                # Class and Genus are filled
                # Subtract this Genus from Class
                ammend <- phyMatch[j,4]
                ammendRow <- which(phyMatch[,4] == ammend)[1]
                phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
              }
              
            } else if(is.na(phyMatch[j,7]) == T){
              # If both Order and Genus are empty
              # But Family is filled
              if(is.na(phyMatch[j,8]) == T){
                # If Order, Genus, and Species are empty
                # Family and Class are filled
                # Subtract this Family from Class
                ammend <- phyMatch[j,4]
                ammendRow <- which(phyMatch[,4] == ammend)[1]
                phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
              }
            }
            } else {
              if(sum(is.na(phyMatch[j,6:8])) != 3){
                # If I miss something extra wonky, print it out
                print(phyMatch[j,])
              }
            }
            

##################### 2 empty ##################### 
        } else if(length(emptyTaxa) == 2){
          # If there are 2 empty columns
          # Normal rows have Genus and Species empty; we don't have to worry about those
          
          #print(phyMatch[j,])
          
          if(is.na(phyMatch[j,4]) == T){
            # If Class is empty
            
            if(is.na(phyMatch[j,5]) == T){
              # If both Class and Order are empty
              # That means Family, Genus and Species are filled
              # Subtract this Species from Genus
              ammend <- phyMatch[j,7]
              ammendRow <- which(phyMatch[,7] == ammend)[1]
              phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
            } else if(is.na(phyMatch[j,6]) == T){
              # If both Class and Family are empty
              # That means Genus and Species are filled
              # Subtract this Species from Genus
              ammend <- phyMatch[j,7]
              ammendRow <- which(phyMatch[,7] == ammend)[1]
              phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
            } else if(is.na(phyMatch[j,7]) == T){
              # If both Class and Genus are empty
              # That means Family and Species are filled
              # Subtract this Species from Family
              ammend <- phyMatch[j,6]
              ammendRow <- which(phyMatch[,6] == ammend)[1]
              phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
            }else if(is.na(phyMatch[j,8]) == T){
              # If both Class and Species are empty
              # Subtract this Genus from Family
              ammend <- phyMatch[j,6]
              ammendRow <- which(phyMatch[,6] == ammend)[1]
              phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
            } else{
              # If I missed something, print it out
              print(phyMatch[j,])
            }
            
            
          } else if(is.na(phyMatch[j,5]) == T){
            # If Order is empty
            # When this happens, usually Family is also empty 
            
            if(is.na(phyMatch[j,6]) == T){
              # Both Order and Family are empty
              # So Genus and Species are filled
              # Subtract Species from Genus
              if(is.na(phyMatch[j,7]) != T){
                # Make sure that Genus is filled
                ammend <- phyMatch[j,7]
                ammendRow <- which(phyMatch[,7] == ammend)[1]
                phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
                #print(phyMatch[j,])
              } else {
                # If I missed something, print it out
                print(phyMatch[j,])
              }
            } else if(is.na(phyMatch[j,7]) == T){
              # If both Order and Genus are empty
              # But Family is filled
              # Subtract Species from Family
              ammend <- phyMatch[j,6]
              ammendRow <- which(phyMatch[,6] == ammend)[1]
              phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
            } else if(is.na(phyMatch[j,8]) == T){
              # If both Order and Species are Empty
              # But Family and Genus are filled
              # Subtract Genus from Family
              ammend <- phyMatch[j,6]
              ammendRow <- which(phyMatch[,6] == ammend)[1]
              phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
            }
            else {
              # If I missed something, print it out
              print(phyMatch[j,])
            }
            
          } else if(is.na(phyMatch[j,6]) == T){
            # If Family is empty, then either Genus or Species should be empty
            # Calculation-wise, it doesn't matter which one is empty because I'll be subtracting reads from Order either way
            # But I'm splitting them up to make double-checking the code easier
            
            if(is.na(phyMatch[j,7]) == T){
              # If both Family and Genus are empty (meaning Species is filled)
              # Subtract this Species count from Order
              ammend <- phyMatch[j,5]
              ammendRow <- which(phyMatch[,5] == ammend)[1]
              phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
            } else if (is.na(phyMatch[j,8]) == T){
              # If both Family and Species are empty (meaning Genus is filled)
              # Subtract this Genus count from Order
              ammend <- phyMatch[j,5]
              ammendRow <- which(phyMatch[,5] == ammend)[1]
              phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
            } else if(sum(is.na(phyMatch[j,7:8])) != 2){
              # If I missed something, print it out
              print(phyMatch[j,])
            }
          }
        

##################### 1 empty ##################### 
        } else if (length(emptyTaxa) == 1){
          #print(phyMatch[j,])
          
          if(is.na(phyMatch[j,4]) == T){
            # If Class is empty
            # Subtract this Species from Genus
            ammend <- phyMatch[j,7]
            ammendRow <- which(phyMatch[,7] == ammend)[1]
            phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
          } else if(is.na(phyMatch[j,5]) == T){
            # If Order is empty
            # Subtract species from Genus
            ammend <- phyMatch[j,7]
            ammendRow <- which(phyMatch[,7] == ammend)[1]
            phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
          } else if(is.na(phyMatch[j,6]) == T){
            # If Family is empty
            # Subtract Species from Genus
            ammend <- phyMatch[j,7]
            ammendRow <- which(phyMatch[,7] == ammend)[1]
            phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
          } else if(is.na(phyMatch[j,7]) == T){
            # If Genus is empty
            # Species is filled
            # So subtract this Species from Family
            ammend <- phyMatch[j,6]
            ammendRow <- which(phyMatch[,6] == ammend)[1]
            phyMatch$reads[ammendRow] <- (phyMatch$reads[ammendRow] - phyMatch$reads[j])
          } else if(is.na(phyMatch[j,8]) != T){
            # If I missed something, print it out
            print(phyMatch[j,])
          }
          
          
        }
        

      
      }# Closes row-by-row phyMatch loop
      
      output <- rbind(output, phyMatch)
      
    } # Closes phylum-by-phylum loop
    
    # Save Unclassified row in output
    rowUnclass <- which(output$Domain == "unclassified")
    
    
    ##### Pull out taxa w/o phylum classification ###
    noPhy <- input[which(is.na(input$Phylum),),]
    
    # Remove irrelevant rows
    NA6 <- c() 
    for(k in 1:nrow(noPhy)){
      empty <- sum(is.na(noPhy[k,]))
      if(empty == 6){
        NA6 <- c(NA6, k)
        #print(NA6)
      }
    }
    noPhy <- noPhy[-NA6,]

    
    
    ########### Go through Classes (w/o Phylum classification) ########### 
    allCla <- unique(noPhy$Class)
    for(cla in 1:length(allCla)){
      # Go class-by-class
      
      claMatch <- noPhy[which(noPhy$Class == allCla[cla]),]
      
      for(l in 1:nrow(claMatch)){
        if(sum(is.na(claMatch[l,])) == 5){
          # This should be the very first appearance of the class
          # Subtract class reads from Unclassified
          output$reads[rowUnclass] <- (output$reads[rowUnclass] - claMatch$reads[l])
        } else if(sum(is.na(claMatch[l,])) == 4){
          # Subtract this Order from Class
          ammend <- claMatch[l,4]
          ammendRow <- which(claMatch[,4] == ammend)[1]
          claMatch$reads[ammendRow] <- (claMatch$reads[ammendRow] - claMatch$reads[l])
        } else if(sum(is.na(claMatch[l,])) == 3){
          # Subtract this Family from Order
          ammend <- claMatch[l,5]
          ammendRow <- which(claMatch[,5] == ammend)[1]
          claMatch$reads[ammendRow] <- (claMatch$reads[ammendRow] - claMatch$reads[l])
        } else if(sum(is.na(claMatch[l,])) == 2){
          # Subtract this Genus from Family
          ammend <- claMatch[l,6]
          ammendRow <- which(claMatch[,6] == ammend)[1]
          claMatch$reads[ammendRow] <- (claMatch$reads[ammendRow] - claMatch$reads[l])
        } else if(sum(is.na(claMatch[l,])) == 1){
          # Subtract this Species from Family
          ammend <- claMatch[l,7]
          ammendRow <- which(claMatch[,7] == ammend)[1]
          claMatch$reads[ammendRow] <- (claMatch$reads[ammendRow] - claMatch$reads[l])
        } else{
          # If I missed something, print out
          print(allCla[cla])
          print(claMatch)
        }
      } # Ends row-by-row for loop
      output <- rbind(output, claMatch)
    } # Ends class-by-class for loop
    
    
    
    
    ###########  Go through Orders (w/o Phylum or Class classifications) ########### 
    allOrd <- unique(noPhy$Order)
    for(ord in 1:length(allOrd)){
      # Go order-by-order
      
      ordMatch <- noPhy[which(noPhy$Order == allOrd[ord]),]
      if(sum(is.na(ordMatch$Class)) > 0){
        # Only use Orders that lack both Phylum and Class classifications
        for(m in 1:nrow(ordMatch)){
          # Go row-by-row
          if(sum(is.na(ordMatch[m,])) == 5){
            # First appearance of Order
            # Subtracts from Unclassified
            output$reads[rowUnclass] <- (output$reads[rowUnclass] - ordMatch$reads[m])
          } else if(sum(is.na(ordMatch[m,])) == 4){
            # Subtract this Family from Order
            ammend <- ordMatch[m,5]
            ammendRow <- which(ordMatch[,5] == ammend)[1]
            ordMatch$reads[ammendRow] <- (ordMatch$reads[ammendRow] - ordMatch$reads[m])
          } else if(sum(is.na(ordMatch[m,])) == 3){
            # Subtract this Genus from Family
            ammend <- ordMatch[m,6]
            ammendRow <- which(ordMatch[,6] == ammend)[1]
            ordMatch$reads[ammendRow] <- (ordMatch$reads[ammendRow] - ordMatch$reads[m])
          } else if(sum(is.na(ordMatch[m,])) == 2){
            # Subtract this Species from Genus
            ammend <- ordMatch[m,6]
            ammendRow <- which(ordMatch[,6] == ammend)[1]
            ordMatch$reads[ammendRow] <- (ordMatch$reads[ammendRow] - ordMatch$reads[m])
          } else {
            print(allOrd[ord])
            print(ordMatch)
          }
        } 
      }  # Ends good order-by-order for loop
    
    } # Ends order-by-order for loop
      
    
    ###########  Go through Families (w/o Phylum, Class, and Order classifications) ########### 
    allFam <- unique(noPhy$Family)
    for(fam in 1:length(allFam)){
      # family-by-family
      
      famMatch <- noPhy[which(noPhy$Family == allFam[fam]),]
      if(sum(is.na(famMatch$Order)) > 0){
          # Only use Families that lack Phylum, Class, and Order classifications
        for(n in 1:nrow(famMatch)){
          if(sum(is.na(famMatch[n,])) == 5){
            # First appearance of Family
            # Subtract from Unclassified
            output$reads[rowUnclass] <- (output$reads[rowUnclass] - ordMatch$reads[n])
          } else if(sum(is.na(famMatch[n,])) == 4){
            # Subtract this Genus from Family
            ammend <- famMatch[n,6]
            ammendRow <- which(famMatch[,6] == ammend)[1]
            famMatch$reads[ammendRow] <- (famMatch$reads[ammendRow] - famMatch$reads[n])
          } else if(sum(is.na(famMatch[n,])) == 3){
            # Subtract this Species from Genus
            ammend <- famMatch[n,7]
            ammendRow <- which(famMatch[,7] == ammend)[1]
            famMatch$reads[ammendRow] <- (famMatch$reads[ammendRow] - famMatch$reads[n])
          } else{
            print(allFam[fam])
            print(famMatch)
            }
          } # End of family row-by-row for loop
        }  # End of good family-by-family for loop
      
      output <- rbind(output, famMatch)
      
    } # End of family-by-family for loop
  
    
    
    ###########  Go through Genera (w/o Phylum, Class, Order, and Family classifications) ########### 
    allGen <- unique(noPhy$Genus)
    for(gen in 1:length(allGen)){
      # genus-by-genus
      
      genMatch <- noPhy[which(noPhy$Genus == allGen[gen]),]
      if(sum(is.na(genMatch$Family)) > 0){
        # Only use general that lack phylum, class, order, and family classifications
        for(o in 1:nrow(genMatch)){
          if(sum(is.na(genMatch[o,])) == 5){
            # First appearance of Genus
            # Subtract from unclassified
            output$reads[rowUnclass] <- (output$reads[rowUnclass] - famMatch$reads[o])
          } else if(sum(is.na(genMatch[o,])) == 4){
            # Subtract this Species from Genus
            ammend <- genMatch[o,7]
            ammendRow <- which(genMatch[,7] == ammend)[1]
            genMatch$reads[ammendRow] <- (genMatch$reads[ammendRow] - genMatch$reads[o])
          } else{
            print(allGen[gen])
            print(genMatch)
          }
        } # End of genus row-by-row for loop
        
      } # End of good genus-by-genus for loop
      
      output <- rbind(output, genMatch)
      
    } # End of genus-by-genus for loop

    
    
    
    ###########  Go through Species (w/o Phylum, Class, Order, Family, and Genus classifications) ########### 
    allSpe <- unique(noPhy$Species)
    for(spe in 1:length(allSpe)){
      # species-by-species
      
      speMatch <- noPhy[which(noPhy$Species == allSpe[spe]),]
      if(sum(is.na(speMatch)) == 5){
        # Double check that no other taxa levels are classified
        # Subtract from unclassified
        output$reads[rowUnclass] <- (output$reads[rowUnclass] - speMatch$reads)
      } else{
        #print(allSpe[spe])
        #print(speMatch)
      }
      
      output <- rbind(output, speMatch)
      
    } # End of species-by-species for loop
    
    
    reads0 <- which(output$reads == 0)
    output.rem <- output[-reads0,]
    
    outputPath <- paste(y, filePrefix[i], sep = "")
    outputPath <- paste(outputPath, "_otu_table.tsv", sep = "")
    
    write.table(output.rem, file = outputPath, sep = "\t", row.names = F)

    
  
  } # Closes file-by-file loop
  
  
} # Closes function loop
      