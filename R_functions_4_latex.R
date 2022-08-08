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
                             centering = TRUE, horizontal_lines = FALSE,
                             siunitx_package = FALSE, booktabs_package = FALSE,
                             cols_num=NULL,cols_error=NULL,error_digits=2){
  # checks
  if(length(cols_num) != length(cols_error))
    stop("cols_error and cols_num should have same length")
  if(length(cols_error) != 0 & siunitx_package == FALSE)
    warning("cols_error and cols_num work together with siunitx_package set to TRUE")
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
    n_given <- stringr::str_count(align)
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
  wrt_tabular <- function(con,x,align,horizontal_lines,
                          siunitx_package,booktabs_package,
                          cols_num,cols_error,error_digits){
    # coersing a possible tibble to a dataframe
    x <- data.frame(x)
    
    # extracting basic info
    n <- nrow(x)
    n_col <- ncol(x)
    n_errors <- length(cols_error)
    cols_save <- (1:n_col)[!(1:n_col %in% cols_error)] # don't save error columns
    header <- names(x)[cols_save]
    
    # start tabular environment
    wrt_tblr_env_start(con,n_col-n_errors,align)
    
    # add commands from siunitx package
    if(siunitx_package)
      for(j in cols_save)
        if(class(x[,j]) == "numeric"){
          if(j %in% cols_num){
            k <- cols_error[j == cols_num]
            error_text <- paste("\\pm",format(as.list(x[,k]),scientific=F,
                                              digits=error_digits),sep="")
            # number of zeros between coma and principal number digits
            nzeros <- ceiling(log10(1/abs(x[,j])))-1
            nzeros <- ifelse(nzeros < 0,0,nzeros)
            # number of decimal digits in principal number
            nsmall <- ceiling(log10(1/x[,k])+error_digits-1)
            nsmall <- ifelse(nsmall < 0,0,nsmall)
            # number of total digits in principal number
            digits <- floor(log10(abs(x[,j]))) + 1
            digits <- ifelse(digits<0,0,digits) + nsmall - nzeros
          } else{
            error_text <- ""
            nsmall = 0L
            digits = NA
          }
          # \num{} is a command from siunitx package which
          # makes numbers format more pleasant
          x_txt <- vector("character",n)
          for(i in 1:n)
            x_txt[i] <- format(as.list(x[i,j]),scientific=F,
                               nsmall=nsmall[i],digits=digits[i])
          x[,j] <- paste("\\num{",x_txt,error_text,"}",sep="")
        }
    
    if(booktabs_package){
      txt_top_line <- "\t\t\t\\toprule"
      txt_mid_line <- "\t\t\t\\midrule"
      txt_bot_line <- "\t\t\t\\bottomrule"
    } else {
      txt_top_line <- "\t\t\t\\hline"
      txt_mid_line <- txt_top_line
      txt_bot_line <- txt_top_line
    }
    # write header and lines
    header_save <- make_latexTable_line(header)
    if(horizontal_lines)
      writeLines(txt_top_line,con)
    writeLines(header_save,con)
    if(horizontal_lines)
      writeLines(txt_mid_line,con)
    for(i in 1:n){
      line <- x[i,cols_save]
      line_save <- make_latexTable_line(line)
      writeLines(line_save,con)
    }
    if(horizontal_lines)
      writeLines(txt_bot_line,con)
    
    # end tabular environment
    wrt_tblr_env_end(con)
  }
  
  # open file
  con <- file(file,"w")
  # start table environment
  wrt_tbl_env_start(con,pos,caption,centering)
  # write tabular
  wrt_tabular(con,x,align,horizontal_lines,
              siunitx_package,booktabs_package,
              cols_num,cols_error,error_digits)
  # end table environment
  wrt_tbl_env_end(con,label)
  # close file
  close(con)
}
