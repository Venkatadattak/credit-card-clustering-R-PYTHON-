rm(list=ls(all=T))
setwd("D:/Edwisor/clustering project")
x = c("ggplot2", "corrgram", "DMwR", "caret", "randomForest", "unbalanced", "C50", "dummies", "e1071", "Information",
      "MASS", "rpart", "gbm", "ROSE", 'sampling', 'DataCombine', 'inTrees')
lapply(x,require,character.only=TRUE)
rm(x)

## Read the data
credit <-read.csv("Credit-card-data.csv",stringsAsFactors = FALSE)

##Data Exploration
str(credit)
summary(credit)

##univariate analysis
missing_val=data.frame(apply(credit,2,function(x){sum(is.na(x))}))
missing_val$columns=row.names(missing_val)
names(missing_val)[1]="missing_percentage"
missing_val$missing_percentage=(missing_val$missing_percentage/nrow(credit))*100
missing_val=missing_val[order(-missing_val$missing_percentage),]
row.names(missing_val)=NULL
missing_val=missing_val[,c(2,1)]
write.csv(missing_val,"missing_perc.csv",row.names = F)

ggplot(data = missing_val[1:3,], aes(x=reorder(columns, -missing_percentage),y = missing_percentage))+
  geom_bar(stat = "identity",fill = "grey")+xlab("Parameter")+
  ggtitle("Missing data percentage (Train)") + theme_bw()

##KNN IMPUTATION
CUST_ID=credit$CUST_ID
credit=knnImputation(credit[,2:18],k=3)
credit=cbind(CUST_ID,credit)
write.csv(credit,"afterknnmissing.csv",row.names = F)
#In missing value analysis KNN imputation is utilised with accurate value compared to mean and median 
#so i choosed KNN imputation method to treat with missing values

#New Variables creation# 

credit$Monthly_Avg_PURCHASES <- credit$PURCHASES/credit$TENURE
credit$Monthly_CASH_ADVANCE <- credit$CASH_ADVANCE/credit$TENURE
credit$LIMIT_USAGE <- credit$BALANCE/credit$CREDIT_LIMIT
credit$MIN_PAYMENTS_RATIO <- credit$PAYMENTS/credit$MINIMUM_PAYMENTS

purchased=function(credit)
   {
     ifelse ((credit['ONEOFF_PURCHASES']==0) & (credit['INSTALLMENTS_PURCHASES']==0),
                  'none',
    ifelse((credit['ONEOFF_PURCHASES']>0) & (credit['INSTALLMENTS_PURCHASES']>0),
                  'both',
    ifelse ((credit['ONEOFF_PURCHASES']>0) & (credit['INSTALLMENTS_PURCHASES']==0),
                  'oneoff',
                  'installment')))
     }
credit$purchase_type=purchased(credit)
head(credit)
credit$purchase_type=as.factor(credit$purchase_type)

purchasetypedummy<-fastDummies::dummy_cols(credit$purchase_type)
credit1<-cbind(credit,purchasetypedummy)
credit2<-credit1[,c(-1,-23,-24)]

####OUTLIER ANALYSIS
library(openintro)
creditlog<-log1p(credit2)
summary(creditlog)
summary(credit)
col=c('BALANCE','PURCHASES','CASH_ADVANCE','TENURE','PAYMENTS','MINIMUM_PAYMENTS','PRC_FULL_PAYMENT','CREDIT_LIMIT')
creditlog1<-creditlog[,c(-1,-3,-17,-14,-15,-16,-13)]
#library(DMwR)
# remove "Species", which is a categorical column
#outlier.scores <- lofactor(numeric_data, k=5)
#plot(density(outlier.scores))
#outlier.scores
#n=nrow(numeric_data)
#pch <- rep(".", n)
#pch[outlier.scores] <- "+"
#col <- rep("black", n)
#col[outlier.scores] <- "red"
#pairs(numeric_data[,1:7], pch=pch, col=col)


sum(is.na(creditlog1))


apply(creditlog1,2,sd)

# FeatureScaling
standardised_data <- data.frame(scale(creditlog1))


###FEATURE SELECTION
## Correlation Plot 

apply(standardised_data,2,sd)
corrgram(credit1[,2:21], order = F,
         upper.panel=panel.pie, text.panel=panel.txt, main = "Correlation Plot")

