
## source('work.R')

WD <- "h:/Users/SkyDrive/Coursera/JHDataScience/Git/PML - Prediction Assignment Writeup/"

setwd(WD)

library("knitr"); library("markdown");

Paste <- function(...) {paste(...,sep="")}

FN <- "readme"
FR <- Paste(FN,".Rmd")
FM <- Paste(FN,".md")
FH <- Paste(FN,".html")

knit2html(FR, output = FM)
markdownToHTML(FM, output = FH)

tcmd <- "c:/command/tcmd/bin/Totalcmd.exe /O /S=L "
system(Paste(tcmd,WD,FH))




