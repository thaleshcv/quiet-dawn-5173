require "rails_helper"

RSpec.describe DeliverReportsJob, type: :job do
  ActiveJob::Base.queue_adapter = :test

  describe "#perform_now" do
    let(:report) { build(:report) }

    it "deliver created reports" do
      allow(Report).to receive_message_chain(:for_deliver_report, :find_each).and_yield(report)
      expect(Report::DeliverPortfolioReport).to receive(:perform).with(report)

      DeliverReportsJob.perform_now
    end
  end
end
