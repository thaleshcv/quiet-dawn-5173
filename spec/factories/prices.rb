# == Schema Information
#
# Table name: prices
#
#  id      :bigint           not null, primary key
#  date    :date             not null
#  high    :decimal(10, 2)   not null
#  low     :decimal(10, 2)   not null
#  value   :decimal(10, 2)   not null
#  item_id :bigint           not null
#
# Indexes
#
#  index_prices_on_item_id           (item_id)
#  index_prices_on_item_id_and_date  (item_id,date) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (item_id => items.id)
#
FactoryBot.define do
  factory :price do
    id { "" }
    date { "2021-04-29" }
    high { "9.99" }
    low { "9.99" }
    value { "9.99" }
    item_id { "" }
  end
end
