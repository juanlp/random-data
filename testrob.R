library(RSelenium)
library(rvest)



checkForServer()
startServer()
remDrv <- remoteDriver()
remDrv$open() 



remDrv$navigate("http://www.footywire.com/afl/footy/ft_match_statistics?mid=6171")

test.html <- htmlParse(remDrv$getPageSource()[[1]])


table <- remDrv$getPageSource()[[1]] %>% 
  htmlParse %>% 
  readHTMLTable

table.sel = NULL
for (i in 1:length(table)){
  if(table[i][[1]][1,1] == "Player") {table.sel = c(table.sel,i)}
}

table.sel

table[[table.sel[1]]]
table[[table.sel[2]]]

