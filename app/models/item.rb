# == Schema Information
#
# Table name: items
#
#  id           :bigint           not null, primary key
#  abbreviation :string           not null
#  name         :string           not null
#
# Indexes
#
#  index_items_on_abbreviation  (abbreviation) UNIQUE
#
class Item < ApplicationRecord
  has_many :investments, inverse_of: :item
  has_many :prices, -> { order(date: :asc) }, inverse_of: :item

  has_one :current_price

  scope :abbreviation_or_name_like, lambda { |input|
    where("UPPER(name) LIKE :input or UPPER(abbreviation) LIKE :input", input: "%#{input}%".upcase)
  }

  def title
    "#{abbreviation} #{name}"
  end

  class << self
    def for_price_update
      joins(:investments)
        .left_joins(:prices)
        .group("investments.item_id")
        .distinct
        .pluck("investments.item_id, max(prices.date)")
    end

    def with_investments(scope)
      distinct.joins(:investments).merge(scope).order(abbreviation: :asc)
    end

    def for_select_options
      order(abbreviation: :asc).collect { |a| ["#{a.abbreviation} - #{a.name}", a.id] }
    end
  end
end
