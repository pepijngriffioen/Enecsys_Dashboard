#!/bin/bash
# build based on https://github.com/docker-library/php/blob/master/8.5/trixie/apache/docker-php-entrypoint
set -e

echo "working on temporary dashboard folder"

cd /home/pi
rm -rf dash_temp
mkdir dash_temp
cd dash_temp

echo "Finished temporary dashboard folder"


# echo "Checking if cronjobs exists for this installation and pi user. If old dashboard cronjobs exists they will be deleted."
# #check and set cronjobs
# ## check if old crontab records are present. if so, they will be deleted for the user pi
crontab -u pi -l | grep -v 'e2pv.php' | crontab -u pi -
crontab -u pi -l | grep -v 'cron_nightly_reports.php' | crontab -u pi -
crontab -u pi -l | grep -v 'clean_log.php' | crontab -u pi -
crontab -u pi -l | grep -v 'check_log.php' | crontab -u pi -
crontab -u pi -l | grep -v 'check_gateway.php' | crontab -u pi -
crontab -u pi -l | grep -v 'alert_inverter.php' | crontab -u pi -
crontab -u pi -l | grep -v 'backupFiles.php' | crontab -u pi -
crontab -u pi -l | grep -v 'backupDB.php' | crontab -u pi -
crontab -u pi -l | grep -v 'cleanFiles.php' | crontab -u pi -

#check if cronjob exists, otherwise create it - moved to running php process
# CMD="sleep 60 && cd /var/www/html/e2pv/; php /var/www/html/e2pv/e2pv.php"
# JOB="@reboot $CMD"
# TMPC="mycron1"
# grep "$CMD" -q <(crontab -l) || (crontab -l>"$TMPC"; echo "$JOB">>"$TMPC"; crontab "$TMPC")
# rm mycron1

#check if cronjob exists, otherwise create it
CMD="cd /var/www/html/cron/; php /var/www/html/cron/cron_nightly_reports.php"
JOB="1 0 * * * $CMD"
TMPC="mycron2"
grep "$CMD" -q <(crontab -l) || (crontab -l>"$TMPC"; echo "$JOB">>"$TMPC"; crontab "$TMPC")
rm mycron2

#check if cronjob exists, otherwise create it
CMD="cd /var/www/html/backups/; php /var/www/html/backups/cleanFiles.php"
JOB="0 5 * * * $CMD"
TMPC="mycron3"
grep "$CMD" -q <(crontab -l) || (crontab -l>"$TMPC"; echo "$JOB">>"$TMPC"; crontab "$TMPC")
rm mycron3

#check if cronjob exists, otherwise create it
CMD="cd /var/www/html/e2pv/; php /var/www/html/e2pv/check_log.php"
JOB="*/10 * * * * $CMD"
TMPC="mycron4"
grep "$CMD" -q <(crontab -l) || (crontab -l>"$TMPC"; echo "$JOB">>"$TMPC"; crontab "$TMPC")
rm mycron4

#check if cronjob exists, otherwise create it
CMD="cd /var/www/html/cron/; php /var/www/html/cron/check_gateway.php"
JOB="*/30 * * * * $CMD"
TMPC="mycron5"
grep "$CMD" -q <(crontab -l) || (crontab -l>"$TMPC"; echo "$JOB">>"$TMPC"; crontab "$TMPC")
rm mycron5

#check if cronjob exists, otherwise create it
CMD="cd /var/www/html/cron/; php /var/www/html/cron/alert_inverter.php"
JOB="*/30 * * * * $CMD"
TMPC="mycron6"
grep "$CMD" -q <(crontab -l) || (crontab -l>"$TMPC"; echo "$JOB">>"$TMPC"; crontab "$TMPC")
rm mycron6

#check if cronjob exists, otherwise create it
CMD="cd /var/www/html/backups/; php /var/www/html/backups/backupFiles.php"
JOB="0 3 * * * $CMD"
TMPC="mycron7"
grep "$CMD" -q <(crontab -l) || (crontab -l>"$TMPC"; echo "$JOB">>"$TMPC"; crontab "$TMPC")
rm mycron7

#check if cronjob exists, otherwise create it
CMD="cd /var/www/html/backups/; php /var/www/html/backups/backupDB.php"
JOB="0 4 * * * $CMD"
TMPC="mycron8"
grep "$CMD" -q <(crontab -l) || (crontab -l>"$TMPC"; echo "$JOB">>"$TMPC"; crontab "$TMPC")
rm mycron8

# temp zip will be deleted to keep things clean
cd /home/pi
rm -rf /home/pi/dash_temp/

# loop to keep e2pv running if it fails.
(
  cd /var/www/html/e2pv
  while true; do
    php e2pv.php
    echo "e2pv.php exited, restarting in 5s..." >&2
    sleep 5
  done
) &

# start cron
cron

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php "$@"
fi

exec "$@"

