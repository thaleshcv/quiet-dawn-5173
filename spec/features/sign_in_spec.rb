require "rails_helper"

RSpec.feature "User signs in", type: :feature do
  before { create(:user, email: "capybara@test.com", password: "mastersekret") }

  scenario "with valid credentials" do
    visit new_user_session_path

    within("#new_user") do
      fill_in "Email", with: "capybara@test.com"
      fill_in "Senha", with: "mastersekret"
    end

    click_button "Entrar"

    expect(page).to have_text("Login efetuado com sucesso")
  end

  scenario "with invalid credentials" do
    visit new_user_session_path

    within("#new_user") do
      fill_in "Email", with: "capybara@test.com"
      fill_in "Senha", with: "wrongpassword"
    end

    click_button "Entrar"

    expect(page).to have_text("Email ou senha inválida")
  end
end
