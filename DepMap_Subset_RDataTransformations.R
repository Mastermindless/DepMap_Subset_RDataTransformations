# I recommend using data.table for its enhanced performance and 
# memory efficiency over the base R data.frame. 

# Load the data.table library
library(data.table)

# Set working directory (consider making this more flexible or removing it for GitHub)
setwd("~/Desktop/depmap_gene_exp")

# Step 2: Read the large file into a data.table named TPM
TPM <- fread("OmicsExpressionProteinCodingGenesTPMLogp1.csv")

# Display a brief summary of the first few columns and rows
print(TPM[1:5, 1:5])
print(summary(TPM[1:5, 1:5]))

# Step 3: Read the second file into another data.table named annotation
# This file contains ModelID of Model.csv file from https://depmap.org/portal/
# You can subset Model.csv this file prior the subset of OmicsExpressionProteinCodingGenesTPMLogp1.csv
# You need a selection of ModelID (cell lines)
annotation <- fread("Model-filter_Lymp_Myeloid.csv")

# Then, subset TPM to keep rows where the first column matches ModelID in annotation
TPM <- TPM[V1 %in% annotation$ModelID]

# Step 5: Subset annotation based on available samples in TPM
# Ensure the first column of TPM contains unique values
unique_samples <- unique(TPM$V1)

# Subset annotation to keep rows where ModelID matches the sample names in TPM
annotation <- annotation[ModelID %in% unique_samples]

# Transpose the TPM data.frame to switch rows and columns
t_TPM <-t(TPM)
# Display the first few rows of the transposed
head(t_TPM)
# Set the current column names of the transposed data
colnames(t_TPM)
colnames(t_TPM) <- t_TPM[1,]
colnames(t_TPM)
# Remove the first row as it's now redundant
t_TPM[1,]
t_TPM <- t_TPM[-1,] # attention only do once!
t_TPM[1,]

# Convert all columns to numeric type
t_TPM <- data.frame(lapply(data.frame(t_TPM), function(x) as.numeric(as.character(x)))) 
summary(t_TPM[,1:5])

# Now, TPM is subset based on ModelID from annotation, and annotation is subset based on available samples in TPM
write.csv(t_TPM, file = "subset_transposed_OmicsExpressionProteinCodingGenesTPMLogp1.csv")
write.csv(annotation, file = "annotation_OmicsExpressionProteinCodingGenesTPMLogp1.csv")


# save sessionInfo
sessionInfo()
writeLines(capture.output(sessionInfo()), "sessionInfo.txt")

############################---THE END---#######################################  