##Computing PCA
credit.pca<-prcomp(standardised_data,center = TRUE,scale. = TRUE)
summary(credit.pca)
str(credit.pca)
##the 5 PCs have explained 87% of variance in data
library(ggbiplot)
ggbiplot(credit.pca)

pca_df<-credit.pca$x[,1:5]
head(pca_df)
library(clustertend)
hopkins(pca_df,n=27)


####kmeans clustering
cluster_three <- kmeans(pca_df,3)
cluster_four <- kmeans(pca_df,4)
cluster_five <- kmeans(pca_df,5)
cluster_six <- kmeans(pca_df,6)

credit_new<-cbind(pca_df,km_clust_3=cluster_three$cluster,km_clust_4=cluster_four$cluster,km_clust_5=cluster_five$cluster ,km_clust_6=cluster_six$cluster   )
credit_new=as.data.frame(credit_new)
ggplot(credit_new, aes(PC1, PC2, color = credit_new$km_clust_4)) + geom_point()


credit_new=cbind(credit1$purchase_type,pca_df,km_clust_4=cluster_four$cluster)
bigdata=cbind(credit,credit_new)
bigdata=bigdata[,c(-24,-25,-26,-27,-28,-29)]
bigdata$km_clust_4=as.factor(bigdata$km_clust_4)
#####Analysis of the clusters
credit_new<-cbind(credit,km_clust_3=cluster_three$cluster,km_clust_4=cluster_four$cluster,km_clust_5=cluster_five$cluster ,km_clust_6=cluster_six$cluster   )
View(credit_new)
# Profiling

Num_Vars2 <- c(
  "CUST_ID",
  "BALANCE",
  "BALANCE_FREQUENCY",
  "PURCHASES",
  "ONEOFF_PURCHASES",
  "INSTALLMENT_PURCHASES",
  "CASH_ADVANCE",
  "PURCHASE_FREQUENCY",
  "ONEOFF_PURCHASE_FREQUENCY",
  "PURCHASES_INSTALLMENTS_FR",
  "CASH_ADVANCE_FREQUENCY",
  "CASH_ADVANCE_TRX",
  "PURCHASE_TRX",
  "CREDIT_LIMIT",
  "PAYMENTS",
  "MIN_PAYMENTS",
  "PRC_FULL_PAYMENT",
  "TENURE",
  "MONTHLY_AVG_PURCHASE",
  "MONTHLY_CASH_ADVANCE",
  "LIMIT_USAGE",
  "MIN_PAYMENT_RATIO"
  
)

require(tables)
tt <-cbind(tabular(1+factor(km_clust_3)+factor(km_clust_4)+factor(km_clust_5)+
                     factor(km_clust_6)~Heading()*length*All(credit[1]),
                   data=credit_new),tabular(1+factor(km_clust_3)+factor(km_clust_4)+factor(km_clust_5)+
                                              factor(km_clust_6)~Heading()*mean*All(bigdata[Num_Vars2]),
                                            data=credit_new))

tt2 <- as.data.frame.matrix(tt)


rownames(tt2)<-c(
  "ALL",
  "KM3_1",
  "KM3_2",
  "KM3_3",
  "KM4_1",
  "KM4_2",
  "KM4_3",
  "KM4_4",
  "KM5_1",
  "KM5_2",
  "KM5_3",
  "KM5_4",
  "KM5_5",
  "KM6_1",
  "KM6_2",
  "KM6_3",
  "KM6_4",
  "KM6_5",
  "KM6_6")


colnames(tt2)<-c(
  "CUST_ID",
  "BALANCE",
  "BALANCE_FREQUENCY",
  "PURCHASES",
  "ONEOFF_PURCHASES",
  "INSTALLMENT_PURCHASES",
  "CASH_ADVANCE",
  "PURCHASE_FREQUENCY",
  "ONEOFF_PURCHASE_FREQUENCY",
  "PURCHASES_INSTALLMENTS_FR",
  "CASH_ADVANCE_FREQUENCY",
  "CASH_ADVANCE_TRX",
  "PURCHASE_TRX",
  "CREDIT_LIMIT",
  "PAYMENTS",
  "MIN_PAYMENTS",
  "PRC_FULL_PAYMENT",
  "TENURE",
  "MONTHLY_AVG_PURCHASE",
  "MONTHLY_CASH_ADVANCE",
  "LIMIT_USAGE",
  "MIN_PAYMENT_RATIO"
)


cluster_profiling2 <- t(tt2)

write.csv(cluster_profiling2,'cluster_profilingF.csv')
