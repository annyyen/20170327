library(readr)
hospitalnew <- read_csv("C:/Users/user/Desktop/hospitalnew.csv")
View(hospitalnew)

# 來源：http://chienhung0304.blogspot.tw/2015/10/r-google-map.html
# Import library
install.packages("httr")
install.packages("RCurl")
install.packages("XML")
install.packages("bitops")

library(httr)
library(RCurl)
library(XML)
library(bitops)

# Google map 地址轉經緯度
geoPoint = function(address, verbose=FALSE) {
  #若未輸入地址, return錯誤
  if(verbose) cat(address,"\n")
  root = "http://maps.google.com/maps/api/geocode/"
  #Google編碼為UTF8, 中文要轉碼後帶入URL才會正確
  # address = iconv(address,"big5","utf8")
  #POI API型態(XML or JSON)
  return.call = "xml"
  sensor = "false"
  #產生URL
  url_gen = paste(root, return.call, "?address=", address, "&sensor=", sensor, sep = "")
  #擷取網頁原始碼
  html_code = xmlParse(url_gen)
  #若status為OK抓取資料, 若不為OK return status
  if(xpathSApply(html_code,"//GeocodeResponse//status",xmlValue)=="OK") {
    lat = xpathSApply(html_code,"//result//geometry//location//lat",xmlValue)
    lng = xpathSApply(html_code,"//result//geometry//location//lng",xmlValue)
    loc_type = xpathSApply(html_code,"//result//geometry//location_type",xmlValue)
    return(cbind(lat, lng, loc_type, address))
  } else {
    return(paste("Status:", xpathSApply(html_code,"//GeocodeResponse//status",xmlValue), sep = " "))
  }
}




# Demo example

addr <- c("台北市松江路124巷29號3樓", "台北市仁愛路二段88號13樓", "台北市德行東路358巷24弄10號")

res <- list()
for(i in 1:length(addr)){
  point <- geoPoint(addr[i])
  res[[i]] <- data.frame(point)
  cat(i, as.matrix(point)[1,], "\n")
  Sys.sleep(0.1)
}

tmp <- do.call(rbind, res) # 如果沒有查詢失敗可以無痛合併
distinct(tmp, address) # 移除相同地址多筆經緯度 (直接取第一筆)