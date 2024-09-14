#Navigate to the user’s home directory. 
cd ~
#set up a directory named “Informatics_573”. 
mkdir Informatics_573
#Now navigate to a directory named "Informatics_573". 
cd Informatics_573
#Download all secondary assemblies for human chromosome 1 from the University of California, Santa Cruz (UCSC) Genome Browser (all chromosome 1 assemblies except “chr1.fa.gz”). Here, we can download each secondary assembly for human chromosome 1 at a time or all at a time with the help of some flags. 
wget -r -np -nd -A 'chr1_*' https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/
#Unzip all of the downloaded chromosome 1 assemblies. 
gunzip chr1_*
#Set up an empty file named "data_summary.txt"
touch data_summary.txt
#Append the file details (name, size, permissions) to "data_summary.txt"
ls -l >> data_summary.txt
#Append the first 10 lines of each of the chromosome 1 assemblies to “data_summary.txt”
head chr1_*>> data_summary.txt
#Append the name of the assembly as well as the total number of lines included in that assembly to “data_summary.txt”
wc chr1_* >> data_summary.txt
#Display the contents of "data_summary.txt"
cat data_summary.txt


