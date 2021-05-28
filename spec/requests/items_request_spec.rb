# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Items", type: :request do
  let(:current_user) { create(:user) }

  before { login_as(current_user, scope: :user) }

  describe "GET /items" do
    it "returns a list of Items" do
      expected_items = create_list(:item, 2)

      allow(Item).to receive(:abbreviation_or_name_like).and_return(expected_items)

      get items_path

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response.body).to eq(expected_items.to_json)
    end
  end

  describe "GET /items/1" do
    it "finds and renders an item" do
      expected_item = build(:item, id: 1)

      allow(Item).to receive(:find).with("1").and_return(expected_item)

      investment_totals_double = instance_double(InvestmentTotalsFacade,
        quantity: 0,
        total_invested: 0,
        total_accumulated: 0,
        difference_in_percent: 0)

      allow(InvestmentTotalsFacade).to(
        receive(:new).with(any_args).and_return(investment_totals_double)
      )

      accumulated_value_chart_double = instance_double(AccumulatedValueChartFacade,
        accumulated_series: [],
        invested_series: [],
        minmax_chart_value: [])

      allow(AccumulatedValueChartFacade).to(
        receive(:new).with(any_args).and_return(accumulated_value_chart_double)
      )

      get item_path(expected_item)

      expect(response).to render_template(:show)
      expect(assigns(:item)).to eq(expected_item)
      expect(assigns(:investment_totals)).to eq(investment_totals_double)
      expect(assigns(:accumulated_value_chart)).to eq(accumulated_value_chart_double)
    end
  end

  describe "GET /items/1/accumulated" do
    it "returns accumulated value chart data" do
      accumulated_value_chart_double = instance_double(AccumulatedValueChartFacade,
        accumulated_series: [],
        invested_series: [],
        minmax_chart_value: [])

      allow(AccumulatedValueChartFacade).to(
        receive(:new).with(any_args).and_return(accumulated_value_chart_double)
      )

      get accumulated_item_path(1), params: { format: :js }, xhr: true

      expect(response).to render_template(:accumulated)
      expect(response.content_type).to eq("text/javascript; charset=utf-8")
      expect(assigns(:chart_data)).to(
        match_array([{ name: "Accumulated", data: [] }, { name: "Invested", data: [] }])
      )
    end
  end
end
