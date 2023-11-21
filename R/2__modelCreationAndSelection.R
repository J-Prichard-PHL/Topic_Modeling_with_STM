fit__modelOverSearchSpace <- function(
      k_space
    , dataset
){
    # Use multiple threads
    plan(multisession,workers = 2)
    
  
    # create space and attempt to fit models
    modelSpace <- tibble(
      k = k_space
    ) %>%
    mutate(topic_model = furrr::future_map(
                                           k, ~stm::stm(dataset,K=.,verbose = FALSE)
      )
    )
    
    
    return(modelSpace)
}


transform__modelMetrics <- function(
    dataset
  , model_data
){
  
  heldout <- make.heldout(dataset)
  
  temp <- model_data %>%
    mutate(exclusivity = map(topic_model, exclusivity),
           semantic_coherence = map(topic_model, semanticCoherence, dataset),
           eval_heldout = map(topic_model, eval.heldout, heldout$missing),
           residual = map(topic_model, checkResiduals, dataset),
           bound =  map_dbl(topic_model, function(x) max(x$convergence$bound)),
           lfact = map_dbl(topic_model, function(x) lfactorial(x$settings$dim$K)),
           lbound = bound + lfact,
           iterations = map_dbl(topic_model, function(x) length(x$convergence$bound)))
  
  return(temp)
  
  
  
  
}
  
