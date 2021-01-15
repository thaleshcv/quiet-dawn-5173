require 'rails_helper'

RSpec.describe "investments/new", type: :view do
  before(:each) do
    assign(:investment, Investment.new(
      user: nil,
      asset: nil,
      quantity: 1,
      value_invested: "9.99"
    ))
  end

  it "renders new investment form" do
    render

    assert_select "form[action=?][method=?]", investments_path, "post" do

      assert_select "input[name=?]", "investment[user_id]"

      assert_select "input[name=?]", "investment[asset_id]"

      assert_select "input[name=?]", "investment[quantity]"

      assert_select "input[name=?]", "investment[value_invested]"
    end
  end
end
