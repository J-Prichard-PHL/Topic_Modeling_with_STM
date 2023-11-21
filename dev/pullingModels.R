
t$theta %>% as.data.frame() %>% mutate(index = row_number()) %>% pivot_longer(cols = t$theta %>% as.data.frame() %>% colnames())
t <- targets::tar_read('model_selection') %>% filter(k == 20) %>% pull(topic_model) %>% .[[1]]