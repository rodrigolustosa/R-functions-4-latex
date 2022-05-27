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
  writeLines(stringr::str_replace_all(paste(paste(header,collapse = " & "),"\\\\"),"_"," "),con)
  for(i in 1:n){
    line <- x[i,]
    writeLines(stringr::str_replace_all(paste(paste(line,collapse = " & "),"\\\\"),"_"," "),con)
  }
  close(con)
}
