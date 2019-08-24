
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
      event_id= UUIDgenerate(),
      event_type = eventType[1, event$type],
      event_time = as.POSIXct(as.numeric(event$event_ts), origin = "1970-01-01")
    ),
    append = TRUE
  )
}

# This function posts an ephemeral message to a user when they 
# press the "Show me" button on a spoiler message
postSpoilerResponse <- function(responseUrl, spoilerText) {
  POST(
    url=responseUrl,
    encode="json",
    body=list(
      replace_original=FALSE,
      response_type="ephemeral",
      text=paste0("Spoiler: ", spoilerText)
    )
  )
}

#' This is our events intake endpoint
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

#' This is the endpoint for the /spoiler slash command
#' @param text URL encoded text given to the function
#' @param user_id The user posting the spoiler 
#' @param response_url URL to which a response can be sent
#' @serializer unboxedJSON
#' @post /slack/spoiler
function(text, user_id, response_url) {
  
  POST(
    url=response_url,
    encode="json",
    body=list(
          response_type="in_channel",
          blocks=list(
            list(
              type="section",
              text=list(
                type="mrkdwn",
                text=paste0("<@", user_id, "> has posted a spoiler!")
              )
            ),
            list(
              type="actions",
              block_id="spoiler_block",
              elements=list(
                list(
                  type="button",
                  text=list(
                    type="plain_text",
                    text="Show me"
                  ),
                  value=text
                )
              )
            )
          )
        )
  )
  
  # Return a list destined to get turned into JSON
  return(list(text="Your spoiler has been created."))
}

#' This is the endpoint for user interactions
#' @param payload The payload received from the interaction
#' @serializer unboxedJSON
#' @post /slack/interactions
function(payload) {
  # Turn the payload into something easier to work with
  req <- fromJSON(payload)
  
  # Check to see if we know what to do with the interaction
  if (req$actions$block_id == "spoiler_block") {
    postSpoilerResponse(req$response_url, url_decode(req$actions$value))
  }
  
  # Return ok here, assuming all went well
  return(list(ok=TRUE))
}
