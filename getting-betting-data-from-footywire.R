library(RSelenium)
library(rvest)



checkForServer()
startServer()
remDr <- remoteDriver()
remDrv$open()


remDrv$navigate("http://www.footywire.com/afl/footy/afl_betting?year=2015")

test.html <- htmlParse(remDrv$getPageSource()[[1]]) #html is deprecated in new version of rvest


table <- remDrv$getPageSource()[[1]] %>% 
  htmlParse %>% 
  readHTMLTable


### Find which table has data (using date as indicator)
table.sel = NULL
for (i in 1:length(table)){
  if((nrow(table[[i]]) > 3) && 
                grepl("Date", as.character(table[[i]][3,1])) && 
                is.na(table[[i]][3,1]) == FALSE) {
                    table.sel = c(table.sel,i)
                    }
}

table.sel

####

table.df = table[[table.sel]]
n.col    = ncol(table.df) 

for(i in 1:n.col){
  table.df[, i] = as.character(table.df[, i])
}
#### Remove blank row ""
table.df = table.df[which(table.df$V1 != ""),]

#### Filling Round to column
table.df$Round =""
for (i in 1:nrow(table.df)){
  if (grepl("Round", as.character(table.df[i,1])) || grepl("Final", as.character(table.df[i,1]))) {
    c.round = as.character(table.df[i,1])
  }
  table.df$Round[i] = c.round
}
table.df = table.df[which(grepl("Round", as.character(table.df$V1)) == FALSE),]
table.df = table.df[which(grepl("Final", as.character(table.df$V1)) == FALSE),]
#### Give table column names
names(table.df) = c(as.character(table.df[1, 1:8]),"by","ratio",as.character(table.df[1, 9]),"Round")

#### Remove date rows
table.df = table.df[which(grepl("Date", as.character(table.df[, 1])) == FALSE),]

#### Align table
for (i in 1:nrow(table.df)){
  if(is.na(table.df$`Line Paid`[i])){
    table.df[i, 1:n.col] = c(table.df[i-1,1],table.df[i-1,2],table.df[i, 1:(n.col-2)])
  }
}
View(table.df)

write.csv(table.df, "2015.csv", row.names=F)
