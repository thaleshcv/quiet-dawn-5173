FactoryBot.define do
  factory :investment do
    id { "" }
    invested_at { Date.today }
    quantity { 1 }
    value_invested { 999.9 }
    association :item
    association :user
  end
end
