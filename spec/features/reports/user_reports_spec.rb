# frozen_string_literal: true

require "rails_helper"

RSpec.feature "User reports", type: :feature do
  let(:current_user) { create(:user, email: "capybara@test.com", password: "mastersekret") }

  before { login_as(current_user, scope: :user) }

  scenario "no reports" do
    visit reports_path

    expect(page).to have_text("Relatórios")
    expect(page).to have_selector("img#thinking")
    expect(page).to have_text("Desculpe. Você ainda não possui relatórios")
  end

  scenario "with reports" do
    create(:report, user: current_user)

    visit reports_path

    expect(page).to have_text("Relatórios")
    expect(page).to have_selector("table#user-reports")
  end
end
