# == Schema Information
#
# Table name: investments
#
#  id             :bigint           not null, primary key
#  invested_at    :date             not null
#  quantity       :integer          not null
#  value_invested :money            not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  asset_id       :bigint           not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_investments_on_asset_id  (asset_id)
#  index_investments_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (asset_id => assets.id)
#  fk_rails_...  (user_id => users.id)
#
class Investment < ApplicationRecord
  attribute :value_invested, :money

  belongs_to :user, inverse_of: :investments
  belongs_to :asset, inverse_of: :investments

  delegate :name, :abbreviation, to: :asset, prefix: true, allow_nil: true

  validates_presence_of :user, :asset, :quantity, :value_invested, :invested_at
  validates_numericality_of :quantity, only_integer: true, greater_than: 0

  def current_value
    return if asset.current_price.blank?

    @current_value ||= quantity * asset.current_price.value
  end

  class << self
    def for_portfolio
      joins(:asset)
        .left_joins(asset: :current_price)
        .group("assets.id, assets.abbreviation, assets.name, current_prices.value")
        .order("assets.abbreviation ASC")
        .select(<<~SQL)
          assets.id AS item_asset_id,
          assets.name AS item_asset_name,
          assets.abbreviation AS item_asset_abbr,
          SUM(investments.quantity) AS item_quantity,
          SUM(investments.value_invested) AS item_value_invested,
          COALESCE(
            SUM(investments.quantity) * current_prices.value,
            SUM(investments.value_invested)::money::numeric::float8
          ) AS item_current_value
        SQL
    end

    def for_value_accumulated_chart
      joins(asset: :prices)
        .order("assets.abbreviation ASC, prices.date DESC")
        .group("assets.abbreviation, prices.date")
        .select(<<~SQL)
          assets.abbreviation,
          prices.date,
          SUM(investments.quantity * prices.value) AS accumulated_value
        SQL
    end
  end
end
