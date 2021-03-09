#! /bin/bash

APP_HOME="/home/ubuntu/quiet-dawn-5173"

ssh ubuntu@150.136.55.99 "bash --login -c 'cd ${APP_HOME} && git pull && bin/self_update.sh'"

echo
echo "Upload public folder? [y/N]"  
read confirm

if [ $confirm == "y" || $confirm == "Y" ]; then
  rm -rf public/packs

  RAILS_ENV=production bundle exec rake assets:precompile

  echo "=== UPLOADING PUBLIC FOLDER ==="
  scp -pr public/ ubuntu@150.136.55.99:${APP_HOME}/

  echo "=== RESTARTING PASSENGER ==="
  ssh ubuntu@150.136.55.99 "bash --login -c 'cd ${APP_HOME} && passenger-config restart-app .'"

  rm -rf public/packs
fi
