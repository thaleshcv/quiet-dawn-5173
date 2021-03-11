class ExploreFacade
  attr_reader :asset_id, :range_type

  delegate :title, to: :asset, prefix: true, allow_nil: true

  RANGE_ONE_DAY = "1d".freeze
  RANGE_THIRTY_DAYS = "30d".freeze
  RANGE_SIXTY_DAYS = "60d".freeze
  RANGE_NINETY_DAYS = "90d".freeze

  RANGE_TYPES = {
    RANGE_ONE_DAY => 90,
    RANGE_THIRTY_DAYS => 30,
    RANGE_SIXTY_DAYS => 60,
    RANGE_NINETY_DAYS => 90
  }.freeze

  def initialize(asset_id, range_type = RANGE_ONE_DAY)
    @asset_id = asset_id
    @range_type = range_type || RANGE_ONE_DAY
  end

  def asset_exists?
    Asset.exists?(asset_id)
  end

  def asset
    @asset ||= Asset.find(asset_id)
  end

  def prices
    @prices ||= Rails.cache.fetch("/explore/assets/#{asset_id}/#{range_type}", expires_in: 15.minutes) do
      case range_type
      when RANGE_THIRTY_DAYS, RANGE_SIXTY_DAYS, RANGE_NINETY_DAYS
        Stock::PriceService.interday(asset_id, RANGE_TYPES[range_type])
      else
        Stock::PriceService.intraday(asset_id, RANGE_TYPES[range_type])
      end
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
