require "calculations"

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
#  item_id        :bigint           not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_investments_on_item_id  (item_id)
#  index_investments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (item_id => items.id)
#  fk_rails_...  (user_id => users.id)
#
class Investment < ApplicationRecord
  include Calculations

  attribute :value_invested, :money

  belongs_to :user, inverse_of: :investments
  belongs_to :item, inverse_of: :investments

  delegate :name, :abbreviation, to: :item, prefix: true, allow_nil: true

  validates_presence_of :user, :item, :quantity, :value_invested, :invested_at
  validates_numericality_of :quantity, only_integer: true, greater_than: 0

  scope :total_invested, -> { sum(:value_invested) }

  def current_value
    return if item.current_price.blank?

    @current_value ||= quantity * item.current_price.value
  end

  class << self
    def total_accumulated
      joins(:item)
        .left_joins(item: :current_price)
        .sum(<<~SQL)
          COALESCE(
            investments.quantity * current_prices.value,
            investments.value_invested::money::numeric::float8
          )
        SQL
    end

    def for_portfolio
      joins(:item)
        .left_joins(item: :current_price)
        .group("investments.user_id, items.id, items.abbreviation, items.name, current_prices.value, current_prices.date")
        .order("items.abbreviation ASC")
        .select(<<~SQL)
          investments.user_id,
          items.id AS item_id,
          items.name AS item_name,
          items.abbreviation AS item_abbr,
          COALESCE(current_prices.date, NOW()) AS position_at,
          SUM(investments.quantity) AS item_quantity,
          SUM(investments.value_invested)::money::numeric::float8 AS item_value_invested,
          COALESCE(
            SUM(investments.quantity) * current_prices.value,
            SUM(investments.value_invested)::money::numeric::float8
          ) AS item_current_value
        SQL
    end

    def for_value_accumulated_series(starting_from)
      where("investments.invested_at <= prices.date")
        .where("prices.date >= ?", starting_from.to_i.days.ago.to_date.beginning_of_day)
        .joins(item: :prices)
        .order("items.abbreviation ASC, prices.date DESC")
        .distinct
        .select(<<~SQL)
          items.abbreviation,
          prices.date,
          SUM(investments.quantity * prices.value) OVER(
            PARTITION BY prices.date
          ) AS accumulated_value
        SQL
    end

    def for_total_invested_series(starting_from)
      where("investments.invested_at <= prices.date")
        .where("prices.date >= ?", starting_from.to_i.days.ago.to_date.beginning_of_day)
        .joins(item: :prices)
        .order("items.abbreviation ASC, prices.date DESC")
        .distinct
        .select(<<~SQL)
          items.abbreviation,
          prices.date,
          SUM(investments.value_invested::money::numeric::float8) OVER(
            PARTITION BY prices.date
          ) AS total_invested
        SQL
    end
  end
end
