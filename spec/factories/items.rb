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
FactoryBot.define do
  factory :item do
    id { "" }
    name { Faker::Company.name }
    abbreviation { Faker::Finance.ticker }
  end
end
