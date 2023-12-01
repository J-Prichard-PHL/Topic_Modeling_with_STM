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
library(glue)
library(future)
library(furrr)
library(data.table)
library(glue)
library(openxlsx)

# Set target options:
tar_option_set(
  packages = c(
                  "tibble"
                , "httr"
                , 'lubridate'
                , 'janitor'
                , "future"
                , "furrr"
                , 'glue'
                , 'data.table'
                , 'openxlsx'
              
                
                
              ) # packages that your targets need to run
)

# Set Execution Options
options(clustermq.scheduler = "multiprocess")

# ===== Source Code ====

tar_source(c(
              "R/rUtils/dataCapture/apis.R"
              , "R/1__dataPreparation.R"
              , "R/2__modelCreationAndSelection.R"
              , "R/2__dataRehydration.R"
              , "R/4__writeFiles.R"
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
  
  # ==== Take only LI calls ==== 
  tar_target(
    name = filter__311Calls
    , command = filter(
        extract__311raw
      , agency_responsible == "Philly311 Contact Center"
    )
  ),
  
  # ==== Remove All Metadata ====
  tar_target(
      name = select__311Calls_textOnly
    , command = create__documentDataset(
          dataset = filter__311Calls
        , documentID = 'cartodb_id'
        , text = 'subject'
    )
  ),
  
  
  # ==== Prepare Text Documents with STM ==== 
  tar_target(
        name = data__stmTextProcessing
      , command = transform__stmTextProcessing(
          select__311Calls_textOnly
      )
  ),
  
  # ==== NOTE #TODO ====
  # As of 11.29.23, I'm commenting out the section below, because it takes about 8 hours to run 
  # it only needs to happen once every now and again though, so when we're ready for a full deployment
  # we can utilize the conditional target cue from tarchetypes to only trigger this to run on the first
  # run of the month.
  # , Add a conditional tar_cue from tarchetypes (https://search.r-project.org/CRAN/refmans/tarchetypes/html/tar_cue_skip.html)
  
  # ==== Build Models and Prepare for Selection ====
  # tar_target(
  #     name = model__modelSearchResults
  #   , command = stm::searchK(
  #           documents = transform__stmTextProcessing$documents
  #         , vocab     = transform__stmTextProcessing$vocab
  #         , K = seq(5,20,1)
  #         
  #   )
  # ),
  

  # ==== Run Selected Model ====
  tar_target(
        name = model_selectedModel
      , command = stm::stm(
                documents = data__stmTextProcessing$documents
              , vocab     = data__stmTextProcessing$vocab
              , data      = data__stmTextProcessing$meta
              , K = 16
              , max.em.its = 75
      )
  ), 
  
  # ==== Build tables for Visualization ====
    # Theta table shows us the topic rankings by document
  tar_target(
        name = data__documentTable
      , command = transform__rehydrateDataForVisualization(
          STMobject = model_selectedModel
        , ProcessedTextObject = data__stmTextProcessing
    )
  ),
  
  tar_target(
        name = data__topicTable
      , command = transform__buildTopicTable(
            STMobject = model_selectedModel
      )
  ),
  
  # ==== Print Tables to SQL
  tar_target(
        name = write__topicTable
      , command = writeFunction__toExcel(
            data = data__topicTable
          , filelocation = "dev/data"
          , filename = "topics" 
      )
  ),
  
  tar_target(
    name = write__documentTable
    , command = writeFunction__toExcel(
            data = data__documentTable
          , filelocation = "dev/data"
          , filename = "document"
    )
  ),
  
  tar_target(
      name = write__311Calls
    , command = writeFunction__toExcel(
            data = filter__311Calls
          , filelocation = "dev/data"
          , filename = "311"
    )
  )
  
)
