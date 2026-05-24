# Docker setup

A lift and shift with some changes.

## Why Docker

Easy development and shipping changes more easily, also the option to easily add debug tools.

## Build

To build the new images:

```bash
make app
make db
```

## usage

```bash
cd compose
docker compose up
```

Have a look at the log lines to get the database settings. You can overwrite them in the docker-compose.yml.

To create a new user and password use the following.

```bash
ENECSYS_DBPREFIX="enecsys"
ENECYS_DB="$(openssl rand -hex 3)"
ENECSYS_DBNAME=$ENECSYS_DBPREFIX"_"$ENECYS_DB
ENECSYS_USERNAME=$ENECSYS_DBPREFIX"_"$ENECYS_DB
ENECSYS_DB_PASSWORD="$(openssl rand -hex 8)"
```

Now navigate to the following url: `localhost:8080/install_process.php`

For some reason the redirect does not work. When posting the form, use the steps in the url to go to the next screen.

Once finished, you should be able to login.

## Open points

- [ ] Fix cron jobs
  - [x] add a pi user, and introduce the cron jobs via the entrypoint.sh
  - [ ] validate cron jobs
- [ ] Get rid of the warnings
- [ ] Fix the header location
