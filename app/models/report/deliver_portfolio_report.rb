# frozen_string_literal: true

module Report::DeliverPortfolioReport
  extend self

  def perform(report)
    report_path = "tmp/reports/#{report.report_name}"

    PortfolioReport.new(report_path, report.portfolio_items).build

    PortfolioMailer
      .with(user: report.user, report_path: report_path)
      .report_email
      .deliver_now

    # report.delivered_now!
  end
end
