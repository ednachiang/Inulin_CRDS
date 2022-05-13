# Calculate standard error
se <- function(x){
  sd(x)/sqrt(length(x))
}

# Steal legend
g_legend <- function(a.gplot){
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)}

# Calculate 95% confidence intervals
# Code from = https://ggplot2tutor.com/tutorials/summary_statistics
CI.upper <- function(x){
  mean(x) + 
    qt(.975, df = length(x)) * sd(x) / sqrt(length(x))
} 

CI.lower <- function(x){
  mean(x) - 
    qt(.975, df = length(x)) * sd(x) / sqrt(length(x))
} 


# Calculate CI of difference btwn variances in 3 groups -- bootstrap
var.ci <- function(y, x){
  groups <- levels(x)
  b1 <- two.boot(sample1 = y[which(x == groups[1])],
                 sample2 = y[which(x == groups[2])],
                 FUN = var, R = 9999)
  output1 <- boot.ci(b1, conf = 0.95, type = "bca")
  
  b2 <- two.boot(sample1 = y[which(x == groups[1])],
                 sample2 = y[which(x == groups[3])],
                 FUN = var, R = 9999)
  output2 <- boot.ci(b2, conf = 0.95, type = "bca")
  
  b3 <- two.boot(sample1 = y[which(x == groups[3])],
                 sample2 = y[which(x == groups[2])],
                 FUN = var, R = 9999)
  output3 <- boot.ci(b3, conf = 0.95, type = "bca")
  
  output.df <- data.frame(matrix(nrow = 3, ncol = 4))
  colnames(output.df) <- c("Comparison", "Stat", "Lower_CI", "Upper_CI")
  output.df$Comparison <- c(paste(groups[1], "-", groups[2], sep = ""),
                            paste(groups[1], "-", groups[3], sep = ""),
                            paste(groups[3], "-", groups[2], sep = "") )
  output.df$Stat <- c(output1$t0, output2$t0, output3$t0)
  output.df$Lower_CI <- c(output1$bca[4], output2$bca[4], output3$bca[4])
  output.df$Upper_CI <- c(output1$bca[5], output2$bca[5], output3$bca[5])
  print(output.df)
  
  
}


