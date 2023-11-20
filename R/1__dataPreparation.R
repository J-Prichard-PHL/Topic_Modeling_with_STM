# Make data Tidy

library(tidyverse)

#' create__documentDataset
#'
#' TODO: The structure of create__tidyTextDataset makes this redundant.
#' either remove it or fix the other one.
#'
#'@dataset           - dataset to be analyzed
#'@documentID        - field which identifies the text's document
#'@text              - field which provides text. 

create__documentDataset <- function(
    dataset
  , documentID
  , text
)
{
  # just a filter
  temp <- 
    dataset %>%
    mutate(
        document = dataset[[documentID]]
      , text     = dataset[[text]]
    ) %>%
    select(
      document, text
    )
  
  return(temp)
}

create__tidyTextDataset <- function(
      dataset
    , stopwords = tidytext::stop_words
    , text_field = 'text'
    , document_field = 'document'
){
  
  # TODO: Clean this method of masking.
  temp <- 
    dataset %>% 
    mutate(
        textField      = dataset[[text_field]]
      , documentField  = dataset[[document_field]] # this is cludgey
    )

  # create tidytext dataset
    temp <- 
      temp %>%
      tidytext::unnest_tokens(word,textField) %>%
      select(documentField ,word) %>%
      #TODO: This assumes the default.. Fix.
      anti_join(stopwords) %>%
      select(word,documentField)
    
  
  return(temp)
}




create__textMatrix <- function(
  dataset    
)
{
  # return text matric
  temp <- 
    dataset %>%
    count(documentField,word,sort = TRUE) %>%
    tidytext::cast_dfm(documentField,word,n)
  
  return(temp)
}
  