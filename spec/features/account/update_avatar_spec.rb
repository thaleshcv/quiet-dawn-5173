# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Update avatar", type: :feature do
  let(:current_user) { create(:user, email: "capybara@test.com", password: "mastersekret") }

  before { login_as(current_user, scope: :user) }

  scenario "success" do
    visit edit_user_registration_path("profile")

    expect(page).to have_text("Editar cadastro")

    within("#edit_user") do
      page.attach_file("user_avatar", "/home/buster/Downloads/tux_scream.jpeg")
      fill_in "Senha atual", with: "mastersekret"

      click_button "Atualizar Usuario"
    end

    expect(page).to have_text("Sua conta foi atualizada com sucesso")
  end

  scenario "when user provides a wrong password" do
    visit edit_user_registration_path("profile")

    expect(page).to have_text("Editar cadastro")

    within("#edit_user") do
      page.attach_file("user_avatar", "/home/buster/Downloads/tux_scream.jpeg")
      fill_in "Senha atual", with: "wrongsekret"

      click_button "Atualizar Usuario"
    end

    expect(page).to have_text("Falha! Algo deu errado")
    expect(page).to have_text("Senha atual não é válido")
  end
end
