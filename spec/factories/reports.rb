FactoryBot.define do
  factory :report do
    payload { {} }
    delivered_at { "2020-12-31" }
    association :user
  end
end
