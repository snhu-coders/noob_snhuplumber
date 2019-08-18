
# This is a work in progress Plumber instance designed to work with NoobSNHUbot

library(plumber)
library(yaml)
library(uuid)
library(DBI)
library(data.table)

# Load our config here

config <- yaml.load_file("config.yml")

### Global stuff we'll need later

# Here eventType will be used as an enum structure to centralize column names for the events table
eventType <- data.frame(
  message = "Message",
  channel_created = "Channel Created",
  reaction_added = "Reaction Added",
  team_join = "Team Join",
  file_shared = "File Shared",
  stringsAsFactors = FALSE
)


# Establish the connection to the database with the supplied information
con <- dbConnect(
  odbc::odbc(),
  Driver = config$db$driver, 
  Server = config$db$server, 
  Database = config$db$database, 
  Uid = config$db$username, 
  Pwd = config$db$password
)

# Associate the plumber instance with our file
instance <- plumb("snhu_fixtures.R")

# Start the instance
instance$run(port=443)
