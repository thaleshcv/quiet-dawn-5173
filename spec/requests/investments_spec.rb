# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/investments", type: :request do
  let(:current_user) { create(:user) }

  let(:valid_parameters) do
    { investment: attributes_for(:investment, item_id: item.id).except(:id) }
  end

  let(:invalid_parameters) do
    {
      investment: {
        item_id: "",
        quantity: "",
        value_invested: "",
        invested_at: ""
      }
    }
  end

  before { login_as(current_user, scope: :user) }

  describe "GET /index" do
    before { create_list(:investment, 3, user: current_user) }

    it "renders a successful response" do
      expect(Investment).to receive(:for_portfolio).and_call_original

      get investments_url

      expect(response).to be_successful
      expect(assigns(:portfolio)).to be_truthy
      expect(assigns(:investment_totals)).to be_instance_of(InvestmentTotalsFacade)
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_investment_url

      expect(response).to be_successful
      expect(assigns(:investment)).to be_instance_of(Investment)
    end

    context "when passing an item_id as parameter" do
      it "an item is preselected" do
        get new_investment_url(item_id: 1)

        expect(response).to be_successful
        expect(assigns(:investment)).to be_instance_of(Investment)
        expect(assigns(:investment).item_id).to eq(1)
      end
    end
  end

  describe "GET /edit" do
    context "when authorized" do
      subject { create(:investment, id: 1, user: current_user) }

      it "render a successful response" do
        get edit_investment_url(subject)

        expect(response).to be_successful
        expect(assigns(:investment)).to eq(subject)
      end
    end

    context "trying to edit another user's investment" do
      subject { create(:investment, id: 1) }

      it "render a :not_found response" do
        get edit_investment_url(subject)

        expect(response).to have_http_status(404)
        expect(assigns(:investment)).to be_falsy
      end
    end
  end

  describe "POST /create" do
    let(:item) { create(:item) }

    context "with valid parameters" do
      it "creates a new Investment" do
        expect do
          post investments_url, params: valid_parameters
        end.to change(Investment, :count).by(1)
      end

      it "redirects to item" do
        post investments_url, params: valid_parameters
        expect(response).to redirect_to(item_url(Investment.last.item_id))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Investment" do
        expect do
          post investments_url, params: invalid_parameters
        end.to change(Investment, :count).by(0)
      end

      it "re-renders :new template" do
        post investments_url, params: invalid_parameters
        expect(response).to be_successful
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH /update" do
    subject { create(:investment, id: 1, user: current_user) }

    before { create(:item, id: 9) }

    context "with valid parameters" do
      let(:new_attributes) do
        {
          item_id: "9",
          value_invested: "888.00",
          invested_at: "2020-12-31",
          quantity: "8"
        }
      end

      it "updates the requested investment" do
        patch investment_url(subject), params: { investment: new_attributes }
        subject.reload

        expect(subject.valid?).to be_truthy
        expect(subject.item_id).to eq(9)
        expect(subject.value_invested).to eq(888.0)
        expect(subject.quantity).to eq(8)
        expect(subject.invested_at.to_s).to eq("2020-12-31")
      end

      it "redirects to item" do
        patch investment_url(subject), params: { investment: new_attributes }
        subject.reload

        expect(response).to redirect_to(item_url(subject.item_id))
      end
    end

    context "with invalid parameters" do
      it "re-renders :edit template" do
        patch investment_url(subject), params: invalid_parameters
        expect(response).to be_successful
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE /destroy" do
    subject { create(:investment, id: 1, user: current_user) }

    it "destroys the requested investment" do
      expect do
        delete investment_url(subject)
      end.to change(Investment, :count).by(-1)
    end

    it "redirects to the item page" do
      delete investment_url(subject)
      expect(response).to redirect_to(subject.item)
    end
  end
end
