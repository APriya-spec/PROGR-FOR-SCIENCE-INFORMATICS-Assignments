# Q1.
#open the sequence file in read mode 
file1 <- file("C:/Users/charu/Downloads/chr1_GL383518v1_alt.fa","r")
dna<-readLines(file1)[-1]
close(file1)
dna<- paste(dna, collapse="")

# Print the 10th and 758th letters of the sequence
cat("The 10th letter of the sequence is:", substr(dna, 10, 10), "\n")
cat("The 758th letter of the sequence is:", substr(dna, 758, 758), "\n")

# Q2. 
# Define a function for complementary sequence
complement <- function(seq_of_dna) {
  # Define pairs for DNA sequence base complementarity
  complement_map <- list("A" = "T", "T" = "A", "C" = "G", "G" = "C")
  
  # Convert sequence to uppercase
  seq_of_dna <- toupper(seq_of_dna)
  
  # Create complementary sequence and ignore characters other than A, T, G, C
  complement_seq <- sapply(strsplit(seq_of_dna, NULL)[[1]], function(base) {
    if (base %in% names(complement_map)) complement_map[[base]] else ""
  })
  paste(rev(complement_seq), collapse = "")
}

# Get reverse complement
reverse_complement <- complement(dna)
# Print the 79th letter and 500th to 800th letters of reverse complement
cat("The 79th letter of the reverse complement sequence is:", substr(reverse_complement, 79, 79), "\n")
cat("The 500th to 800th letters of the reverse complement sequence are:", substr(reverse_complement, 500, 800), "\n")

# Q3.
dna<-toupper(dna)
# Define a function to count nucleotides per kilobase
n_count <- function(sequence) {
  nuc_counts <- list()
  # iterating each kb and counting
  for (i in seq(1, nchar(dna), by=1000)) {
    kilobase <- i-1
    substring1<-substr(dna, i, min(i+999, nchar(dna)))
    # Count each time each nucleotide occured
    kb_counts <- sapply(c("A", "C", "G","T"), function(n)
      {
      sum(unlist(strsplit(substring1, NULL))==n)
    })
    nuc_counts[[as.character(kilobase)]] <- kb_counts
  }
  return(nuc_counts)
}
# Calculate and print nucleotide counts per kb
result <- n_count(dna)
print(result)

# Q4a.
# Extracting A, T, C, G counts from 1st kb
bp <- c(
  result[["0"]]["A"], 
  result[["0"]]["C"], 
  result[["0"]]["T"], 
  result[["0"]]["G"]
)
print(bp)

# Q4b.
# Create a list with nucleotide count for each kb
l1 <- lapply(result, function(pairs) as.numeric(pairs))
cat("Nucleotides in each kb are:", "\n")
print(l1)

# Q4c. 
# Print nucleotides in each kb
x <- 1
cat("Nucleotides in each kb are:\n")
for (ll in l1) {
  cat(x, " ", ll, "\n")
  x <- x + 1
}

#Q4d. 
# Print sum of each kb
cat("Sum of each kilobase:\n")
for (v in result) {
  # Sum the nucleotide count for the kb
  sum <- sum(as.numeric(v))
  cat(sum, ", ", sep = "")
}


# QUESTION 4d
cat('Sum of each kilobase:\n')
for (v in result) {
  sum <- sum(unlist(v))
  cat(sum, end = ', ')
}


#Q4e. 
#For every kilobase, the expected amount is 1000 nucleotides.
#It's true that some lists may have amounts that differ from 1000.
#The observed results could differ from the expected values because of errors, mutations in the DNA sequence, or differences in the sequencing procedure. This could be because there were not enough base pairs when summation into kbs. Furthermore, sequencing technology limitations, experimental settings, and contamination can all contribute to discrepancies between expected and observed findings.
