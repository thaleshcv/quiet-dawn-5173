require "rails_helper"

RSpec.feature "Users signs up", type: :feature do
  scenario "with valid data" do
    visit new_user_registration_path

    within("#new_user") do
      fill_in "Email", with: "capybara@test.com"
      fill_in "Senha", with: "mastersekret"
      fill_in "Confirmação de senha", with: "mastersekret"
    end

    click_button "Registrar"

    expect(page).to have_text("Login efetuado com sucesso")
  end

  scenario "with wrong password confirmation" do
    visit new_user_registration_path

    within("#new_user") do
      fill_in "Email", with: "capybara@test.com"
      fill_in "Senha", with: "mastersekret"
      fill_in "Confirmação de senha", with: "nosekret"
    end

    click_button "Registrar"

    expect(page).to have_text("Falha! Algo deu errado")
    expect(page).to have_text("Confirmação de senha não é igual a Senha")
  end

  scenario "with an empty form" do
    visit new_user_registration_path

    within("#new_user") do
      fill_in "Email", with: ""
      fill_in "Senha", with: ""
      fill_in "Confirmação de senha", with: ""
    end

    click_button "Registrar"

    expect(page).to have_text("Falha! Algo deu errado")
    expect(page).to have_text("Email não pode ficar em branco")
    expect(page).to have_text("Senha não pode ficar em branco")
  end

  scenario "with an email in use" do
    create(:user, email: "email_already_taken@test.com", password: "sekret")

    visit new_user_registration_path

    within("#new_user") do
      fill_in "Email", with: "email_already_taken@test.com"
      fill_in "Senha", with: "mastersekret"
      fill_in "Confirmação de senha", with: "mastersekret"
    end

    click_button "Registrar"

    expect(page).to have_text("Falha! Algo deu errado")
    expect(page).to have_text("Email já está em uso")
  end
end
