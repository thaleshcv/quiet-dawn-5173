#! /bin/bash

echo "=== STARTING SELF-UPDATE SCRIPT ==="

APP_HOME="/home/ubuntu/quiet-dawn-5173"

if [[ -d $APP_HOME ]]; then
  echo "APP_HOME found... Let's go..."
else
  echo "APP_HOME NOT found... Leaving..."
  exit 1
fi

if [ `pwd` != $APP_HOME ]; then
  echo "=== ENTERING ${APP_HOME} ==="
  cd $APP_HOME;
fi

echo "=== INSTALLING GEMS ==="
RAILS_ENV=production bundle install --deployment

echo "=== RUNNING MIGRATIONS ==="
RAILS_ENV=production bundle exec rake db:migrate

echo "=== UPDATING CRON JOBS ==="
RAILS_ENV=production bundle exec whenever --update-crontab

echo "=== RESTARTING PASSENGER ==="
passenger-config restart-app .
