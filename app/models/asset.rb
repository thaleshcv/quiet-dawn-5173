# == Schema Information
#
# Table name: assets
#
#  id           :bigint           not null, primary key
#  abbreviation :string           not null
#  name         :string           not null
#
# Indexes
#
#  index_assets_on_abbreviation  (abbreviation) UNIQUE
#
class Asset < ApplicationRecord
  has_many :investments, inverse_of: :asset
  has_many :prices, -> { order(date: :asc) }, inverse_of: :asset

  has_one :current_price
end
