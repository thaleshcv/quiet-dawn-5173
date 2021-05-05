# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Update settings", type: :feature do
  let(:current_user) { create(:user, email: "capybara@test.com", password: "mastersekret") }

  before { login_as(current_user, scope: :user) }

  scenario "success", js: true do
    visit edit_user_registration_path("settings")

    expect(page).to have_text("Editar cadastro")

    accept_confirm { click_button "Exclua meu cadastro" }

    # must go to landing page after destroy account
    expect(page).to have_text("Bem-vindo ao seu gerenciador de investimentos")
  end
end
