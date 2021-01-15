class ImportAssetsJob < ApplicationJob
  queue_as :default

  def perform
    new_assets = Stock::AssetService.new.list
    Asset.upsert_all(new_assets, unique_by: :abbreviation)
  end
end
