# R-functions-4-latex
Some R functions (one for now) I made to better integrate R and LaTeX.

## Functions
### write_latexTable
`write_latexTable` writes a data frame as a file in the same format as a tabular in LaTeX. You can open the file and just copy and paste it in LaTeX. Example:
```
write_latexTable(mtcars[1:3,1:5],"test.txt")
```
Inside `text.txt` you will find:
```
mpg & cyl & disp & hp & drat \\
21 & 6 & 160 & 110 & 3.9 \\
21 & 6 & 160 & 110 & 3.9 \\
22.8 & 4 & 108 & 93 & 3.85 \\
```
