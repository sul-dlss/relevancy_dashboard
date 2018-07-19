require "rails_helper"

RSpec.describe EndpointsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/endpoints").to route_to("endpoints#index")
    end

    it "routes to #new" do
      expect(:get => "/endpoints/new").to route_to("endpoints#new")
    end

    it "routes to #show" do
      expect(:get => "/endpoints/1").to route_to("endpoints#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/endpoints/1/edit").to route_to("endpoints#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/endpoints").to route_to("endpoints#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/endpoints/1").to route_to("endpoints#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/endpoints/1").to route_to("endpoints#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/endpoints/1").to route_to("endpoints#destroy", :id => "1")
    end

  end
end
