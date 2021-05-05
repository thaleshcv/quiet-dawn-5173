require "rails_helper"

RSpec.feature "Delete investment", type: :feature do
  before(:each) do
    current_user = create(:user, email: "capybara@test.com", password: "mastersekret")

    create(:investment,
      id: 1,
      user: current_user,
      item: create(:item, id: 1, name: "PETROBRAS", abbreviation: "PETR4.SA"),
      quantity: 1,
      value_invested: 488,
      invested_at: Date.today)

    login_as(current_user, scope: :user)
  end

  scenario "User deletes an investment", js: true do
    visit item_path(1)

    expect(page).to have_text("PETR4.SA PETROBRAS")

    accept_confirm { click_link "delete-1" }

    expect(current_path).to eq(item_path(1))
    expect(page).to have_text("Investimento excluído com sucesso")
    expect(page).to have_text("Você não tem investimentos neste item")
  end
end
