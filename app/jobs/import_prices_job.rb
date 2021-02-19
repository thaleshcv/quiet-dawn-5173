# Job to import the prices of assets from an external service.
class ImportPricesJob < ApplicationJob
  queue_as :default

  def perform
    prices_attrs = Asset.for_price_update.collect do |asset|
      asset_id, last_price_at = asset

      Rails.logger.info("*** Updating price for asset #{asset_id}. Last update was #{last_price_at} ***")

      count = needed_price_records_count(last_price_at)

      next if count <= 1

      Rails.logger.info("*** Getting last #{count} prices for asset #{asset_id} ***")

      fetch_prices(asset_id, count)
    end.flatten.compact

    return if prices_attrs.blank?

    Price.upsert_all(prices_attrs, unique_by: :index_prices_on_asset_id_and_date)
    CurrentPrice.refresh
  end

  private

  def fetch_prices(asset_id, count)
    prices = Stock::PriceService.list(asset_id, count)

    Rails.logger.info("*** #{prices.size} prices retrieved ***")

    prices.collect { |h| normalize_price_hash(h, asset_id) }
  end

  # Calculates the number of days an asset has missing prices.
  # Maximum is 10.
  def needed_price_records_count(last_price_at)
    if last_price_at.present?
      (Date.today - last_price_at.to_date).to_i
    else
      10
    end
  end

  # Fixes the hash of price attributes to be used on upsert.
  def normalize_price_hash(hash, asset_id)
    hash.tap do |h|
      h["date"] = Date.parse(h["date"])
      h["value"] = h.delete("price")
      h["asset_id"] = asset_id
    end
  end
end
