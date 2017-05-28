#install.packages("readr")
library(readr)
hospitalnew <- read_csv("C:/Users/user/Desktop/hospitalnew.csv")
# View(hospitalnew)
# str(hospitalnew)

#篩選科別
category_DF <- hospitalnew[grep("兒科|婦產科|不分科|家醫科|耳鼻喉科", hospitalnew$診療科別), ]

#切割營業時間
# install.packages("tidyr")
library(tidyr)
separate_DF <- separate(category_DF, 固定看診時段, c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21")
                        , sep = "、")


# 寬表轉長表
# install.packages("reshape2")
# install.packages("dplyr")
# install.packages("data.table")
library(reshape2)
library(dplyr)
library(data.table)
setNames(separate_DF,1,"醫事機構代碼")
long <- melt(separate_DF%>%select(醫事機構代碼,starts_with("T")),id.vars = c("醫事機構代碼"))
long_DF <- separate_DF%>%gather(test,testvalue, T1:T21)


#long <- melt(separate_DF,id.vars = c("醫事機構代碼","醫事機構名稱","醫事機構種類","電話","地址","分區業務組","特約類別","服務項目","診療科別"))
#long_DF <- gather(separate_DF, 看診時段, 1:21)











