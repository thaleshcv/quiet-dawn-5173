require "rails_helper"

RSpec.describe PortfolioReportsJob, type: :job do
  ActiveJob::Base.queue_adapter = :test

  describe "#perform_now" do
    let(:users) { build_list(:user, 1) }

    it "creates report records" do
      allow(User).to receive_message_chain(:for_portfolio_report, :find_in_batches).and_yield(users)
      expect(Report::CreatePortfolioReport).to receive(:perform).with(users)

      PortfolioReportsJob.perform_now
    end
  end
end
