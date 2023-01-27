# Library and directory ----
setwd("E:/Analysis")
library(tidyverse)
library(GenomicRanges)
?GenomicRanges

# Reading in the data ----

# Arrange the data with the standard colnames

Gene_IDs <- read_tsv("Gene IDs.tsv") %>% 
  dplyr::rename_all(~c("SystematicName","TranscriptName","Chromosome number","Strand","Start","End")) %>% 
  dplyr::group_by(`Chromosome number`) %>% 
  dplyr::group_split() # made a list, each element being a data frame for each chromosome.

# Confirm
is.data.frame(Gene_IDs[[1]])

# This is how you pick out an individual element of a list
# Gene_IDs %>% 
#   purrr::pluck(1)

# Name the elements of the list

# gave names to each element of the list - the name of the chromosome.

names(Gene_IDs) <-  Gene_IDs %>% 
  purrr::map_chr(~{
    .x %>% 
       dplyr::pull(`Chromosome number`) %>% 
       unique
  })

# Arrange the data with the standard colnames
Splice_junctions <- read_tsv("Splice junctions.tsv",col_names = F) %>% 
  dplyr::rename_all(~c("Chromosome number","Strand","Start","End")) %>% 
  dplyr::mutate(`Unique ID` = 1:n() %>% as.character()) %>% 
  dplyr::group_by(`Chromosome number`) %>% 
  dplyr::group_split()

# Name the elements of the list
names(Splice_junctions) <-  Splice_junctions %>% 
  purrr::map_chr(~{
    .x %>% 
      dplyr::pull(`Chromosome number`) %>% 
      unique
  })  

# Confirm that the names are the same
names(Gene_IDs) == names(Splice_junctions)

# Putting the data in both the files together ----
# For each chromosome's splice junctions, identify which genes the coordinates belong to
View(purrr::map2(
  .x = Splice_junctions,
  .y = Gene_IDs,
  ~{
    Splice_junctions_list_element = .x %>% 
      with(.,IRanges(Start, End))
    Gene_IDs_list_element = .y %>% 
      with(.,IRanges(Start, End,names = `TranscriptName`))
    
    findOverlapPairs(Splice_junctions_list_element,
                     Gene_IDs_list_element) %>% 
      as_tibble  %>%
      setNames(colnames(.) %>% unlist %>% str_replace("\\."," "))
  }
) %>% 
  purrr::reduce(bind_rows) %>% 
  dplyr::rename(`TranscriptName` = `second names`,
                `Gene start` = `second start`,
                `Gene end` = `second end`,
                `Splice junction start` = `first start`,
                `Splice junction end` = `first end`) %>% 
  # dplyr::mutate(SystematicName = str_replace(`TranscriptName`,"\\.\\d|\\.\\d\\d","")) %>% 
  # Joining should NOT change the total number of rows until this point after this next function
  dplyr::left_join(Gene_IDs %>% purrr::reduce(bind_rows)) %>% # Confirm the number of rows
  # If the joining has not changed the row number, then the matching of the splice junctions to their respective genes is complete
  dplyr::select(!matches("width")) %>% # Remove unncessary columns
  # I'll do one further check, I'll remove the ".digit" and see if it exactly matches the joined SystematicName in each row
  # dplyr::mutate(TestSystematicName = str_replace(TranscriptName,"\\.\\d+",""),
  #               `Matches or not` = if_else(TestSystematicName == SystematicName,T,F)) %>% 
  # If the below filter returns nothing, then we have correctly joined all the splice junctions to their respective genes
  # dplyr::filter(`Matches or not` == F) 
  # view()
  dplyr::select(matches("Splice|Gene|Name")) %>% # Further remove everything we don't need, after cross checking
  dplyr::select(matches("Name"),matches("Gene"),matches("Splice")) %>% # Rearrange, this is my OCD
  # Arrange the rows in a logical order
  dplyr::arrange(SystematicName,`TranscriptName`,`Splice junction start`) %>%
  # Use this to see how many genes are there in total and for each gene, how many junctions are there
  # This concept is called "grouping"
  dplyr::group_by(SystematicName,`TranscriptName`) %>%
  dplyr::mutate(`Order of splice junctions` = 1:n(),
                `Total splice junctions` = n()) %>% 
  # Always ungroup
  dplyr::ungroup() %>% 
  # View few at a time
  # dplyr::slice(1:100) %>% view
  write_csv("Combined file with splice junctions matched to their respective genes.csv")
