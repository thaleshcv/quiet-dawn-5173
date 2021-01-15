require "rails_helper"

RSpec.describe InvestmentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/investments").to route_to("investments#index")
    end

    it "routes to #new" do
      expect(get: "/investments/new").to route_to("investments#new")
    end

    it "routes to #show" do
      expect(get: "/investments/1").to route_to("investments#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/investments/1/edit").to route_to("investments#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/investments").to route_to("investments#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/investments/1").to route_to("investments#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/investments/1").to route_to("investments#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/investments/1").to route_to("investments#destroy", id: "1")
    end
  end
end
