### Write Datasets to Excel 
writeFunction__toExcel <- function(
      data
    , filelocation
    , filename
    , sheetName
)
{

  # write file
  openxlsx::write.xlsx(
      data
    , glue::glue("{filelocation}/{filename}.xlsx")
    , append = FALSE
  )
  

  
}