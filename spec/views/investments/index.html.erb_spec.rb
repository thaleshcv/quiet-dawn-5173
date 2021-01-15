require 'rails_helper'

RSpec.describe "investments/index", type: :view do
  before(:each) do
    assign(:investments, [
      Investment.create!(
        user: nil,
        asset: nil,
        quantity: 2,
        value_invested: "9.99"
      ),
      Investment.create!(
        user: nil,
        asset: nil,
        quantity: 2,
        value_invested: "9.99"
      )
    ])
  end

  it "renders a list of investments" do
    render
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: "9.99".to_s, count: 2
  end
end
