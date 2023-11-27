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

# Set target options:
tar_option_set(
  packages = c(
                  "tibble"
                , "httr"
                , 'lubridate'
                , 'janitor'
                , "future"
                , "furrr"
              
                
                
              ) # packages that your targets need to run
)

# Set Execution Options
options(clustermq.scheduler = "multiprocess")

# ===== Source Code ====

tar_source(c(
              "R/rUtils/dataCapture/apis.R"
              , "R/1__dataPreparation.R"
              , "R/2__modelCreationAndSelection.R"
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
        name = transform__stmTextProcessing
      , command = transform__stmTextProcessing(
          select__311Calls_textOnly
      )
  ),
  
  # ==== Build Models and Prepare for Selection ====
  tar_target(
      name = model__modelSearchResults
    , command = stm::searchK(
            documents = transform__stmTextProcessing$documents
          , vocab     = transform__stmTextProcessing$vocab
          , K = seq(5,20,1)
    )
  )
  
  
  # ==== Build Models and Prepare for Selection ====
  # tar_target(
  #              name = modelspace
  #            , command = fit__modelOverSearchSpace(
  #                                                     seq(5,25,5)
  #                                                   , transform__311dfmText
  #            )
  # ),
  # 
  # tar_target(
  #                  name = model_selection
  #                , command = transform__modelMetrics(
  #                              dataset = transform__311dfmText
  #                            , model_data = modelspace
  #                )
  # )
  

)
