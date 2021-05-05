require "rails_helper"

RSpec.feature "Edit investment", type: :feature do
  before(:each) do
    current_user = create(:user, email: "capybara@test.com", password: "mastersekret")

    petrobras = create(:item, id: 1, name: "PETROBRAS", abbreviation: "PETR4.SA")
    create(:item, id: 2, name: "VALE SA", abbreviation: "VALE3.SA")
    create(:investment,
      id: 1,
      user: current_user,
      item: petrobras,
      quantity: 1,
      value_invested: 488,
      invested_at: Date.today)

    login_as(current_user, scope: :user)
  end

  scenario "User updates an investment", js: true do
    visit edit_investment_path(1)

    expect(page).to have_text("Editar investimento")

    within("#edit_investment_1") do
      fill_in with: "VALE3", id: "item_dropdown_input"
      click_button "VALE3.SA", wait: 10

      fill_in "Quantidade", with: "5"
      fill_in "Valor investido", with: "$2.000,00"
      fill_in "Investido em", with: "2020-01-01"
    end

    click_button "Atualizar Investimento"

    expect(page).to have_text("Investimento atualizado com sucesso")

    expect(current_path).to eq(item_path(2))
  end

  scenario "User submits with empty fields", js: true do
    visit edit_investment_path(1)

    expect(page).to have_text("Editar investimento")

    within("#edit_investment_1") do
      fill_in "Quantidade", with: ""
      fill_in "Valor investido", with: ""
      fill_in "Investido em", with: ""
    end

    click_button "Atualizar Investimento"

    expect(page).to have_text("Por favor, verifique os problemas abaixo")
    expect(page).to have_text("Quantidade não pode ficar em branco e Quantidade não é um número")
    expect(page).to have_text("Investido em não pode ficar em branco")
  end
end
