#Question 1 
#a) 
import pandas as pd
import numpy as np
#Load the data in “Gene_Expression_Data.xlsx”, “Gene_Information.csv”, and “Sample_Information.tsv” into Python
# Load Excel file
gene_expression_data = pd.read_excel('/content/Gene_Expression_Data.xlsx')  
 # Load CSV file
gene_info = pd.read_csv('/content/Gene_Information.csv')        
# Load TSV file with tab delimiter
sample_info = pd.read_csv('/content/Sample_Information.tsv', sep='\t')      

#b) 
#Change the sample names from the “Gene_Expression_Data.xlsx”, based upon the phenotype presented in “Sample_Information.tsv”
Probe = gene_expression_data['Probe_ID']
gene_expression_data.drop("Probe_ID", axis=1, inplace=True)
Phenotype_sample_type = sample_info["group"]
renamed_columns = [group + '_' + str(col) for col, group in enumerate(Phenotype_sample_type, start=1)]
gene_expression_data.columns = renamed_columns
gene_expression_data.insert(0,'Probe_ID',Probe)
print(gene_expression_data)

#c) Split the merged data from part b, into to 2 parts, based upon their labeled phenotype (ie. tumor or normal)
column_names=gene_expression_data.columns
length = len(column_names)
Tumor = pd.DataFrame()
Normal = pd.DataFrame()
for name in column_names:
    if name[0]=='t':
        Tumor[name]=gene_expression_data[name]
    if name[0]=='n':
        Normal[name]=gene_expression_data[name]
Tumor.insert(0,'Probe_ID',Probe)
print(Tumor)
Normal.insert(0,'Probe_ID',Probe)
print(Normal)

#d) Compute the average expression for each probe from the 2 data sets from part c
Tumor_average_expression = Tumor.iloc[:,1:].mean(axis=1)
print(Tumor_average_expression)
Normal_average_expression = Normal.iloc[:,1:].mean(axis=1)
print(Normal_average_expression)

#e) Determine the fold change for each probe between the two groups ((Tumour – Control) / Control)
FoldChange=(Tumor_average_expression-Normal_average_expression)/Normal_average_expression
print(FoldChange)

#f) Use the data from part e and “Gene_Information.csv” to identify all genes fold change magnitude (absolute value) was greater than 5
fold_change_data = pd.DataFrame(FoldChange)
fold_change_data.columns=['fold_change']
filtered_genes = fold_change_data[fold_change_data['fold_change'] > 5]
significant_indices = filtered_genes.index.tolist()
filtered_data = filtered_genes.reset_index().rename(columns={'index': 'Index'})
print(filtered_data)

#g) Add a column to the result of part f to include if the gene was higher expressed in “Normal” or “Tumor” samples
fold_change_genes = pd.DataFrame({'Probe_ID': gene_info['Probe_ID'], 'Fold_Change': fold_change_data['fold_change']}) # Changed to get the 'fold_change' column of 'fold_change_data'
fold_change_genes['Higher_Expression'] = np.where(fold_change_genes['Fold_Change'] > 0, 'Tumor', 'Normal')
fold_change_genes = pd.merge(fold_change_genes, gene_info[['Probe_ID', 'Chromosome']], on='Probe_ID', how='left')
fold_change_genes

#QUESTION 2
#a) Perform exploratory data analysis on the genes from part 1g
print(fold_change_genes.head())  
print(fold_change_genes.describe())  
print(fold_change_genes.info())  

import matplotlib.pyplot as plt
import seaborn as sns

#b) Count differentially expressed genes (DEGs) by chromosome
differentially_expressed_genes = fold_change_genes['Chromosome'].value_counts()

#Created a histogram showing the distribution of the number of differentially expressed genes (DEGs) by chromosome
plt.figure(figsize=(12, 6))
sns.barplot(x = differentially_expressed_genes.index, y = differentially_expressed_genes.values, palette='viridis')
plt.title('Distribution of the number of differentially expressed genes (DEGs) by chromosome')
plt.xlabel('Chromosome')
plt.ylabel('No. of DEGs')
plt.xticks(rotation=45)
plt.show()

#c) Created a histogram showing the distribution of DEGs by chromosome segregated by sample type (Normal or Tumor)
NormalGenes = fold_change_genes[fold_change_genes['Higher_Expression'] == 'Normal']
TumorGenes = fold_change_genes[fold_change_genes['Higher_Expression'] == 'Tumor']
plt.figure(figsize=(12, 6))
plt.hist(TumorGenes['Chromosome'].astype(str), color='red', label='Tumor', bins=20, alpha=0.7)
plt.hist(NormalGenes['Chromosome'].astype(str), color='green', label='Normal', bins=20, alpha=0.5)
plt.title('Distribution of DEGs by chromosome segregated by sample type (Normal or Tumor)')
plt.xlabel('Chromosome')
plt.ylabel('Frequency')
plt.xticks(rotation=90)
plt.legend(title='Higher Expression')
plt.show()

#d) Created a bar chart showing the percentages of the DEGs that are upregulated (higher) in Tumor samples and down regulated (lower) in Tumor samples
upregulated = (fold_change_genes[fold_change_genes['Higher_Expression'] == 'Tumor'].shape[0] / fold_change_genes.shape[0]) * 100
downregulated = 100 - upregulated
plt.bar(['Upregulated', 'Downregulated'], [upregulated, downregulated], color=['red', 'yellow'])
plt.xlabel('Gene Expression')
plt.ylabel('Percentage')
plt.title('Percentages of the DEGs that are upregulated (higher) in Tumor samples and down regulated (lower) in Tumor samples')
plt.show()

#e) Using the raw data from part 1b heatmap visualizing gene expression by sample is created
plt.figure(figsize=(12, 8))
sns.heatmap(gene_expression_data.set_index('Probe_ID'), cmap='viridis')
plt.title('Heatmap visualizing gene expression by sample')
plt.show()


!pip install fastcluster
import seaborn as sns
import matplotlib.pyplot as plt

#f) Using the same data from the previous part a clustermap visualizing gene expression by sample is created
gene_expression_data_cluster = gene_expression_data.drop("Probe_ID", axis=1)
sns.clustermap(gene_expression_data_cluster, cmap="viridis", figsize=(10, 8))
plt.tight_layout()
plt.show()

#g) Some chromosomes exhibit a higher concentration of differentially expressed genes (DEGs), according to the histogram of DEG per chromosome. This suggests that these chromosomes may be more responsible for the phenotypic variations between the tumor and normal samples. The bar chart indicates a distinct pattern of overexpression in tumour samples, suggesting that these genes may play a part in the development of tumors. The heatmap and clustermap provides information on the patterns of gene expression in different samples; different clusters might represent set of genes that exhibit comparable expression patterns.

 
