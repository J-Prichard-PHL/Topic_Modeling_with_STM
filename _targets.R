# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(httr)
library(lubridate)
library(janitor)
library(tidyverse)
library(stm)
library(tidytext)

# Set target options:
tar_option_set(
  packages = c(
                  "tibble"
                , "httr"
                , 'lubridate'
                , 'janitor'
              
                
                
              ) # packages that your targets need to run
)

# Set Execution Options
options(clustermq.scheduler = "multiprocess")

# ===== Source Code ====

tar_source(c(
              "R/rUtils/dataCapture/apis.R"
              , "R/1__dataPreparation.R"
          ))

# ===== Call Targets ====


list(
  
  # ===== Call Data ====
  tar_target(
             name    = extract__311raw
             , command = getData_cartoDbMonthQuery(
                       baseQuery = "SELECT * FROM public_cases_fc WHERE CLOSED_DATETIME >= "
                       , monthsOfData = 6
                       )

  ),
  
  # ==== TidyTize the Data and Cast to a DFM ==== 
  tar_target(
             name      = transform__311tidyText
             , command = create__tidyTextDataset(
                                                 extract__311raw
                                                 , stopwords      = tidytext::stop_words
                                                 , text_field     = "subject"
                                                 , document_field = "cartodb_id"
             )
  ),
  
  tar_target(
             name = transform__311dfmText
             , command = create__textMatrix(transform__311tidyText)
  ),
  
  # ==== Utilize STM Model -- Tuning ====
  tar_target(
               name = stm 
             , stm::stm(transform__311dfmText,K = 6,verbose = FALSE, init.type = "Spectral")
  )
)
