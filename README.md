# Noob SNHUPlumber

This is a work in progress version of a quasi-RESTful API implementation done in R with `plumber`.  It will be designed specifically to accompany Noob SNHUbot.

The only important thing to know right know is that it is currently being designed to work with PostgreSQL.  This shouldn't make much of a difference so long as the correct driver is set in the config.

Speaking of `config.yml`, here is its current layout:

```yaml
db:
  driver: database_driver
  server: server_host
  database: db_name
  username: db_username
  password: db_password
```

While `snhu_fixtures.R` contains the meat of the implementation, `snhu_plumber.R` is that script that needs to execute in order to run the service.

As expected, right now the service runs but does effectively nothing.  Stay tuned for more.
