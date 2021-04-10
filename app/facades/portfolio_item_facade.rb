require "calculations"

class PortfolioItemFacade
  include ActiveModel::Model
  include ActiveModel::Attributes
  include Calculations

  attribute :user_id, :integer
  attribute :item_id, :integer
  attribute :item_name, :string
  attribute :item_abbr, :string
  attribute :item_quantity, :integer
  attribute :item_value_invested, :float
  attribute :item_current_value, :float
  attribute :position_at, :date

  def value_variation_in_pct
    difference_in_percent(item_value_invested, item_current_value)
  end
end
