this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)
cleanFun <- function(htmlString) {
  htmlString <- gsub("</tr><tr.?>","\n",htmlString)
  htmlString <- gsub("&amp;","&",htmlString)
  htmlString <- gsub("<.*?>", " ", htmlString)
  htmlString <- gsub("Subject *External *Internal *Total *Result"," ",htmlString)
  htmlString <- gsub(" Total Marks:","\n Total Marks:",htmlString)
  htmlString <- gsub(" +"," ",htmlString)
  return(htmlString)
}
getResult <- function(usn)
{
m<-RSelenium::checkForServer()
n <- RSelenium::startServer()
p <- require(RSelenium)
remDr <- remoteDriver(remoteServerAddr = "localhost" 
                      , port = 4444
                      , browserName = "firefox" , autoClose = TRUE
)
remDr$open()
remDr$navigate("http://results.vtu.ac.in/")
webElem <- remDr$findElement(using = 'name', value = "rid")
webElem$sendKeysToElement(list(usn, key = "enter"))
appData <- remDr$getPageSource()
if(length(grep("not yet available",as.character(appData[1]))<=0))
{
  print("Results not yet declared.")
  remDr$closeWindow()
  remDr$close()
  return
}
else
{
  cess <- do.call(rbind,strsplit(as.character(appData[1]),"\n"))
  cess <- cleanFun(cess[1,229])
  cess <- unlist(strsplit(cess, "\n", fixed=TRUE))
  remDr$closeWindow()
  remDr$close()
  msg <- toString(cess)
  print(msg)
}
}
myResult <- getResult("1MV12CS901")