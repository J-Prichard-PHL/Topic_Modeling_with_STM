#'transform__rehydrateDataForVisualization
#'
#'Purpose: to build a tableau-able dataset rehydrated from an STM object, an
#'stm processed text object, and a base dataset.
#'
#'Input:
#'  @STMobject
#'  @ProcessedTextObject
#'  @BaseDataset
#'Returns:
#'
#'
#'
transform__rehydrateDataForVisualization <- function(
    STMobject
  , ProcessedTextObject
){

  # Make Data Table
  table <- stm::make.dt(STMobject, ProcessedTextObject$meta)
  
  # Melt Table
  table <- data.table::melt(table
                   , id.vars = c("document","docnum")) %>%
           as.data.frame() %>%
           group_by(document) %>%
           mutate(rank = rank(-value)) %>%
           ungroup()
  
  
  # output
  return(table)
  
}



transform__buildTopicTable <- function(
      STMobject
  )
{
  # Generate Table
  descriptions <- stm::labelTopics(STMobject, n = 10)$prob %>%
               as.data.frame() %>% 
               mutate(topic = row.names(.)) %>% 
               pivot_longer(cols = -topic) %>% 
               group_by(topic) %>% 
               summarize(desc = paste(value,collapse = ', '))
  
  # Add proportions
  proportions <- STMobject$theta %>%
                  colMeans(.) %>% 
                  list(Proportion = .) %>%
                  as.data.frame() %>%
                  mutate(topic = row.names(.))
  
  # merge
  table <- merge(descriptions, proportions)


  # return Table
  
  return(table)
  
  
  
}