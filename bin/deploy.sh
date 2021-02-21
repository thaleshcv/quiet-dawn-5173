#! /bin/bash

APP_HOME="/home/ubuntu/quiet-dawn-5173"

ssh ubuntu@150.136.55.99 "bash --login -c 'cd ${APP_HOME} && git pull && bin/self_update.sh'"
