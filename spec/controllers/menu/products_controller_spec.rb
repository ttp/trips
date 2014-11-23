require 'spec_helper'

describe Menu::ProductsController do
  # This should return the minimal set of attributes required to create a valid
  # Menu::Product. As you add validations to Menu::Product, be sure to
  # adjust the attributes here as well.
  let(:category) { FactoryGirl.create :menu_product_category }
  let(:valid_attributes) {
    {
      name: 'Name',
      product_category_id: category.id,
      calories: 10,
      proteins: 10,
      fats: 10,
      carbohydrates: 10
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Menu::ProductsController. Be sure to keep this updated too.
  before do
    sign_in create(:user, :admin)
  end

  describe "GET index" do
    it "assigns all menu_products as @menu_products" do
      product = Menu::Product.create! valid_attributes
      get :index, {}
      assigns(:menu_products).should eq([product])
    end
  end

  describe "GET show" do
    it "assigns the requested menu_product as @menu_product" do
      product = Menu::Product.create! valid_attributes
      get :show, {:id => product.to_param}
      assigns(:menu_product).should eq(product)
    end
  end

  describe "GET new" do
    it "assigns a new menu_product as @menu_product" do
      get :new, {}
      assigns(:menu_product).should be_a_new(Menu::Product)
    end
  end

  describe "GET edit" do
    it "assigns the requested menu_product as @menu_product" do
      product = Menu::Product.create! valid_attributes
      get :edit, {:id => product.to_param}
      assigns(:menu_product).should eq(product)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Menu::Product" do
        expect {
          post :create, {:menu_product => valid_attributes}
        }.to change(Menu::Product, :count).by(1)
      end

      it "assigns a newly created menu_product as @menu_product" do
        post :create, {:menu_product => valid_attributes}
        assigns(:menu_product).should be_a(Menu::Product)
        assigns(:menu_product).should be_persisted
      end

      it "redirects to the created menu_product" do
        post :create, {:menu_product => valid_attributes}
        response.should redirect_to(menu_products_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved menu_product as @menu_product" do
        # Trigger the behavior that occurs when invalid params are submitted
        Menu::Product.any_instance.stub(:save).and_return(false)
        post :create, {:menu_product => {  }}
        assigns(:menu_product).should be_a_new(Menu::Product)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Menu::Product.any_instance.stub(:save).and_return(false)
        post :create, {:menu_product => {  }}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested menu_product" do
        product = Menu::Product.create! valid_attributes
        # Assuming there are no other menu_products in the database, this
        # specifies that the Menu::Product created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Menu::Product.any_instance.should_receive(:update).with({ "these" => "params" })
        put :update, {:id => product.to_param, :menu_product => { "these" => "params" }}
      end

      it "assigns the requested menu_product as @menu_product" do
        product = Menu::Product.create! valid_attributes
        put :update, {:id => product.to_param, :menu_product => valid_attributes}
        assigns(:menu_product).should eq(product)
      end

      it "redirects to the menu_product" do
        product = Menu::Product.create! valid_attributes
        put :update, {:id => product.to_param, :menu_product => valid_attributes}
        response.should redirect_to(menu_products_path)
      end
    end

    describe "with invalid params" do
      it "assigns the menu_product as @menu_product" do
        product = Menu::Product.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Menu::Product.any_instance.stub(:update).and_return(false)
        put :update, {:id => product.to_param, :menu_product => {  }}
        assigns(:menu_product).should eq(product)
      end

      it "re-renders the 'edit' template" do
        product = Menu::Product.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Menu::Product.any_instance.stub(:update).and_return(false)
        put :update, {:id => product.to_param, :menu_product => { name: '' }}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested menu_product" do
      product = Menu::Product.create! valid_attributes
      expect {
        delete :destroy, {:id => product.to_param}
      }.to change(Menu::Product, :count).by(-1)
    end

    it "redirects to the menu_products list" do
      product = Menu::Product.create! valid_attributes
      delete :destroy, {:id => product.to_param}
      response.should redirect_to(menu_products_url)
    end
  end

end
