# R-functions-4-latex
Some R functions (one for now) I made to better integrate R and LaTeX.

## Functions
### write_latexTable

`write_latexTable` writes a data frame as a file in the same format as a tabular inside a table in LaTeX. You can open the file and just copy and paste it in LaTeX. Example:
```
write_latexTable(mtcars[1:3,1:5], "test.txt")
```
Inside `text.txt` you will find:
```
	\begin{table}[htbp]
		\centering
		\caption{}
		\begin{tabular}{ccccc}
			mpg & cyl & disp & hp & drat \\
			21 & 6 & 160 & 110 & 3.9 \\
			21 & 6 & 160 & 110 & 3.9 \\
			22.8 & 4 & 108 & 93 & 3.85 \\
		\end{tabular}
		\label{tab:}
	\end{table}
```

You can pass more information to `write_latexTable` like caption, table position in text, columns alignment and table label. For example:
```
write_latexTable(mtcars[1:3,1:5], "test.txt", caption="Some information", pos="h", align="r|cccc", label="tab:example")
```
Inside `text.txt` now you will find:
```
	\begin{table}[h]
		\centering
		\caption{Some information}
		\begin{tabular}{r|cccc}
			mpg & cyl & disp & hp & drat \\
			21 & 6 & 160 & 110 & 3.9 \\
			21 & 6 & 160 & 110 & 3.9 \\
			22.8 & 4 & 108 & 93 & 3.85 \\
		\end{tabular}
		\label{tab:example}
	\end{table}
```

With the `horizontal_lines` parameter, you can also draw horizontal lines in your table. Setting it to `TRUE` will make a horizontal line above and bellow the header and bellow all lines. There is also compatibility with the *booktabs* Latex package. Setting `booktabs_package` to `TRUE` will change all `\hline` text to `\topruler`, `\midruler` and `\bottomruler`, depending on its position. 
