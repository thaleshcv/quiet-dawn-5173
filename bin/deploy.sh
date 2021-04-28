#! /bin/bash

APP_HOME="/home/ubuntu/quiet-dawn-5173"

ssh ubuntu@150.136.55.99 "bash --login -c 'cd ${APP_HOME} && git pull && bin/self_update.sh'"

echo "==== UPDATED ====="

read -p "Update packs? [y|N] " packs

if [[ $packs = "y" || $packs = "Y" ]]; then
  echo "====== UPDATING PACKS ======="
  rm -rf public/packs
  RAILS_ENV=production bundle exec rake assets:precompile
  scp -pr public/packs ubuntu@150.136.55.99:${APP_HOME}/public
  ssh ubuntu@150.136.55.99 "bash --login -c 'cd ${APP_HOME} && passenger-config restart-app .'"
  rm -rf public/packs
  bin/yarn install --check-files
fi

echo "==== DEPLOY FINISHED!!! ===="
