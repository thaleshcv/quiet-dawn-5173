require "reports/weekly_report"

class DeliverReportsJob < ApplicationJob
  queue_as :default

  def perform
    Report.not_delivered.includes(:user).find_each(batch_size: 100) do |report|
      report_name = "#{report.user.email}-#{report.created_at.to_s(:number)}.pdf"
      WeeklyReport.new("tmp/reports/#{report_name}", report.payload).generate
    end
  end
end
