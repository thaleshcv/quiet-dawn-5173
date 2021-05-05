# frozen_string_literal: true

# This class fetches interday prices from external sources for an item.
class Price::InterdayFetch
  DEFAULT_PRICE_RECORD_COUNT = 15

  def initialize(item_id, last_price_at)
    @item_id = item_id
    @last_price_at = last_price_at
  end

  def perform
    Rails.logger.info("*** Fetching prices for item #{@item_id}. Last update was #{@last_price_at} ***")

    missing_records = missing_price_records_count
    return if missing_records <= 1

    prices = Stock::PriceService.interday(@item_id, missing_records)

    Rails.logger.info("*** #{prices.size} prices fetched ***")

    prices.collect { |h| normalize_price_hash(h) }
  end

  private

  # Calculates the number of days an asset has missing prices.
  def missing_price_records_count
    if @last_price_at.present?
      (Date.today - @last_price_at.to_date).to_i
    else
      DEFAULT_PRICE_RECORD_COUNT
    end
  end

  # Normalize price attributes to be used on upsert.
  def normalize_price_hash(hash)
    Hash[
      date: Date.parse(hash["date"]),
      value: hash["price"],
      high: hash["high"],
      low: hash["low"],
      item_id: @item_id
    ]
  end
end
