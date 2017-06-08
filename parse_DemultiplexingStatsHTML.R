#!/usr/bin/env Rscript

library("XML")
library("plyr")
library("reshape2")
library("ggplot2")

# create Demultiplex_Stats.htm
# cat ${OUT_DIR}/Reports/html/*/all/all/all/laneBarcode.html | grep -v "href=" > ${OUT_DIR}/Demultiplex_Stats.htm

# load XML
setwd("/ifs/home/kellys04/projects/Clinical_580_gene_panel/molecpathlab/demultiplexed-development/demultiplexing_stats_processing")
file <- normalizePath("Demultiplex_Stats.htm")

result <- readHTMLTable(doc = file, trim = TRUE) 
str(result)
names(result)
result[[3]]
dput(colnames(result[[4]]))

# 2
flowcell_summary_colnames <- c("Clusters (Raw)", "Clusters(PF)", "Yield (MBases)")

# 3
lane_summary_colnames <- c("Lane", "Project", "Sample", "Barcode sequence", "PF Clusters", 
                           "% of thelane", "% Perfectbarcode", "% One mismatchbarcode", 
                           "Yield (Mbases)", "% PFClusters", "% >= Q30bases", "Mean QualityScore")

# 4
top_unknown_barcodes_colnames <- c("\n        Lane\n    ", "Count", "Sequence", "\n        Lane\n    ", 
                                   "Count", "Sequence", "\n        Lane\n    ", "Count", "Sequence", 
                                   "\n        Lane\n    ", "Count", "Sequence")



lane_summary_numeric_cols <- c("PF Clusters", 
                               "% of thelane", "% Perfectbarcode", "% One mismatchbarcode", 
                               "Yield (Mbases)", "% PFClusters", "% >= Q30bases", "Mean QualityScore")


lane_summary_df <- result[[3]]
# convert the values to numeric data
lane_summary_df <- cbind(lane_summary_df[, ! colnames(lane_summary_df) %in% lane_summary_numeric_cols], 
      apply(X = lane_summary_df[,lane_summary_numeric_cols], 
            MARGIN = 2, 
            FUN = function(x) x <- as.numeric(gsub(pattern = ',', replacement = '', x = x))))


# fix colnames
colnames(lane_summary_df) <- gsub(pattern = ' ', replacement = '_', x = colnames(lane_summary_df))
colnames(lane_summary_df) <- gsub(pattern = '%', replacement = 'pcnt', x = colnames(lane_summary_df))
colnames(lane_summary_df) <- gsub(pattern = '>=', replacement = 'greaterthan_equal', x = colnames(lane_summary_df))
colnames(lane_summary_df) <- gsub(pattern = '(', replacement = '_', x = colnames(lane_summary_df), fixed = TRUE)
colnames(lane_summary_df) <- gsub(pattern = ')', replacement = '', x = colnames(lane_summary_df), fixed = TRUE)

# get totals
read_sum_df <- aggregate(  PF_Clusters  ~ Sample , data = lane_summary_df, FUN = sum)



# plot
ggplot(lane_summary_df, aes(x = Sample, y = PF_Clusters/1000000)) +   geom_bar(aes(fill = Lane), position = "dodge", stat="identity") + ylab("Millions of Reads") + xlab("Sample") + ggtitle("Barcode Matched Read Count per Sample per Lane") + coord_flip()

ggplot(read_sum_df, aes(x = Sample, y = PF_Clusters/1000000)) +   geom_bar(position = "dodge", stat="identity") + ylab("Millions of Reads") + xlab("Sample") + ggtitle("Total Barcode Matched Read Count per Sample") + coord_flip()




