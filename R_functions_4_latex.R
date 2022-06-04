# ----------------------------------------------------------------------- #
# Information: Some R functions (one for now) I made to better integrate R 
# and LaTeX.
# Created by: Rodrigo Lustosa
# Creation date: 27 May 2022 17:23 (GMT -03)
# ----------------------------------------------------------------------- #


# write a data frame as a file in the same format as a tabular in LaTeX
# you can open the file and just copy and paste in LaTeX
# R packages used: stringr
write_latexTable <- function(x,file,siunitx_package = FALSE){
  make_latexTable_line <- function(raw_line){
    final_line <- paste(raw_line,collapse = " & ")
    final_line <- paste(final_line,"\\\\")
    final_line <- stringr::str_replace_all(final_line,"_"," ")
    return(final_line)
  }
  # coersing a possible tibble to a dataframe
  x <- data.frame(x)
  # extracting basic info
  n <- nrow(x)
  n_col <- ncol(x)
  header <- names(x)
  # add commands from siunitx package
  if(siunitx_package)
    for(j in 1:ncol(x))
      if(class(x[,j]) == "numeric")
        # \num{} is a command from siunitx package which 
        # makes numbers format more pleasant
        x[,j] <- paste("\\num{",x[,j],"}",sep="")
  # write file
  con <- file(file,"w")
  header_save <- make_latexTable_line(header)
  writeLines(header_save,con)
  for(i in 1:n){
    line <- x[i,]
    line_save <- make_latexTable_line(line)
    writeLines(line_save,con)
  }
  close(con)
}
