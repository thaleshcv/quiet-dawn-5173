#! /bin/bash

APP_HOME="/home/ubuntu/quiet-dawn-5173"

if [[ -d $APP_HOME ]]; then
  echo "APP_HOME found... Let's go..."
else
  echo "APP_HOME NOT found... Leaving..."
  exit 1
fi

echo "=== ENTERING ${APP_HOME} ==="
cd $APP_HOME
git pull

echo "=== RUNNING MIGRATIONS ==="
RAILS_ENV=production bundle exec rake db:migrate

echo "=== PRECOMPILING ASSETS ==="
RAILS_ENV=production bundle exec rake assets:precompile

echo "=== RESTARTING PASSENGER ==="
passenger-config restart-app .