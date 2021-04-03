require "reports/portfolio_report"

class DeliverReportsJob < ApplicationJob
  queue_as :default

  def perform
    Report.not_delivered.includes(:user).find_each(batch_size: 100) do |report|
      report_path = "tmp/reports/#{report.report_name}"

      PortfolioReport.new(report_path, report.portfolio_items).generate

      PortfolioMailer
        .with(user: report.user, report_path: report_path)
        .report_email
        .deliver_now

      report.delivered_now!
    end
  end
end
