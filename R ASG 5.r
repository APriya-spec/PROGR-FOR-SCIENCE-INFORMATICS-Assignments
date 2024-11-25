install.packages("readxl")
install.packages("dplyr")
install.packages("tidyr")

# 1A. 
# Load libraries
library(readxl)
library(dplyr)
library(tidyr)
# Load the data 
gene_expr_data <- read_excel("C:/Users/charu/OneDrive/Desktop/Intro to prog/Homework Files/Gene_Expression_Data (1).xlsx")
gene_info <- read.csv("C:/Users/charu/OneDrive/Desktop/Intro to prog/Homework Files/Gene_Information (1).csv")
sample_info <- read.table("C:/Users/charu/OneDrive/Desktop/Intro to prog/Homework Files/Sample_Information (1).tsv", header = TRUE, sep = "\t")

#1B. 
#renaming the samples from "Gene_Expression_Data.xlsx" according with the phenotype shown in "Sample_Information.tsv"
phenotypes <- gsub("\\s.*", "", sample_info$group)
new_column_names <- paste0(phenotypes, '_', colnames(gene_expr_data)[-1])
colnames(gene_expr_data)[-1] <- new_column_names
colnames(gene_expr_data)[-1] <- new_column_names
print(gene_expr_data)

#1C. 
#Splitting the merged data into two parts based on their labeled phenotype
T_table <- gene_expr_data[, grepl("^t", colnames(gene_expr_data))]
N_table <- gene_expr_data[, grepl("^n", colnames(gene_expr_data))]
head(T_table)
head(N_table)

#1D. 
#Determining each probe's average expression across the two data sets
T_ave <- rowMeans(tumor_table[, -1])
N_ave <- rowMeans(normal_table[, -1])
head(T_ave)
head(N_ave)

print(T_ave)

#1E. 
#Calculating the fold change between the two groups for every probe
FoldChange <- (T_ave - N_ave) / N_ave
FoldChange

#1F. 
Filtered_data <- data.frame(Index = 1:length(FoldChange),FoldChange = FoldChange)
Filtered_data <- Filtered_data[abs(Filtered_data$FoldChange) > 5,]

#1G. 
fold_change_genes <- data.frame(Probe_ID = gene_expr_data$Probe_ID, FoldChange = FoldChange)
fold_change_genes$Higher_Expression <- ifelse(fold_change_genes$FoldChange > 0, "Tumor", "Normal")
fold_change_genes <- merge(fold_change_genes, gene_info[, c("Probe_ID", "Chromosome")], by = "Probe_ID", all.x = TRUE)
print(Filtered_data)
print(fold_change_genes)




#2A,B. 
library(ggplot2)
#Used part 1E's filtered data, assuming fold_change_genes is the RESULT
deg_chromosomes <- na.omit(fold_change_genes$Chromosome)  
# Create histogram
ggplot(data.frame(Chromosome = deg_chromosomes), aes(x = Chromosome)) +
  geom_histogram(stat = "count", fill = "skyblue", color = "black") +
  theme_minimal() +
  labs(title = "Distribution of DEGs by Chromosome", x = "Chromosome", y = "Number of DEGs")


#2C. 
# Create a new column for Sample Type
fold_change_genes$Sample_Type <- ifelse(fold_change_genes$Higher_Expression == "Tumor", "Tumor", "Normal")

# Filter DEGs with fold change greater than a threshold
deg_chromosomes_filtered <- fold_change_genes[abs(fold_change_genes$fold_change) > 1,]

# Create histogram segregated by Sample_Type
ggplot(deg_chromosomes_filtered, aes(x = Chromosome, fill = Sample_Type)) +
  geom_histogram(stat = "count", position = "dodge", color = "black") +
  theme_minimal() +
  labs(title = "DEGs by Chromosome and Sample Type", x = "Chromosome", y = "Number of DEGs") +
  scale_fill_manual(values = c("Normal" = "lightblue", "Tumor" = "lightcoral"))

#2D. 
# Count the number of upregulated and downregulated genes
deg_upregulated <- sum(fold_change_genes$Higher_Expression == "Tumor" & fold_change_genes$fold_change > 0)
deg_downregulated <- sum(fold_change_genes$Higher_Expression == "Normal" & fold_change_genes$fold_change < 0)

# Create bar chart
deg_counts <- data.frame(
  Expression = c("Upregulated", "Downregulated"),
  Count = c(deg_upregulated, deg_downregulated)
)

ggplot(deg_counts, aes(x = Expression, y = Count, fill = Expression)) +
  geom_bar(stat = "identity", color = "black") +
  theme_minimal() +
  labs(title = "Upregulated vs Downregulated DEGs in Tumor Samples", x = "Expression", y = "Count") +
  scale_fill_manual(values = c("Upregulated" = "lightgreen", "Downregulated" = "lightpink"))

#2E. 
install.packages("pheatmap")
library(pheatmap)

# Subset gene expression data (without Probe_ID column)
gene_expr_matrix <- as.matrix(gene_expr_data[,-1])

# Generate heatmap
pheatmap(gene_expr_matrix, scale = "row", clustering_distance_rows = "euclidean", clustering_distance_cols = "euclidean",
         clustering_method = "complete", show_rownames = FALSE, show_colnames = FALSE, 
         color = colorRampPalette(c("blue", "white", "red"))(100), 
         main = "Heatmap of Gene Expression by Sample")
#2F. 
# Create clustermap (similar to heatmap but with hierarchical clustering)

# Load pheatmap library
library(pheatmap)

# Create the clustermap in R
pheatmap(gene_expr_matrix, 
         scale = "row", 
         clustering_distance_rows = "euclidean", 
         clustering_distance_cols = "euclidean",
         clustering_method = "complete", 
         show_rownames = FALSE, 
         show_colnames = FALSE, 
         color = colorRampPalette(c("blue", "white", "red"))(100), 
         main = "Clustermap of Gene Expression")

#2G. The chromosomal distribution of DEGs is shown by histograms, which also indicate particular chromosomes that may be connected to the condition due to their greater frequencies of differential expression. The largest DEG count is seen on chromosome 19, and tumour samples typically had greater expression levels. A substantial frequency of upregulated genes in tumour samples is shown in the bar chart, indicating regulatory mechanisms affecting the tumour phenotype. Distinct clustering, representing well-separated expression profiles between tumour and normal samples, is revealed by heatmap and clustermap analyses.
