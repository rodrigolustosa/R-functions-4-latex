# ----------------------------------------------------------------------- #
# Information: Some R functions (one for now) I made to better integrate R 
# and LaTeX.
# Created by: Rodrigo Lustosa
# Creation date: 27 May 2022 17:23 (GMT -03)
# ----------------------------------------------------------------------- #


# write a data frame as a file in the same format as a tabular in LaTeX
# you can open the file and just copy and paste in LaTeX
# R packages used: stringr
write_latexTable <- function(x,file,caption="",pos="htbp",align="c",label="tab:",
                             centering = TRUE, siunitx_package = FALSE){
  # inner functions
  make_latexTable_line <- function(raw_line){
    final_line <- paste(raw_line,collapse = " & ")
    final_line <- paste(final_line,"\\\\")
    final_line <- paste("\t\t\t",final_line,sep = "")
    final_line <- stringr::str_replace_all(final_line,"_"," ")
    return(final_line)
  }
  wrt_tbl_env_start <- function(con,pos,caption,centering){
    # base
    tbl_string_begin <- "\\begin{table}"
    tbl_string_centering <- "\\centering"
    tbl_string_caption <- "\\caption"
    # add info given by user
    tbl_string_begin   <- paste(tbl_string_begin,"[",pos,"]",sep = "")
    tbl_string_caption <- paste(tbl_string_caption,"{",caption,"}",sep = "")
    # add tabs
    tbl_string_begin     <- paste("\t",tbl_string_begin,sep = "")
    tbl_string_centering <- paste("\t\t",tbl_string_centering,sep = "")
    tbl_string_caption   <- paste("\t\t",tbl_string_caption,sep = "")
    # write lines
    writeLines(tbl_string_begin,con)
    if(centering)
      writeLines(tbl_string_centering,con)
    writeLines(tbl_string_caption,con)
  }
  wrt_tblr_env_start <- function(con,n_col,align){
    # base
    tblr_string_begin <- "\\begin{tabular}"
    # correct number of columns
    n_given <- str_count(align)
    if(n_given == 1)
      align <- paste(rep(align,n_col),collapse = "")
    # add info given by user
    tblr_string_begin <- paste(tblr_string_begin,"{",align,"}",sep = "")
    # add tabs
    tblr_string_begin <- paste("\t\t",tblr_string_begin,sep = "")
    # write lines
    writeLines(tblr_string_begin,con)
  }
  wrt_tbl_env_end <- function(con,label){
    # base
    tbl_string_label <- "\\label"
    tbl_string_end <- "\\end{table}"
    # add info given by user
    tbl_string_label <- paste(tbl_string_label,"{",label,"}",sep = "")
    # add tabs
    tbl_string_label <- paste("\t\t",tbl_string_label,sep = "")
    tbl_string_end   <- paste("\t",tbl_string_end,sep = "")
    # write lines
    writeLines(tbl_string_label,con)
    writeLines(tbl_string_end,con)
  }
  wrt_tblr_env_end <- function(con){
    # base
    tblr_string_end <- "\\end{tabular}"
    # add tabs
    tblr_string_end <- paste("\t\t",tblr_string_end,sep = "")
    # write lines
    writeLines(tblr_string_end,con)
  }
  wrt_tabular <- function(con,x,align,siunitx_package){
    # coersing a possible tibble to a dataframe
    x <- data.frame(x)
    
    # extracting basic info
    n <- nrow(x)
    n_col <- ncol(x)
    header <- names(x)
    
    # start tabular environment
    wrt_tblr_env_start(con,n_col,align)
    
    # add commands from siunitx package
    if(siunitx_package)
      for(j in 1:ncol(x))
        if(class(x[,j]) == "numeric")
          # \num{} is a command from siunitx package which 
          # makes numbers format more pleasant
          x[,j] <- paste("\\num{",x[,j],"}",sep="")
    
    # write header and lines
    header_save <- make_latexTable_line(header)
    writeLines(header_save,con)
    for(i in 1:n){
      line <- x[i,]
      line_save <- make_latexTable_line(line)
      writeLines(line_save,con)
    }
    
    # end tabular environment
    wrt_tblr_env_end(con)
  }
  
  # open file
  con <- file(file,"w")
  # start table environment
  wrt_tbl_env_start(con,pos,caption,centering)
  # write tabular
  wrt_tabular(con,x,align,siunitx_package)
  # end table environment
  wrt_tbl_env_end(con,label)
  # close file
  close(con)
}
