# Job to import the prices of assets from an external service.
class ImportPricesJob < ApplicationJob
  queue_as :default

  def perform
    prices_attrs = Item
      .for_price_update
      .collect { |item| Price::InterdayFetch.new(*item).perform }
      .flatten
      .compact

    return if prices_attrs.blank?

    Price.upsert_all(prices_attrs, unique_by: :index_prices_on_item_id_and_date)
    CurrentPrice.refresh
  end
end
