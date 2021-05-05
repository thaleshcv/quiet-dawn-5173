# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Explore items", type: :feature do
  let(:current_user) { create(:user, email: "capybara@test.com", password: "mastersekret") }

  let!(:petrobras) { create(:item, id: 484, name: "PETROBRAS", abbreviation: "PETR4.SA") }

  before { login_as(current_user, scope: :user) }

  scenario "no user items", js: true do
    visit explore_path

    expect(page).to have_selector("img#thinking")
    expect(page).to have_text("Seus itens aparecerão aqui quando você incluir seus investimentos")
  end

  scenario "with user items", js: true do
    create(:investment, user: current_user, item: petrobras)

    visit explore_path

    expect(page).to have_text("Seus itens")
    expect(page).to have_selector("#user-item-484")
  end

  scenario "searching an item", js: true do
    visit explore_path

    within("#explore_form") do
      fill_in with: "PETR4", id: "item_dropdown_input"
      click_button "PETR4.SA", wait: 10
    end

    expect(page.find("#item_dropdown_input").value).to eq("PETR4.SA PETROBRAS")
  end
end
