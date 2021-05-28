require "rails_helper"

RSpec.describe ImportPricesJob, type: :job do
  ActiveJob::Base.queue_adapter = :test

  describe "#perform_now" do
    let(:item_id) { 484 }

    before { create(:item, id: item_id) }

    it "creates price records" do
      allow(Item).to receive(:for_price_update).and_return([[item_id, 3.days.ago]])

      expect(Price).to receive(:upsert_all).with(instance_of(Array), unique_by: :index_prices_on_item_id_and_date)
      expect(CurrentPrice).to receive(:refresh)

      VCR.use_cassette("prices") { ImportPricesJob.perform_now }
    end
  end
end
