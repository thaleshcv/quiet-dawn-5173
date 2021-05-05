require "rails_helper"
require "reports/portfolio_report"

RSpec.describe Report::DeliverPortfolioReport, type: :model do
  describe "#perform" do
    let!(:report) do
      build(:report,
        delivered_at: nil,
        payload: [{
          "user_id" => 1,
          "item_id" => 1,
          "item_name" => "",
          "item_abbr" => "",
          "position_at" => "2021-04-30",
          "item_quantity" => 1,
          "item_value_invested" => 1,
          "item_current_value" => 1
        }])
    end

    it "deliver created report" do
      allow(report).to receive(:report_name) { "report_name" }
      allow(report).to receive(:portfolio_items).and_call_original
      allow(report).to receive(:delivered_now!)

      Report::DeliverPortfolioReport.perform(report)

      expect(report).to have_received(:delivered_now!)
    end
  end
end
