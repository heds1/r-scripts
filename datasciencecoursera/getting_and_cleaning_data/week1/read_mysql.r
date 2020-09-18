library(MySQL)

# doesn't connect, probably because of work firewall
my_db <- dbConnect(
    MySQL(),
    dbname = 'ailMel1',
    user = 'genome',
    host = 'genome-mysql.cse.ucsc.edu')

allTables <- dbListTables(my_db)

result <- dbGetQuery(
    my_db, 'show databases;'
); dbDisconnect(my_db)

# get columns from table
dbListFields(db, 'table')

dbGetQuery(db, 'query')

# example of get number of rows: "SELECT COUNT(*) FROM <table>"

df <- dbReadTable(db, 'table')

# e.g. if table too big to read into r
query <- dbSendQuery(df, 'SELECT * FROM <table> where <column> BETWEEN 1 AND 3')

# only returns quantile or whatever function you want (isntead of the whole
# original query)
<table><mis> <- fetch(query; quantile(<table><column>))

# only get 10 rows
<table>small <- fetch(query, n = 10); dbClearResult(query);
