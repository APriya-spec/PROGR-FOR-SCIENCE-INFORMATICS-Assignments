#Question 1 
#a) 
#Load the data in “Gene_Expression_Data.xlsx”, “Gene_Information.csv”, and “Sample_Information.tsv” into Python
import pandas as pd
import numpy as np
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


