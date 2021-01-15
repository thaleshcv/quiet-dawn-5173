# == Schema Information
#
# Table name: current_prices
#
#  id       :bigint
#  date     :date
#  high     :decimal(10, 2)
#  low      :decimal(10, 2)
#  value    :decimal(10, 2)
#  asset_id :bigint
#
class CurrentPrice < ApplicationRecord
  self.table_name = "current_prices"

  def readonly?
    true
  end

  def self.refresh
    ActiveRecord::Base.connection.execute("REFRESH MATERIALIZED VIEW #{table_name}")
  end
end
