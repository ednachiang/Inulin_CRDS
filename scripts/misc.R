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