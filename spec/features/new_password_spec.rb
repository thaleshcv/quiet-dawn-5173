require "rails_helper"

RSpec.feature "User resets password", type: :feature do
  scenario "with valid email" do
    create(:user, email: "capybara@test.com", password: "mastersekret")

    visit new_user_password_path

    within("#new_user") do
      fill_in "Email", with: "capybara@test.com"
    end

    click_button "Enviar instruções para redefinir minha senha"

    expect(page).to have_text("Dentro de minutos, você receberá um e-mail com instruções para a troca da sua senha")
  end

  scenario "with invalid email" do
    create(:user, email: "capybara@test.com", password: "mastersekret")

    visit new_user_password_path

    within("#new_user") do
      fill_in "Email", with: "wrong_email@test.com"
    end

    click_button "Enviar instruções para redefinir minha senha"

    expect(page).to have_text("Falha! Algo deu errado")
    expect(page).to have_text("Email não encontrado")
  end
end
