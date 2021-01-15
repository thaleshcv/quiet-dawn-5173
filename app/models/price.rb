# == Schema Information
#
# Table name: prices
#
#  id       :bigint           not null, primary key
#  date     :date             not null
#  high     :decimal(10, 2)   not null
#  low      :decimal(10, 2)   not null
#  value    :decimal(10, 2)   not null
#  asset_id :bigint           not null
#
# Indexes
#
#  index_prices_on_asset_id           (asset_id)
#  index_prices_on_asset_id_and_date  (asset_id,date) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (asset_id => assets.id)
#
class Price < ApplicationRecord
  belongs_to :asset, inverse_of: :prices
end
