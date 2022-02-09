# x = folder where your summarized kaiju files are (output of kaijuSummarize.py)
# y = metadata path
# USE ' ' AROUND X!!!

kaijuCreatePhyseq <- function(x, y) {
  files <- list.files(x, pattern = ".csv")
    # List of all .csv files
  
  # Import metadata
  meta <- read.csv(y, header=T)
  meta.samp <- sample_data(meta)
  sample_names(meta.samp) <- meta$ID
  meta.samp$Season <- ordered(meta$Season, levels=c("Summer", "Winter", "Spring"))
  
  
  for(taxon in 1:length(files)){
    
    path <- paste(x, files[taxon], sep = '')
    df <- read.csv(path, row.names = 1)
    rownames(df) <- df[,1]
    df <- df[,-1]
    
    df.otu <- otu_table(df, taxa_are_rows = T)
    
    # Create tax table
    tax <- data.frame(full = taxa_names(df.otu))
    tax <- cbind(tax, colsplit(rownames(df), pattern = ";", names = c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species")))
    rownames(tax) <- rownames(df)
    tax.tbl <- tax_table(tax)
    taxa_names(tax.tbl) <- taxa_names(df.otu)
    
    # Create phyloseq object
    physeq <- merge_phyloseq(tax.tbl, df.otu, meta.samp)

    # Save phyloseq object
    fileName <- strsplit(files[taxon], split = "[.]")
    taxonLevel <- unlist(fileName)[1]
    output <- paste(x, taxonLevel, ".RData", sep ="")
    save(physeq, file = output)
    
  }
}