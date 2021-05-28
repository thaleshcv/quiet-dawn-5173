# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Reports", type: :request do
  let(:current_user) { create(:user) }

  before { login_as(current_user, scope: :user) }

  let(:report_real) { create(:report) }
  let(:report_double) { double("report") }

  describe "GET /index" do
    it "returns current user's reports" do
      allow(report_double).to receive(:order).and_return([report_real])

      report_scope_double = instance_double(ReportPolicy::Scope, resolve: report_double)

      allow(ReportPolicy::Scope).to(
        receive(:new).with(current_user, any_args).and_return(report_scope_double)
      )

      get reports_path

      expect(response).to have_http_status(:success)
      expect(assigns(:reports)).to match_array([report_real])
    end
  end

  describe "GET /show" do
    it "finds and renders a report" do
      allow(report_double).to receive(:find).with("1").and_return(report_real)

      report_scope_double = instance_double(ReportPolicy::Scope, resolve: report_double)

      allow(ReportPolicy::Scope).to(
        receive(:new).with(current_user, any_args).and_return(report_scope_double)
      )

      get report_path(1)

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
      expect(assigns(:report)).to eq(report_real)
    end
  end
end
