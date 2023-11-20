# INTRODUCTION

## PURPOSE

  - The purpose of this repo is to start working with introductory techniques for topic modeling and to gather resources and documentation on the topic for R and potentially python.
  
  
## Sources
- Julia Silge's Work
  |Source|Details|
  |------|-------|
  |[Evaluation](https://juliasilge.com/blog/evaluating-stm/)| Includes details on building an STM model|
  |[Details on Training](https://juliasilge.com/blog/sherlock-holmes-stm/)| includes details on parameter tuning|
  

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