#! /bin/bash

APP_HOME="${HOME}/quiet-dawn-5173"

if [[ "${RAILS_ENV}" != "production" ]]; then
  echo "Production-Only Script. Leaving...";
  exit 0
fi;

cd $APP_HOME
git pull

echo "=== RUNNING MIGRATIONS ==="
bundle exec rake db:migrate

echo "=== PRECOMPILING ASSETS ==="
bundle exec rake assets:precompile

echo "=== RESTARTING PASSENGER ==="
passenger-config restart-app .