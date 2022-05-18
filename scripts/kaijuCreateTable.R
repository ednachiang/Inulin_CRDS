# x = This is the folder where all of your kaiju files are located
# y = Output directory
# USE ' ' AROUND X and Y!!!

library(plyr)
library(dplyr)
library(tidyr)

kaijuCreateTable <- function(x,y) {
  
  # Load in all outside variables before you start the 'for' loop
  filePrefix <- substr(list.files(x), 1, 5)
  samps <- unique(filePrefix)
  print(samps)
  n <- length(samps)

  
  for(i in 1:n){
    
    sampFiles <- which(filePrefix == samps[i])
    use <- grep("phylum", list.files(x)[sampFiles])
    useuse <- which(list.files(x) == list.files(x)[sampFiles][use])
    path <- paste(x, list.files(x)[useuse], sep = "")
    phylum <- read.table(path, sep = "\t", header = T)
    phylum <- phylum[,-1:-2]
    phylum <- phylum[,-2]
    phylum <- separate(phylum, 2, into = c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species", "Empty"), sep = ";", remove = T)
    phylum <- phylum[,-ncol(phylum)]
    
    
    use <- grep("class", list.files(x)[sampFiles])
    useuse <- which(list.files(x) == list.files(x)[sampFiles][use])
    path <- paste(x, list.files(x)[useuse], sep = "")
    class <- read.table(path, sep = "\t", header = T)
    class <- class[,-1:-2]
    class <- class[,-2]
    class <- separate(class, 2, into = c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species", "Empty"), sep = ";", remove = T)
    class <- class[,-ncol(class)]
      
    use <- grep("order", list.files(x)[sampFiles])
    useuse <- which(list.files(x) == list.files(x)[sampFiles][use])
    path <- paste(x, list.files(x)[useuse], sep = "")
    order <- read.table(path, sep = "\t", header = T)
    order <- order[,-1:-2]
    order <- order[,-2]
    order <- separate(order, 2, into = c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species", "Empty"), sep = ";", remove = T)
    order <- order[,-ncol(order)]
    
    use <- grep("family", list.files(x)[sampFiles])
    useuse <- which(list.files(x) == list.files(x)[sampFiles][use])
    path <- paste(x, list.files(x)[useuse], sep = "")
    family <- read.table(path, sep = "\t", header = T)
    family <- family[,-1:-2]
    family <- family[,-2]
    family <- separate(family, 2, into = c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species", "Empty"), sep = ";", remove = T)
    family <- family[,-ncol(family)]

    use <- grep("genus", list.files(x)[sampFiles])
    useuse <- which(list.files(x) == list.files(x)[sampFiles][use])
    path <- paste(x, list.files(x)[useuse], sep = "")
    genus <- read.table(path, sep = "\t", header = T)
    genus <- genus[,-1:-2]
    genus <- genus[,-2]
    genus <- separate(genus, 2, into = c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species", "Empty"), sep = ";", remove = T)
    genus <- genus[,-ncol(genus)]

    use <- grep("species", list.files(x)[sampFiles])
    useuse <- which(list.files(x) == list.files(x)[sampFiles][use])
    path <- paste(x, list.files(x)[useuse], sep = "")
    species <- read.table(path, sep = "\t", header = T, quote = "\"")
    species <- species[,-1:-2]
    species <- species[,-2]
    species <- separate(species, 2, into = c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species", "Empty"), sep = ";", remove = T)
    species <- species[,-ncol(species)]
    
    
    for(j in 1:nrow(phylum)){
      cla.row <- which(class$Phylum == phylum$Phylum[j])
      cla.use <- class[cla.row,]
      phylum$reads[j] <- phylum$reads[j] - sum(cla.use$reads)
      

      for(k in 1:nrow(cla.use)){
        ord.row <- which(order$Class == cla.use$Class[k])
        ord.use <- order[ord.row,]
        cla.row2 <- which(class$Class == cla.use$Class[k])
        class$reads[cla.row2] <- class$reads[cla.row2] - sum(ord.use$reads)
        

        for(l in 1:nrow(ord.use)){
          fam.row <- which(family$Order == ord.use$Order[l])
          fam.use <- family[fam.row,]
          ord.row2 <- which(order$Order == ord.use$Order[l])
          order$reads[ord.row2] <- order$reads[ord.row2] - sum(fam.use$reads)
          

          for(m in 1:nrow(fam.use)){
            gen.row <- which(genus$Family == fam.use$Family[m])
            gen.use <- genus[gen.row,]
            fam.row2 <- which(family$Family == fam.use$Family[m])
            family$reads[fam.row2] <- family$reads[fam.row2] - sum(gen.use$reads)
            

            for(o in 1:nrow(gen.use)){
              spe.row <- which(species$Genus == gen.use$Genus[o])
              spe.use <- species[spe.row,]
              gen.row2 <- which(genus$Genus == gen.use$Genus[o])
              genus$reads[gen.row2] <- genus$reads[gen.row2] - sum(spe.use$reads)
              }
          }
        }
      }
    }
    
    savePath <- paste(y, samps[i], sep = "")
    savePath <- paste(savePath, ".tsv", sep = "")
    print(savePath)
  
    combined.df <- rbind(phylum, class, order, family, genus, species)
    
    rem <- which(combined.df$reads == 0)
    combined.df <- combined.df[-rem,]
    
    write.table(combined.df, file = savePath, sep = "\t", row.names = F)

  }
  
}
  
