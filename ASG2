#QUESTION 1 
#define the file path
file = '/content/drive/MyDrive/chr1_GL383518v1_alt.fa'
#create empty string for the whole sequence
sequence = ''
#open file and read the entire sequence
with open(file,'r') as file:
  for line in file:
    #ignore the header line (the 1st line starting with'>')
    if not line.startswith('>'):
      #remove newline chaaracters and add to sequence
       sequence += line.strip()
#print the 10th letter and 758th letter of the sequence
print(f"The 10th letter of the sequence is: {sequence[9]}")
print(f"The 758th letter of the sequence is: {sequence[757]}")

#QUESTION 2
#define a function for complementory sequence
def complement(seq_of_dna):
  #define pairs for dna sequence base complementarity
  complement = { 'A' : 'T', 'T' : 'A', 'C' : 'G', 'G' : 'C'}
  #convert sequence to uppercase
  seq_of_dna = seq_of_dna.upper()
  #create complement sequence and ignore characters other than A, T, G, C
  return ''.join(complement.get(base,'') for base in seq_of_dna if base in complement)
  #reverse the sequence
reverse_complement = complement(sequence)[::-1]
#print 79th letter and 500th to 800th letters of reverse complement
print(" The 79th letter of the reverse complement sequence is:", reverse_complement[78])
print("The 500th to 800th letters of the reverse compliment sequence are:", reverse_complement[499:800])

#QUESTION 3
def n_count(sequence):
    # Create an empty dictionary initially to store the outcomes.
    nuc_counts = {}

    # Calculate how many kilobases are contained in the sequence.
    kb = len(sequence) // 1000

    # Repeat over every kilobase in the list.
    for i in range(kb):
        # Take the sequence and extract the current kilobase.
        kilobase = sequence[i*1000:(x+1)*1000]

        # Set up an empty dictionary for storing kilobase's letter counts.
        kb_counts = {}

        # Run over every letter in the kilobase.
        for letter in kilobase:
            # Increase the letter's count if it is already in the dictionary.
            if letter in kb_counts:
                kb_counts[letter] += 1
            # If not, enter the letter with a count of 1 in the dictionary.
            else:
                kb_counts[letter] = 1

        # Include the letter counts for kilobases in the main the dictionary.
        nuc_counts[f'Kilobase {i+1}'] = kb_counts

    return nuc_counts

result = n_count(sequence)
print(result)

#QUESTION 4a
bp = [result["Kilobase 1"]["A"], result["Kilobase 1"]["C"], result["Kilobase 1"]["T"], result["Kilobase 1"]["G"]]
print(bp)

#QUESTION 4b
l1=[list(pairs.values()) for pairs in result.values()]
print('nucleotides in each kilobase:',l1)

#QUESTION 4c
x=1
print("nucleotides in Each kilobase")
for ll in list1:
    print(x," ",ll)
    x+=1

#QUESTION 4d
print('Sum of each kilobase:')
for _,v in result.items(): 
    # Here, we use function to extract each dictionary
    sum=0 #after which, make a variable named total to 0.
    for key,value in v.items(): 
       # after which retrieving every nucleotide value from every base pair once more
        sum+=value #add these values to sum
    print(sum,end=',') # print the sum 

#QUESTION 4e
#1. The expected sum of each list is 1000. 
#2. Yes, it is possible to have lists whose sums are not equal to the expected value. 
#3. The observed results may differ from the expected values due to several factors such as DNA sequence alterations, changes in the sequencing procedure, or insufficient base pairs when summation in to kbs. 
