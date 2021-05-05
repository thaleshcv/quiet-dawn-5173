require "rails_helper"

RSpec.describe ImportItemsJob, type: :job do
  ActiveJob::Base.queue_adapter = :test

  describe "#perform_now" do
    it "creates item records" do
      expect(Item).to receive(:upsert_all).with(instance_of(Array), unique_by: :abbreviation)

      VCR.use_cassette("items") { ImportItemsJob.perform_now }
    end
  end
end
