#Q1. 
# Define file path
file <- 'c:/Users/charu/Downloads/chr1_GL383518v1_alt.fa'
# Create a blank string at first for storing the sequence.
sequence <- ""
# Ignore the header line and read the file line by line.
con <- file(file, "r")
line <- readLines(con, warn = FALSE)
close(con)
# Loop to build the sequenc by ignoring the header
for (i in seq_along(line)) {
  if (!grepl("^>", line[i])) {
    sequence <- paste0(sequence, gsub("\\n", "", line[i]))
  }
}
# Print the 10th and 758th letters of the sequence
#Q1a. 
cat("The 10th letter of the sequence is:", substr(sequence, 10, 10), "\n")
#Q1b. 
cat("The 758th letter of the sequence is:", substr(sequence, 758, 758), "\n")


#Q2. 
#By defining a list (comp) that associates each base with its complement, the complementary DNA for the DNA sequence is created.
Complement_bases <- list("A" = "T", "T" = "A", "C" = "G", "G" = "C", "a" = "t", "t" = "a", "c" = "g", "g" = "c")
Reverse_Complement <- strsplit(sequence, "")[[1]]
Reverse_Complement <- rev(Reverse_Complement)
RevComp_Seq <- sapply(Reverse_Complement, function(x) Complement_bases[[x]])
RevComp_Seq <- paste(RevComp_Seq, collapse = "")
#Q2a. 
print(paste("The 79th letter of the sequence is:", substr(RevComp_Seq, 79, 79)))
#Q2b. 
print("The 500th through the 800th letters of the sequence are:")
cat(substr(RevComp_Seq, 500, 800), "\n")

                      
#Q3. 
# This function calculates nucleotide counts per kilobase using lowercase bases.
nucleotide_count <- function(sequence) {
  sequence <- tolower(sequence)
# Create a blank list at first to hold the counts for every kb.
  nuc_counts <- list()
# Calculate the no. of kb
  kb <- floor(nchar(sequence) / 1000)
  for (i in 1:kb) {
# Extract the kb sequence
    Seq <- substr(sequence, (i - 1) * 1000 + 1, i * 1000)
    # Calculate nucleotide count for the kb
    kb_count <- table(strsplit(Seq, "")[[1]])
    nuc_counts[[paste0("Seq ", i)]] <- kb_count
  }
  
  return(nuc_counts)
}
# Calculate nucleotide count per kb 
result <- nucleotide_count(sequence)
print(result)

#Q4. 
#Q4a. 
#generating a data frame displaying base counts by extracting the A, T, C, and G counts from the first kilobase.
base_a <- kb_counts[["a"]]; base_t <- kb_counts[["t"]]; base_c <- kb_counts[["c"]]; base_g <- kb_counts[["g"]]
base_count <- data.frame(
  Nucleotide = c("a", "t", "c", "g"),
  Count = c(a_count, t_count, c_count, g_count)
)
print(base_count)
#Q4b. 
l1 <- lapply(result, function(pairs) unlist(pairs))
print(l1)





