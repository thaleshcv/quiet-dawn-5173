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

echo "=== UPDATING ASSETS ==="
bin/yarn install
RAILS_ENV=production bundle exec rake assets:precompile

echo "=== REFRESHING PACKS ==="
rm -rf public/packs
NODE_OPTIONS="--max-old-space-size=350" RAILS_ENV=production RACK_ENV=production NODE_ENV=production bin/webpack --verbose

echo "=== RESTARTING PASSENGER ==="
passenger-config restart-app .
