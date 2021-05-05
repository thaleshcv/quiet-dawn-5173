require "rails_helper"

RSpec.describe Report::CreatePortfolioReport, type: :model do
  describe "#perform" do
    let(:users) { build_list(:user, 1) }

    let!(:report_count) { Report.count }

    before do
      create(:investment, { user: users.first })
    end

    it "creates user's report" do
      Report::CreatePortfolioReport.perform(users)

      expect(Report.count).to eq(report_count + 1)
    end
  end
end
