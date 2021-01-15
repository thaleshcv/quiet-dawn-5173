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
require 'rails_helper'

RSpec.describe CurrentPrice, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
