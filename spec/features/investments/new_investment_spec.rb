require "rails_helper"

RSpec.feature "New investment", type: :feature do
  let!(:item) { create(:item, name: "PETROBRAS", abbreviation: "PETR4.SA") }

  before do
    current_user = create(:user, email: "capybara@test.com", password: "mastersekret")
    login_as(current_user, scope: :user)
  end

  scenario "User creates a new investment", js: true do
    visit new_investment_path

    expect(page).to have_text("Novo investimento")

    within("#new_investment") do
      fill_in with: "PETR4", id: "item_dropdown_input"
      click_button "PETR4.SA", wait: 10

      fill_in "Quantidade", with: "5"
      fill_in "Valor investido", with: "$1.000,00"
      fill_in "Investido em", with: "2020-01-01"

      click_button "Criar Investimento"
    end

    expect(page).to have_text("Investimento criado com sucesso")

    expect(current_path).to eq(item_path(item))
  end

  scenario "User submits an empty form", js: true do
    visit new_investment_path

    expect(page).to have_text("Novo investimento")

    click_button "Criar Investimento"

    expect(page).to have_text("Novo investimento")

    # checking errors
    expect(page).to have_text("Por favor, verifique os problemas abaixo")
    expect(page).to have_text("Item é obrigatório(a) e não pode ficar em branco")
    expect(page).to have_text("Quantidade não pode ficar em branco e Quantidade não é um número")
    expect(page).to have_text("Investido em não pode ficar em branco")
  end
end
