require "spec_helper"

describe Menu::ProductsController do
  describe "routing" do

    it "routes to #index" do
      get("/menu/products").should route_to("menu/products#index")
    end

    it "routes to #new" do
      get("/menu/products/new").should route_to("menu/products#new")
    end

    it "routes to #show" do
      get("/menu/products/1").should route_to("menu/products#show", :id => "1")
    end

    it "routes to #edit" do
      get("/menu/products/1/edit").should route_to("menu/products#edit", :id => "1")
    end

    it "routes to #create" do
      post("/menu/products").should route_to("menu/products#create")
    end

    it "routes to #update" do
      put("/menu/products/1").should route_to("menu/products#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/menu/products/1").should route_to("menu/products#destroy", :id => "1")
    end

  end
end
