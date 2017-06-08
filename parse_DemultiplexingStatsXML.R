#!/usr/bin/env Rscript

library("XML")
library("plyr")
library("reshape2")
library("ggplot2")

# load XML
file <- normalizePath("DemultiplexingStats.xml")
result <- xmlParse(file = file) # dont use symlinks!!
xml_data <- xmlToList(result)
names(xml_data)

# xml_data[["Flowcell"]][[".attrs"]]
# flowcell-id 
# "HCKYCBGX2" 

# xml_data[["Flowcell"]][[1]][[".attrs"]]

# xml_data[["Flowcell"]][["Project"]]
# names(xml_data[["Flowcell"]])


flowcell_id <- xml_data[["Flowcell"]][[".attrs"]]



# i <- 2
for(i in seq_along(xml_data[["Flowcell"]])){
    
    node <- xml_data[["Flowcell"]][i]
    
    if(names(node) == "Project" ){
        
        for(q in seq_along(node)){
            subnode <- node[[q]]
            
            if (! subnode[[".attrs"]] %in% c("all", "default")){
                project_name <- subnode[[".attrs"]]
                # print(names(node))
                print(project_name)
                print(names(subnode))
                
                for(j in seq_along(subnode)){
                    subsubnode <- subnode[[j]]
                    
                    if(names(subsubnode) == "Sample"){
                        print(subsubnode)
                    }
                }
                
            }
        }
        
    }
    
}

# get the project name
project_name_index <- which(names(xml_data[["Flowcell"]][[2]]) == ".attrs")
project_name <- xml_data[["Flowcell"]][[2]][[project_name_index]]

# remove it from the list
xml_data[["Flowcell"]][[2]] <- xml_data[["Flowcell"]][[2]][-project_name_index]



# get the barcode df for every sample
df_list <- list()
for(seqsample in xml_data[["Flowcell"]][[2]]){
    # seqsample <- xml_data[["Flowcell"]][[2]][[1]]
    sample_name <- seqsample[[".attrs"]]
    df_list[[sample_name]] <- list()
    
    for(barcode in seqsample){
        # barcode <- seqsample[[1]]
        if(".attrs" %in% names(barcode)){
            barcode_barcode <- barcode[[".attrs"]]
            barcode_df <- ldply(barcode, data.frame, 
                                sample_name = sample_name,
                                barcode = barcode_barcode)
            df_list[[sample_name]][[barcode_barcode]] <- barcode_df
        }
        
    }
}

# put all the df's into a single df
full_df <- data.frame()
for(sample in df_list){
    for(barcode in sample){
        if(nrow(full_df) < 1){
            full_df <- barcode
        } else {
            full_df <- rbind(full_df, barcode)
        }
    }
}

# clean up the df
full_df <- full_df[full_df[["barcode"]] != "all",]
full_df <- full_df[full_df[[".id"]] != ".attrs",]
colnames(full_df)[grep(pattern = '.attrs', x = colnames(full_df))] <- "Lane"
full_df <- full_df[,! colnames(full_df) %in% c(".id", "X..i..")]
full_df[["BarcodeCount"]] <- as.numeric(as.character(full_df[["BarcodeCount"]]))

# plot
ggplot(full_df, aes(x = sample_name, y = BarcodeCount/1000000)) +   geom_bar(aes(fill = Lane), position = "dodge", stat="identity") + ylab("Millions of Reads") + xlab("Sample") + ggtitle("Barcode Count per Sample per Lane") + coord_flip()
