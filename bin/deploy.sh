#! /bin/bash

APP_HOME="/home/ubuntu/quiet-dawn-5173"

ssh ubuntu@150.136.55.99 "bash --login -c 'cd ${APP_HOME} && git pull && bin/self_update.sh'"

echo
echo "====== TO UPDATE THE ASSETS, DO THE FOLLOWING: ======="
echo
echo "rm -rf public/packs"
echo "RAILS_ENV=production bundle exec rake assets:precompile"
echo "scp -pr public/ ubuntu@150.136.55.99:${APP_HOME}/"
echo "ssh ubuntu@150.136.55.99 \"bash --login -c 'cd ${APP_HOME} && passenger-config restart-app .'\""
echo "rm -rf public/packs"
