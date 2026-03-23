library(tidyverse)

df <- read.delim("/Users/emilyfitzmeyer/Desktop/test.depth", sep = "\t",  col.names = c("reference", "genome_position", "depth"))

ggplot(df, aes(x = genome_position, y = depth)) + 
  geom_area() +
  scale_y_log10() +
  geom_hline(yintercept = 30, color = "red", linetype = "dashed", size = 0.5)




