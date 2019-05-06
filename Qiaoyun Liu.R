# Establish Connection
require('RPostgreSQL')

# load driver for PostgreSQL
drv <- dbDriver('PostgreSQL')

# create connection to db
con <- dbConnect(drv, dbname = 'test',
                 host = 'localhost', port = 5432,
                 user = 'postgres', password = 'pwd4APAN5310')
sql <- "
create table supplier_df(
supplier_id     int,
supplier_name      varchar(20),
supplier_address      varchar(50),
supplier_phone      varchar(20),
supplier_email      varchar(30),
primary key (supplier_id));
"
dbGetQuery(con, sql)

sql <- "
create table items_df(
sku     varchar(10),
item_name     varchar(50),
cat_id   varchar(10),
item_price    int,
in_stock   boolean,
item_quantity   int,
item_id    int,
primary key (sku));
"
dbGetQuery(con, sql)

sql <- "
create table restocking_df(
sku    varchar(10),
restocking_date    timestamp,
days_to_last    int,
restocking_quantity     int,
unit_cost     int,
supplier_id    int,
primary key (sku),
foreign key (supplier_id) references supplier_df(supplier_id),
foreign key (sku) references items_df(sku));
"
dbGetQuery(con, sql)


# Load Dataset into date frame
items_df<-read.csv("items.csv")
restocking_df <- read.csv("restocking.csv")
supplier_df <- read.csv("supplier.csv")

View(restocking_df)
restocking_df <- subset(restocking_df, select = -1)

colnames(supplier_df) <- c('supplier_id','supplier_name','supplier_address','supplier_phone','supplier_email')
dbWriteTable(con, name = 'supplier_df', value = supplier_df, row.names = FALSE, append=TRUE)


colnames(restocking_df) <- c('restocking_date','restocking_quantity','unit_cost','supplier_id','sku','days_to_last')
restocking_df$sku <- sprintf('s%d',1:nrow(restocking_df))
dbWriteTable(con, name = 'restocking_df', value = restocking_df, row.names = FALSE, append=TRUE)

colnames(items_df) <- c('item_id','item_name','cat_id','item_price','item_quantity','in_stock','sku')
items_df$sku <- sprintf('s%d',1:nrow(items_df))
dbWriteTable(con, name = 'items_df', value = items_df, row.names = FALSE, append=TRUE)

