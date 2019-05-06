install.packages('RPostgreSQL')
require('RPostgreSQL')

drv <- dbDriver('PostgreSQL')
con <- dbConnect(drv, dbname = 'test',
                 host = 's19db.apan5310.com', port = 50208,
                 user = 'postgres', password = 'drv2i9es')


stmt <- "
create table category(
 cat_id              varchar(10),
 category_name       varchar(50),
 primary key (cat_id)
);


create table warehouse_managers(
  warehouse_manager_id              int,
  warehouse_manager_name           varchar(50),
  warehouse_manager_monthly_salary   int,
  warehouse_manager_phone           varchar(50),
  primary key (warehouse_manager_id)
); 


create table warehouse(
  warehouse_id           int,
  cat_id                 varchar(10),
  warehouse_location      varchar(100),
  warehouse_phone        varchar(50),
  warehouse_manager_id    int,
  primary key (warehouse_id),
  foreign key (warehouse_manager_id) references warehouse_managers(warehouse_manager_id),
  foreign key (cat_id) references category(cat_id)
);  
"

# Execute the statement to create tables
dbGetQuery(con, stmt)



### make the form of Category
cat_id <- sprintf('CA%d', 1:21)
category_name <- c('AlcoholicBeverages', 'BabyBoutique','Bakery', 'Bread','Catering','Dairy','DeliandCheese',
                   'Floral','Freezer','Grocery','HealthandBeautyAids','HouseholdEssentials','Kitchen','MealKit',
                   'Meat','NonalcoholicBeverages','PetShop','Poultry','Produce','Seafood','Snacks')
category_df <- data.frame(cat_id, category_name)
# Push category data to the database
dbWriteTable(con, name="category", value=category_df, row.names=FALSE, append=TRUE)



### make the form of Warehouse_managers
warehouse_manager_id <- sprintf('%d', 1:21)
warehouse_manager_name <- c('Gus Dobby','Leoine Lemmon','Karleen Meins','Herman Vonasek','Maryjane Baldin',
                            'Barbie Langfat','Cordelie Laflin','Bondy Suarez','Coral Hegge','Kiley Deppen',
                            'Gabi Matessian','Baudoin Feek','Kittie Board','Eulalie Knyvett','Klaus Grelak',
                            'Dorian Droghan','Ulrike Gerardet','Vilma Christofol','Gayleen Crallan','Sam Dixcee',
                            'Menard Shutler')
warehouse_manager_monthly_salary <- c(3000, 3500, 3100, 2900, 3000, 2900, 3000, 3100, 3200, 3300, 3000,
                                      2900, 3500, 3400, 2900, 2700, 2000, 3000, 3000, 3000, 2700)
warehouse_manager_phone <- c('778-679-6952','820-906-0462','705-867-6655','537-843-9114','674-937-4518','552-777-1100',
                             '734-419-5652','466-557-3824','182-272-6334','531-784-6145','124-491-1014','284-328-5445',
                             '150-311-1344','886-211-7766','595-957-1934','966-790-4688','125-763-3116','546-805-9081',
                             '641-572-3731','959-890-9051','887-129-5496')
warehouse_managers_df <- data.frame(warehouse_manager_id, warehouse_manager_name, warehouse_manager_monthly_salary, warehouse_manager_phone)
# Push warehouse_managers data to the database
dbWriteTable(con, name="warehouse_managers", value=warehouse_managers_df, row.names=FALSE, append=TRUE)



### make the form of Warehouse
warehouse_id <- sprintf('%d', 1:21)
warehouse_location <- c('19 Mayflower Street Brooklyn, NY 11211','2 Howard St. Brooklyn, NY 11215','4 Smoky Hollow St. Manhattan, NY 10002','823 Myrtle St. Bronx, NY 10469',
                        '936 Crescent St. Levittown, NY 11756', '7982 Brown Street Yonkers, NY 10701', '9076 Mammoth Street Spring Valley, NY 10977', '11 Border Street Huntington, NY 11743',
                        '41 Spruce St. Staten Island, NY 10314', '13 Sycamore Rd. Bronx, NY 10465', '9910 NE. Locust Court Bronx, NY 10466', '88 Miller St. Jamestown, NY 14701',
                        '68 North Orchard Ave. Brooklyn, NY 11216', '143 Oak Meadow Ave. Jamaica, NY 11434', '239 Rockcrest St. Woodside, NY 11377', '695 Rockwell St. Jamaica, NY 11432',
                        '7829 Bay St. Manhattan, NY 10033', '32A North Wagon Drive Bronx, NY 10463','8349 Bellevue St. Manhattan, NY 10023','908 Cherry Dr. Manhattan, NY 10003', 
                        '9853 Brandywine Drive Lockport, NY 14094')
warehouse_phone <- c('859-611-5195', '608-127-5448', '285-491-0611', '839-149-3369', '450-592-9482', '922-365-2041', '513-604-1717', '451-323-3503', '390-900-3767','625-914-4000',
                     '269-297-5386', '637-432-9560', '357-278-5136', '167-770-6781', '346-154-9897', '431-385-8925', '727-649-6911', '349-791-2321', '571-807-8625', '217-481-8053','331-426-1570')
warehouse_manager_id <- sample(warehouse_manager_id, size = 21)
warehouse_df <- data.frame(warehouse_id, cat_id, warehouse_location, warehouse_phone, warehouse_manager_id)
# Push category data to the database
dbWriteTable(con, name="warehouse", value=warehouse_df, row.names=FALSE, append=TRUE)

