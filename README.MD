# INTRODUCTION

## PURPOSE

  - The purpose of this repo is to start working with introductory techniques for topic modeling and to gather resources and documentation on the topic for R and potentially python.
  
  
## Sources
  |Source|Details|Local Name|
  |------|-------|----------|
  |[Evaluation](https://juliasilge.com/blog/evaluating-stm/)| Includes details on building an STM model.  Human readable by Julia Silge||
  |[Details on Training](https://juliasilge.com/blog/sherlock-holmes-stm/)| includes details on parameter tuning. Human readable by Julia Silge||
  |[STM Vignette](https://cran.r-project.org/web/packages/stm/vignettes/stmVignette.pdf)| Official vignette by the STM team.|stmVignette.pdf|
  |[Topic Models](https://www.cs.columbia.edu/~blei/papers/BleiLafferty2009.pdf)|Introduction to Topic Modeling|TopicModels__BleiLafferty2009.pdf|
  
  
  

## Packages
 - [STM](https://cran.r-project.org/web/packages/stm/stm.pdf)

## Walkthroughs and Execution
 - First: Get data from 311
 - Julia Silge's
   - Data preparation(?)
     - Cast to Tidy Text format > DFM
   - Build TF_IDF model for comparison model
   - Build STM Mode
     - Preparation: Build a document term matrix
     - Topic selection count: We'll need a way to automate this.