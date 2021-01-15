require 'rails_helper'

RSpec.describe "investments/edit", type: :view do
  before(:each) do
    @investment = assign(:investment, Investment.create!(
      user: nil,
      asset: nil,
      quantity: 1,
      value_invested: "9.99"
    ))
  end

  it "renders the edit investment form" do
    render

    assert_select "form[action=?][method=?]", investment_path(@investment), "post" do

      assert_select "input[name=?]", "investment[user_id]"

      assert_select "input[name=?]", "investment[asset_id]"

      assert_select "input[name=?]", "investment[quantity]"

      assert_select "input[name=?]", "investment[value_invested]"
    end
  end
end
