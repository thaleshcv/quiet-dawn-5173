# Job to import the prices of assets from an external service.
class ImportPricesJob < ApplicationJob
  queue_as :default

  def perform
    prices_attrs = Item.for_price_update.collect do |item|
      item_id, last_price_at = item

      logger.info("*** Updating price for item #{item_id}. Last update was #{last_price_at} ***")

      count = needed_price_records_count(last_price_at)

      next if count <= 1

      logger.info("*** Getting last #{count} prices for item #{item_id} ***")

      fetch_prices(item_id, count)
    end.flatten.compact

    return if prices_attrs.blank?

    Price.upsert_all(prices_attrs, unique_by: :index_prices_on_item_id_and_date)
    CurrentPrice.refresh
  end

  private

  def fetch_prices(item_id, count)
    prices = Stock::PriceService.interday(item_id, count)

    logger.info("*** #{prices.size} prices retrieved ***")

    prices.collect { |h| normalize_price_hash(h, item_id) }
  end

  # Calculates the number of days an asset has missing prices.
  def needed_price_records_count(last_price_at)
    if last_price_at.present?
      (Date.today - last_price_at.to_date).to_i
    else
      10
    end
  end

  # Normalize price attributes to be used on upsert.
  def normalize_price_hash(hash, item_id)
    Hash[
      date: Date.parse(hash["date"]),
      value: hash["price"],
      high: hash["high"],
      low: hash["low"],
      item_id: item_id
    ]
  end
end
