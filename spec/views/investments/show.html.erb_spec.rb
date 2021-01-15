require 'rails_helper'

RSpec.describe "investments/show", type: :view do
  before(:each) do
    @investment = assign(:investment, Investment.create!(
      user: nil,
      asset: nil,
      quantity: 2,
      value_invested: "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/9.99/)
  end
end
