# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

every(:day, at: "1:40 am") { runner "ImportItemsJob.perform_now" }
every(:hour) { runner "ImportPricesJob.perform_now" }
every(:monday, at: "3am") { runner "PortfolioReportsJob.perform_now" }
every(:day, at: %w[4am 5am 6am]) { runner "DeliverReportsJob.perform_now" }
