require('dplyr')
require('RPostgreSQL')
require('tidyr')

# load driver for PostgreSQL
drv <- dbDriver('PostgreSQL')

# create connection to db
con <- dbConnect(drv, dbname = 'test',
                 host = 's19db.apan5310.com', port = 50208,
                 user = 'postgres', password = 'drv2i9es')
sql <- "
create table loss_reason(
 reason_id     int,
 description     varchar(50),
 primary key (reason_id));
"
dbGetQuery(con, sql)

sql <- "
create table loss_records(
 loss_id      int,
 loss_time     date,
 sku       varchar(10),
 quantity     int,
 reasons      int,
 primary key (loss_id),
 foreign key (reasons) references loss_reason(reason_id),
 foreign key (sku) references items_df(sku));
"
dbGetQuery(con, sql)

#loss_reason table
reason_id <- sprintf('%d', 1:6)
description <- c("employee carelessness", "transportation issue", "Unknown Causes", "Vendor Fraud", "Customer theft", "Employee Theft")
loss_reason <- data.frame(reason_id, description)
dbWriteTable(con, name='loss_reason', value=loss_reason, row.names=FALSE, append =TRUE)

#import datset
require(readr)
setwd('/Users/Peiling_Pili/Desktop/SQL_5310/Checkpoint4_New_PeilingMu')
items<-read_csv("items_df.csv")
loss_time_df <- read_csv("losstime_PM.csv")

#loss_records table
loss_id <- sprintf('%d', 1:70)
loss_time <- loss_time_df

RandomSelectRoW <- items[sample(nrow(items), 70), ]
sku <-  RandomSelectRoW %>% select(sku) %>%distinct()

quantity <- floor(runif(70, min=1, max=200))
reasons<-sample(reason_id, size = 70, replace=TRUE)
loss_records <- data.frame(loss_id, loss_time, sku, quantity,reasons)
dbWriteTable(con, name='loss_records', value=loss_records, row.names=FALSE, append =TRUE)

sum(loss_records$quantity)
