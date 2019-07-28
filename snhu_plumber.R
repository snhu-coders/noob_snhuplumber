
# This is a work in progress Plumber instance designed to work with NoobSNHUbot

library(plumber)
library(yaml)

# Load our config here

config <- yaml.load_file("config.yml")

con <- DBI::dbConnect(
  odbc::odbc(), 
  Driver = config$db$driver, 
  Server = config$db$server, 
  Database = config$db$database, 
  Uid = config$db$username, 
  Pwd = config$db$password
)

instance <- plumb("snhu_fixtures.R")

instance$run(port=3000)
