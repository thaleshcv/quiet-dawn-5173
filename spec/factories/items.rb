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
    name { "XXXXXXXX" }
    abbreviation { "XXXX0.SA" }
  end
end
