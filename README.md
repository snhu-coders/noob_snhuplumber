# Noob SNHUPlumber

This is a work in progress version of a quasi-RESTful API implementation done in R with `plumber`.  It is being designed specifically to accompany [Noob SNHUbot](https://github.com/snhu-coders/noob_snhubot).

While `snhu_fixtures.R` contains the meat of the implementation, `snhu_plumber.R` is that script that needs to execute in order to run the service.

## Current working features

### Event logging

NoobSNHUPlumber is designed to accept POST requests from Slack at the `/slack/events` endpoint.  When a particular event is posted, namely: `message`, `channel_created`, `reaction_added`, `team_join`, or `file_shared`, the event is logged to a SQL database with an ID, event type, and event time.

Information required for this feature should be stored in `config.yml` in the following format:

```yaml
db:
  driver: database_driver
  server: server_host
  database: db_name
  username: db_username
  password: db_password
tables:
  events: events_table
```
### /spoiler slash command

This command allows users to post spoiler messages in Slack.  Message content is hidden until users hit the "Show me" button that is attached to the message.  Two things need to occur for this command to work:

1. Interactions for the Slack workspace need to be enabled and pointed to the `/slack/interactions` endpoint.
2. A `/spoiler` slash command needs to be added to the workspace and pointed to the `/slack/spoiler` endpoint. 
