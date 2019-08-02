
# This is the meat of the code for our Plumber instance

# Current event subscriptions:
# channel_created
# message.channels
# file_shared
# team_join
# reaction_added



# This function logs individual events to the db in the events table that is specified
# in the config.

logEventToDb <- function(event) {
  dbWriteTable(
    con,
    config$tables$events,
    data.frame(
      EventId = UUIDgenerate(),
      EventType = eventType[1, event$type],
      EventTime = as.POSIXct(as.numeric(event$event_ts), origin = "1970-01-01")
    ),
    append = TRUE
  )
}


#' This is our intake function
#' @param challenge The challenge value from Slack, if provided
#' @param event The event recieved from Slack, if provided
#' @post /slack/events
function(challenge=NULL, event=NULL){
  if (!is.null(challenge)) {
    # If the challenge is provided, Slack wishes it to be
    # returned as a response.
    
    return (challenge)
  }
  
  if (!is.null(event)) {
    logEventToDb(event)
  }
}
