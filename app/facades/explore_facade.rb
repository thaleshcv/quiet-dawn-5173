class ExploreFacade
  attr_reader :asset_id

  def initialize(asset_id)
    @asset_id = asset_id
  end

  def asset
    @asset ||= Asset.find(asset_id)
  end

  def prices(count = 90)
    @prices ||= Rails.cache.fetch("/explore/assets/#{asset_id}/#{count}", expires_in: 10.minutes) do
      Stock::PriceService.intraday(asset_id, count)
    end
  end

  def prices_chart_data
    @prices_chart_data ||= prices.collect do |price_item|
      [DateTime.parse(price_item["date"]), price_item["price"]]
    end
  end

  def minmax_chart_value
    @minmax_chart_value ||= prices.collect { |p| p["price"].to_f }.minmax
  end

  def lowest_price
    prices.first["low"].to_f
  end

  def highest_price
    prices.first["high"].to_f
  end

  def open_price
    prices.first["open"].to_f
  end

  def current_price
    prices.first["price"].to_f
  end

  def current_price_at
    DateTime.parse(prices.first["date"])
  end

  def price_var_pct
    ((current_price / open_price) - 1) * 100
  end

  def volume
    prices.first["volume"].to_i
  end
end
