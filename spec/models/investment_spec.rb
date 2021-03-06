# == Schema Information
#
# Table name: investments
#
#  id             :bigint           not null, primary key
#  invested_at    :date             not null
#  quantity       :integer          not null
#  value_invested :money            not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  item_id        :bigint           not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_investments_on_item_id  (item_id)
#  index_investments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (item_id => items.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Investment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
