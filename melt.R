#install.packages("readr")
library(readr)
hospitalnew <- read_csv("hospitalnew.csv")

# View(hospitalnew)
# str(hospitalnew)

#篩選科別
category_DF <- hospitalnew[grep("兒科|婦產科|不分科|家醫科|耳鼻喉科", hospitalnew$診療科別), ]

#切割營業時間
#install.packages("tidyr")
library(tidyr)
separate_DF <- separate(category_DF, 固定看診時段, paste0("T",c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21")))
                        , sep = "、")


# 寬表轉長表
#install.packages("reshape2")
#install.packages("Data.table")
library(reshape2)
library(Data.table)
setnames(separate_DF,1,"醫事機構代碼")
long <- melt(separate_DF%>%select(醫事機構代碼,starts_with("T")),id.vars = c("醫事機構代碼"))
long_DF <- separate_DF%>%gather(test,testvalue, T1:T21)


#切割星期，時段，看診/休診
#Tidyverse,split,column
#install.packages("tidyverse")
library("tidyverse")

long_DF$testvalue <- substr(long_DF$testvalue,1:3)
View(long_DF)


