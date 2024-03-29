## R version of most popular local hotels
library(data.table)
expedia_train <- fread('train.csv', header=TRUE)
expedia_test <- fread('test.csv', header=TRUE)

sum_and_count <- function(x){
  sum(x)*0.9497 + length(x) *0.05
}

dest_id_hotel_cluster_count <- expedia_train[,sum_and_count(is_booking),by=list(srch_destination_id, hotel_cluster)]

top_five <- function(hc,v1){
  hc_sorted <- hc[order(v1,decreasing=TRUE)]
  n <- min(5,length(hc_sorted))
  paste(hc_sorted[1:n],collapse=" ")
}

dest_top_five <- dest_id_hotel_cluster_count[,top_five(hotel_cluster,V1),by=srch_destination_id]

dd <- merge(expedia_test,dest_top_five, by="srch_destination_id",all.x=TRUE)[order(id),list(id,V1)]

setnames(dd,c("id","hotel_cluster"))

write.csv(dd, file='submission_sum_and_count.csv', row.names=FALSE)


