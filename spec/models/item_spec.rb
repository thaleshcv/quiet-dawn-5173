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
require 'rails_helper'

RSpec.describe Asset, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
