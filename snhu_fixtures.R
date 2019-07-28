
# This is the meat of the code for our Plumber instance

# Current event subscriptions:
# channel_created
# message.channels
# file_shared
# team_join
# reaction_added

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
  else {
    print(event$type)
  }
}
