# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Show report", type: :feature do
  let(:current_user) { create(:user, email: "capybara@test.com", password: "mastersekret") }

  before { login_as(current_user, scope: :user) }
  subject { create(:report, user: current_user) }

  scenario "success" do
    visit report_path(subject)

    expect(page).to have_text("Relatório de #{I18n.l(subject.created_at, format: :long)}")
    expect(page).to have_selector("table#report-payload")
  end
end
