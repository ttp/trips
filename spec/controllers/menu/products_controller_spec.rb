require 'rails_helper'

describe Menu::ProductsController do
  let(:category) { FactoryGirl.create :menu_product_category }
  let(:valid_attributes) do
    {
      name: 'Name',
      product_category_id: category.id,
      calories: 10,
      proteins: 10,
      fats: 10,
      carbohydrates: 10
    }
  end

  context 'As user' do
    before do
      sign_in create(:user, :admin)
    end

    describe 'GET index' do
      it 'assigns all menu_products as @menu_products' do
        product = Menu::Product.create! valid_attributes
        get :index
        assigns(:menu_products).should eq([product])
      end
    end

    describe 'GET show' do
      it 'assigns the requested menu_product as @menu_product' do
        product = Menu::Product.create! valid_attributes
        get :show, params: { id: product.to_param }
        assigns(:menu_product).should eq(product)
      end
    end

    describe 'GET new' do
      it 'assigns a new menu_product as @menu_product' do
        get :new
        assigns(:menu_product).should be_a_new(Menu::Product)
      end
    end

    describe 'GET edit' do
      it 'assigns the requested menu_product as @menu_product' do
        product = Menu::Product.create! valid_attributes
        get :edit, params: { id: product.to_param }
        assigns(:menu_product).should eq(product)
      end
    end

    describe 'POST create' do
      describe 'with valid params' do
        it 'creates a new Menu::Product' do
          expect do
            post :create, params: { menu_product: valid_attributes }
          end.to change(Menu::Product, :count).by(1)
        end

        it 'assigns a newly created menu_product as @menu_product' do
          post :create, params: { menu_product: valid_attributes }
          assigns(:menu_product).should be_a(Menu::Product)
          assigns(:menu_product).should be_persisted
        end

        it 'redirects to the created menu_product' do
          post :create, params: { menu_product: valid_attributes }
          response.should redirect_to(menu_products_url)
        end
      end

      describe 'with invalid params' do
        it 'assigns a newly created but unsaved menu_product as @menu_product' do
          # Trigger the behavior that occurs when invalid params are submitted
          Menu::Product.any_instance.stub(:save).and_return(false)
          post :create, params: { menu_product: { name: ''  } }
          assigns(:menu_product).should be_a_new(Menu::Product)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Menu::Product.any_instance.stub(:save).and_return(false)
          post :create, params: { menu_product: { name: ''  } }
          response.should render_template('new')
        end
      end
    end

    describe 'PUT update' do
      describe 'with valid params' do
        it 'updates the requested menu_product' do
          product = Menu::Product.create! valid_attributes
          Menu::Product.any_instance.should_receive(:update).with('name' => 'new name')
          put :update, params: { id: product.to_param, menu_product: { 'name' =>  'new name' } }
        end

        it 'assigns the requested menu_product as @menu_product' do
          product = Menu::Product.create! valid_attributes
          put :update, params: {id: product.to_param, menu_product: valid_attributes }
          assigns(:menu_product).should eq(product)
        end

        it 'redirects to the menu_product' do
          product = Menu::Product.create! valid_attributes
          put :update, params: {id: product.to_param, menu_product: valid_attributes }
          response.should redirect_to(menu_products_path)
        end
      end

      describe 'with invalid params' do
        it 'assigns the menu_product as @menu_product' do
          product = Menu::Product.create! valid_attributes
          Menu::Product.any_instance.stub(:update).and_return(false)
          put :update, params: { id: product.to_param, menu_product: { name: ''  } }
          assigns(:menu_product).should eq(product)
        end

        it "re-renders the 'edit' template" do
          product = Menu::Product.create! valid_attributes
          Menu::Product.any_instance.stub(:update).and_return(false)
          put :update, params: { id: product.to_param, menu_product: { name: '' } }
          response.should render_template('edit')
        end
      end
    end

    describe 'DELETE destroy' do
      it 'destroys the requested menu_product' do
        product = Menu::Product.create! valid_attributes
        expect do
          delete :destroy, params: { id: product.to_param }
        end.to change(Menu::Product, :count).by(-1)
      end

      it 'redirects to the menu_products list' do
        product = Menu::Product.create! valid_attributes
        delete :destroy, params: { id: product.to_param }
        response.should redirect_to(menu_products_url)
      end
    end
  end

  context 'As guest' do
    describe 'GET new' do
      it 'redirects to root' do
        get :new, {}
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'GET edit' do
      it 'redirects to root' do
        product = Menu::Product.create! valid_attributes
        get :edit, params: { id: product.to_param }
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'POST create' do
      it 'redirects to root' do
        post :create, params: { menu_product: valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'PUT update' do
      it 'redirects to root' do
        product = Menu::Product.create! valid_attributes
        put :update, params: { id: product.to_param, menu_product: valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'DELETE destroy' do
      it 'redirects to root' do
        product = Menu::Product.create! valid_attributes
        delete :destroy, params: { id: product.to_param }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
