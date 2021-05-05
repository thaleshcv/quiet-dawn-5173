require "reports/portfolio_report"

class DeliverReportsJob < ApplicationJob
  queue_as :default

  def perform
    Report.for_deliver_report.find_each(batch_size: 100) do |report|
      Report::DeliverPortfolioReport.perform(report)
    end
  end
end
